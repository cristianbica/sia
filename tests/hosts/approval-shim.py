#!/usr/bin/env python3
"""Deterministic Codex/Claude CLI stand-in; never contacts a model."""
import hashlib
import json
import os
from pathlib import Path
import sys
import time

args = sys.argv[1:]
if args == ['--version']:
    print('approval-shim 1')
    sys.exit(0)
claude = Path(sys.argv[0]).name == 'claude'
if claude:
    assert '--print' in args and 'stream-json' in args and 'dontAsk' in args
    assert '--no-session-persistence' not in args and '--dangerously-skip-permissions' not in args
else:
    assert args[0] == 'exec'
    assert '--json' in args and 'sandbox_mode="workspace-write"' in args
    assert 'approval_policy="never"' in args
assert '--ephemeral' not in args and '--last' not in args
prompt = args[-1]
fault = os.environ.get('SIA_APPROVAL_SHIM_FAULT', '')
if fault == 'timeout':
    time.sleep(5)
if fault == 'output-limit':
    print('x' * 1048577)
    sys.exit(0)
if fault == 'invalid-json':
    print('invalid trace')
    sys.exit(0)
if fault == 'host-failure':
    sys.exit(7)
if fault == 'unavailable-resume' and ('resume' in args or '--resume' in args):
    sys.exit(2)
if 'resume' in args or '--resume' in args:
    assert args[-2] == 'fixture-session'

def emit(kind, **values):
    if claude:
        if kind == 'thread.started':
            kind, values = 'system', {'subtype': 'init', 'session_id': values['thread_id'], 'model': 'shim-model'}
        elif kind == 'turn.completed':
            kind, values = 'result', {'subtype': 'success', 'usage': values.get('usage', {})}
        elif kind.startswith('item.'):
            item = values['item']
            if item['type'] == 'agent_message':
                kind, values = 'assistant', {'message': {'content': [{'type': 'text', 'text': item['text']}]}}
            else:
                if item['type'] == 'file_change':
                    name, data = 'Write', {'file_path': item['changes'][0]['path']}
                elif item['type'] == 'file_read':
                    name, data = 'Read', {'file_path': item['path']}
                else:
                    name, data = 'Bash', {'command': item['command']}
                print(json.dumps({'type': 'assistant', 'message': {'content': [{'type': 'tool_use',
                    'id': 'tool', 'name': name, 'input': data}]}}), flush=True)
                if kind == 'item.completed':
                    print(json.dumps({'type': 'user', 'message': {'content': [{'type': 'tool_result',
                        'tool_use_id': 'tool', 'content': 'ok', 'is_error': item.get('exit_code', 0) != 0}]}}), flush=True)
                return
    print(json.dumps({'type': kind, **values}), flush=True)

def say(text):
    emit('item.completed', item={'type': 'agent_message', 'text': text})

def write(path, text):
    emit('item.started', item={'type': 'file_change', 'changes': [{'path': path, 'kind': 'update'}]})
    Path(path).parent.mkdir(parents=True, exist_ok=True)
    Path(path).write_text(text)

if fault != 'missing-session':
    emit('thread.started', thread_id='wrong-session' if fault == 'wrong-session' and ('resume' in args or '--resume' in args) else 'fixture-session')
plan_path = '.ai/plans/2026-09-07-01-greeting.md'
block = '\nChange app.py greeting to Welcome. Check greeting. No external actions.\n'
digest = hashlib.sha256(block.encode()).hexdigest()
plan = ('---\noperation: implement\nworkflow: delivery\nskills: [repository-discovery, testing]\n---\n\n'
        '# Greeting\n\n<!-- sia:approval:start -->' + block + '<!-- sia:approval:end -->\n\n')
case = Path.cwd().name
standard = case in ('standard', 'continuation', 'passing-checks', 'pending-resume')
if prompt == 'Sia forge on':
    say('Forge enabled.')
elif (standard and not prompt.startswith('Sia approved')) or 'Sia plan:' in prompt:
    if fault == 'unauthorized-read':
        emit('item.started', item={'type': 'file_read', 'path': '.ai/plans/1999-01-01-01-unrelated.md'})
    if fault == 'bare-reads':
        for command in ('pwd', 'ls', 'git status', 'git diff'):
            emit('item.completed', item={'type': 'command_execution', 'command': command})
    if fault == 'silent-write':
        Path('app.py').write_text('broken\n')
    if fault == 'premature-write':
        write('app.py', 'broken\n')
    if fault == 'reverted-attempt':
        emit('item.started', item={'type': 'file_change', 'changes': [{'path': 'app.py', 'kind': 'update'}]})
    if fault == 'shell-attempt':
        emit('item.started', item={'type': 'command_execution', 'command': 'touch app.py'})
    if fault == 'opaque-command':
        emit('item.completed', item={'type': 'command_execution', 'command': 'python3 helper.py'})
    if fault == 'missing-announcement':
        # Separate unit coverage verifies announcement ordering.
        sys.exit(7)
    if standard and fault != 'missing-plan':
        content = plan + '<!-- sia:status pending-approval -->\n'
        if fault == 'reversed-plan':
            content = content.replace('sia:approval:start', 'sia:approval:tmp').replace('sia:approval:end', 'sia:approval:start').replace('sia:approval:tmp', 'sia:approval:end')
        if fault == 'invalid-plan':
            content += '<!-- sia:approved ' + digest + ' -->\n'
        write(plan_path, content)
    say(f'Please approve the plan {plan_path}.' if standard else 'Inline plan: change app.py greeting. Check greeting. No external actions. Please approve.')
else:
    if case == 'trivial':
        write('README.md', Path('README.md').read_text().replace('Welcomme', 'Welcome'))
    else:
        write('app.py', 'def greet(name):\n    return "Welcome " + name\n')
    if case in ('continuation', 'passing-checks'):
        say('Greeting updated; continuing with farewell.')
        if fault != 'abandoned-work':
            write('app.py', Path('app.py').read_text() + '\ndef farewell(name):\n    return "Goodbye " + name\n')
        if fault != 'missing-check':
            for _ in range(2 if fault == 'repeated-check' else 1):
                emit('item.completed', item={'type': 'command_execution', 'command': 'python3 -B -m unittest -v', 'exit_code': 0})
    if standard:
        content = plan + '<!-- sia:status complete -->\n<!-- sia:approved ' + digest + ' -->\n'
        if fault == 'wrong-digest':
            content = content.replace(digest, '0' * 64)
        write(plan_path, content)
    say('Completed and checked.')
if fault == 'incomplete-turn':
    sys.exit(0)
emit('turn.completed', usage={'input_tokens': 0, 'output_tokens': 0})
