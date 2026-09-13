#!/usr/bin/env python3
"""Independent, paired response-contract evaluation. Live calls are explicit."""
import argparse
import csv
import hashlib
import json
import os
from pathlib import Path
import shutil
import signal
import subprocess
import tempfile
import time

ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent


def cases():
    records = [json.loads(line) for line in (HERE / 'cases.jsonl').read_text().splitlines()]
    ids = set()
    for case in records:
        assert isinstance(case['id'], str) and case['id'] and case['id'] not in ids
        assert case['prompt'].startswith('Sia ') and case['review']
        for field in ('required', 'forbidden'):
            assert isinstance(case[field], list) and all(isinstance(s, str) for s in case[field])
        ids.add(case['id'])
    assert records
    return records


def contracts():
    protocol = (ROOT / 'src/managed/.ai/sia.md').read_text()
    response = protocol.split('## User-facing responses\n', 1)[1].split('\n## ', 1)[0].strip()
    delivery = (ROOT / 'src/managed/.ai/workflows/sia/delivery.md').read_text()
    simplicity = delivery.split('Add behavior and mechanisms', 1)[1].split('\n\n', 1)[0]
    return {'baseline': (HERE / 'baseline.txt').read_text(),
            'candidate': response + '\n\nAdd behavior and mechanisms' + simplicity + '\n'}


def command(host, model, effort, prompt, response):
    if host == 'codex':
        return ['codex', 'exec', '--ephemeral', '--ignore-user-config', '--ignore-rules',
                '--skip-git-repo-check', '--sandbox', 'read-only', '--json',
                '--config', 'approval_policy="never"', '--config',
                'model_reasoning_effort=' + json.dumps(effort), '--model', model,
                '--color', 'never', '--output-last-message', str(response), prompt]
    return ['claude', '--print', '--safe-mode', '--no-session-persistence',
            '--setting-sources', '', '--strict-mcp-config', '--mcp-config', '{"mcpServers":{}}',
            '--tools', '', '--disable-slash-commands', '--no-chrome', '--permission-mode', 'dontAsk',
            '--output-format', 'json', '--model', model, '--effort', effort, prompt]


def probe(host):
    """Fail closed when installed CLI cannot provide the isolation controls."""
    try:
        version = subprocess.run([host, '--version'], capture_output=True, text=True, timeout=10)
        help_args = [host, 'exec', '--help'] if host == 'codex' else [host, '--help']
        help_result = subprocess.run(help_args, capture_output=True, text=True, timeout=10)
    except (OSError, subprocess.TimeoutExpired) as error:
        return {'status': 'UNAVAILABLE', 'reason': str(error), 'version': 'unknown'}
    required = [arg for arg in command(host, 'model', 'medium', 'prompt', Path('response'))
                if arg.startswith('--')]
    missing = [arg for arg in required if arg not in help_result.stdout]
    available = version.returncode == help_result.returncode == 0 and not missing
    return {'status': 'AVAILABLE' if available else 'UNAVAILABLE',
            'version': version.stdout.strip() or 'unknown', 'reason': ', '.join(missing)}


def telemetry(raw):
    """Only report explicit final usage; never sum duplicate streaming counters."""
    usage = {}
    model = 'unknown'
    response = None
    for line in raw.splitlines():
        try:
            item = json.loads(line)
        except ValueError:
            continue
        if not isinstance(item, dict):
            continue
        if item.get('type') == 'result':
            if item.get('is_error'):
                return {'error': True}
            response = item.get('result')
            usage = item.get('usage') or {}
            reported = item.get('modelUsage') or {}
            if len(reported) == 1:
                model = next(iter(reported))
        elif item.get('type') == 'turn.completed':
            usage = item.get('usage') or {}
        if isinstance(item.get('model'), str):
            model = item['model']
    return {'actual_model': model, 'input_tokens': usage.get('input_tokens', 'unknown'),
            'output_tokens': usage.get('output_tokens', 'unknown'), 'response': response}


def execute(argv, cwd, env, timeout, max_bytes=4 * 1024 * 1024):
    """Bound process-group lifetime and captured output, including child processes."""
    with tempfile.TemporaryFile() as stdout, tempfile.TemporaryFile() as stderr:
        process = subprocess.Popen(argv, cwd=cwd, env=env, stdin=subprocess.DEVNULL,
                                   stdout=stdout, stderr=stderr, start_new_session=True)
        deadline = time.monotonic() + timeout
        status = None
        try:
            while process.poll() is None:
                if os.fstat(stdout.fileno()).st_size + os.fstat(stderr.fileno()).st_size > max_bytes:
                    status = 125
                    break
                if time.monotonic() >= deadline:
                    status = 124
                    break
                time.sleep(0.02)
        finally:
            # Also clean up children left running after their parent exits.
            try:
                os.killpg(process.pid, signal.SIGKILL)
            except ProcessLookupError:
                pass
            process.wait()
        size = os.fstat(stdout.fileno()).st_size + os.fstat(stderr.fileno()).st_size
        status = status if status is not None else (125 if size > max_bytes else process.returncode)
        stdout.seek(0)
        stderr.seek(0)
        out = stdout.read(max_bytes)
        err = stderr.read(max_bytes - len(out))
        return subprocess.CompletedProcess(argv, status, out.decode(errors='replace'), err.decode(errors='replace'))


def run_call(host, model, effort, prompt, destination, timeout):
    destination.mkdir(parents=True)
    (destination / 'prompt.txt').write_text(prompt)
    response = destination / 'response.txt'
    argv = command(host, model, effort, prompt, response)
    (destination / 'command.json').write_text(json.dumps(argv, indent=2))
    started = time.monotonic()
    with tempfile.TemporaryDirectory(prefix='sia-response-') as temporary:
        work = Path(temporary) / 'work'
        work.mkdir()
        env = os.environ.copy()
        # Authentication only; no shared Codex instructions, skills, rules or configuration.
        if host == 'codex':
            private_home = Path(temporary) / 'codex'
            private_home.mkdir(mode=0o700)
            auth = Path(env.get('CODEX_HOME', str(Path.home() / '.codex'))) / 'auth.json'
            if auth.is_file():
                shutil.copyfile(auth, private_home / 'auth.json')
                (private_home / 'auth.json').chmod(0o600)
            env['CODEX_HOME'] = str(private_home)
        try:
            result = execute(argv, cwd=work, env=env, timeout=timeout)
            raw, stderr, status = result.stdout, result.stderr, result.returncode
        except OSError as error:
            raw, stderr, status = '', str(error), 127
    (destination / 'raw.jsonl').write_text(raw)
    (destination / 'stderr.txt').write_text(stderr)
    data = telemetry(raw)
    if host == 'claude' and isinstance(data.get('response'), str):
        response.write_text(data['response'])
    data.pop('response', None)
    data.update(exit_code=status, elapsed_seconds=round(time.monotonic() - started, 3))
    data['status'] = ('AVAILABLE' if status == 0 and not data.get('error') and
                      response.is_file() and response.stat().st_size else 'UNAVAILABLE')
    (destination / 'metadata.json').write_text(json.dumps(data, indent=2))
    return data


def score(case, response, destination):
    checks = [('required', value, value.lower() in response.lower()) for value in case['required']]
    checks += [('forbidden', value, value.lower() not in response.lower()) for value in case['forbidden']]
    with (destination / 'assertions.tsv').open('w') as stream:
        writer = csv.writer(stream, delimiter='\t')
        writer.writerows(('PASS' if passed else 'FAIL', kind, value) for kind, value, passed in checks)
    return 'PASS' if all(check[2] for check in checks) else 'FAIL'


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('mode', choices=['check', 'live'], nargs='?', default='check')
    parser.add_argument('artifacts', nargs='?', type=Path)
    parser.add_argument('--host', choices=['codex', 'claude'], default='codex')
    parser.add_argument('--model')
    parser.add_argument('--effort', choices=['low', 'medium', 'high', 'xhigh', 'max'])
    parser.add_argument('--repetitions', type=int, default=1)
    parser.add_argument('--timeout', type=int, default=120)
    args = parser.parse_args()
    records, arms = cases(), contracts()
    if args.mode == 'check':
        print(f'Validated {len(records)} concise-output cases; no model invoked.')
        return 0
    if not args.artifacts or not args.model or not args.effort:
        parser.error('live requires a new artifact directory, --model and --effort')
    if args.artifacts.exists() or args.repetitions < 1 or args.timeout < 1:
        parser.error('artifact directory must be new; repetitions and timeout must be positive')
    target = args.artifacts.resolve()
    target.mkdir(parents=True)
    context = (HERE / 'context.txt').read_text()
    instructions = {arm: context + '\n' + contract for arm, contract in arms.items()}
    for arm, instruction in instructions.items():
        (target / f'{arm}-instructions.txt').write_text(instruction)
    availability = probe(args.host)
    revision = subprocess.run(['git', '-C', str(ROOT), 'rev-parse', 'HEAD'],
                              capture_output=True, text=True).stdout.strip() or 'unknown'
    metadata = dict(host=args.host, requested_model=args.model, requested_effort=args.effort,
                    source_revision=revision, repetitions=args.repetitions, timeout_seconds=args.timeout,
                    instruction_hashes={arm: hashlib.sha256(text.encode()).hexdigest()
                                        for arm, text in instructions.items()}, **availability)
    (target / 'metadata.json').write_text(json.dumps(metadata, indent=2))
    if availability['status'] == 'UNAVAILABLE':
        print(f'UNAVAILABLE: {availability["reason"]}; evidence: {target}')
        return 2
    with (target / 'results.tsv').open('w') as stream, (target / 'review.md').open('w') as review:
        writer = csv.writer(stream, delimiter='\t')
        writer.writerow(['repetition', 'case', 'arm', 'fidelity', 'visible_chars', 'input_tokens',
                         'output_tokens', 'elapsed_seconds', 'readability_1_to_5', 'correctness', 'scope', 'simplicity'])
        for repetition in range(1, args.repetitions + 1):
            for case in records:
                review.write(f'## {case["id"]}, repetition {repetition}\n\n{case["review"]}\n\n')
                # Alternate order to reduce systematic ordering effects.
                for arm in (['baseline', 'candidate'] if repetition % 2 else ['candidate', 'baseline']):
                    relative = Path('runs') / f'{repetition}-{case["id"]}-{arm}'
                    destination = target / relative
                    data = run_call(args.host, args.model, args.effort,
                                    instructions[arm] + '\n\n' + case['prompt'], destination, args.timeout)
                    if data['status'] == 'UNAVAILABLE':
                        print(f'UNAVAILABLE: comparison stopped; evidence: {destination}')
                        return 2
                    response = (destination / 'response.txt').read_text()
                    fidelity = score(case, response, destination)
                    writer.writerow([repetition, case['id'], arm, fidelity, len(response),
                                     data['input_tokens'], data['output_tokens'], data['elapsed_seconds'],
                                     'pending', 'pending', 'pending', 'pending'])
                    stream.flush()
                    review.write(f'[{arm}]({relative}/response.txt)\n\n')
                review.write('Pair verdict (improved / tied / regressed): pending. Reason: pending.\n\n')
    print(f'Completed {len(records) * 2 * args.repetitions} calls. Human review required: {target}')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
