#!/usr/bin/env python3
"""Summarize benchmark accounting records; this does not run a benchmark."""
import json
import sys

METRICS = ('phase_seconds', 'cost_usd', 'input_tokens', 'cached_input_tokens',
           'output_tokens', 'reasoning_tokens', 'user_minutes')
PHASES = ('cold_start', 'bootstrap', 'implementation', 'review', 'retry')


def measure(value):
    if value == 'unknown':
        return None
    if isinstance(value, bool) or not isinstance(value, (int, float)) or value < 0:
        raise ValueError('metrics must be nonnegative numbers or unknown')
    if value != value or value == float('inf'):
        raise ValueError('metrics must be finite')
    return value


def totals(rows):
    result = {}
    for metric in METRICS:
        values = [measure(row.get(metric, 'unknown')) for row in rows]
        result[metric] = sum(values) if all(v is not None for v in values) else 'unknown'
        result[metric + '_known_subtotal'] = sum(v for v in values if v is not None)
    return result


def summarize(data):
    tasks = data['tasks']
    ids = [task['id'] for task in tasks]
    if not ids or any(not isinstance(ident, str) or not ident for ident in ids) or len(set(ids)) != len(ids):
        raise ValueError('task IDs must be nonempty and unique')
    for task in tasks:
        if task['quality_verdict'] not in ('pass', 'fail', 'pending', 'unavailable'):
            raise ValueError('quality verdict must be explicitly reviewed')
    rows = data['phases']
    for row in rows:
        if row['phase'] not in PHASES or row.get('task_id') not in ids + [None]:
            raise ValueError('invalid phase or task ID')
        if row.get('task_id') is None and row['phase'] not in ('cold_start', 'bootstrap'):
            raise ValueError('only cold-start/bootstrap can be shared')
        for total, subset in (('input_tokens', 'cached_input_tokens'), ('output_tokens', 'reasoning_tokens')):
            a, b = measure(row.get(total, 'unknown')), measure(row.get(subset, 'unknown'))
            if a is not None and b is not None and b > a:
                raise ValueError('token subsets cannot exceed inclusive totals')
    if not rows or any(not any(row.get('task_id') == ident for row in rows) for ident in ids):
        raise ValueError('every task needs accounting evidence')
    summary = totals(rows)
    successful = sum(task['quality_verdict'] == 'pass' for task in tasks)
    amortized = {metric: summary[metric] / successful if successful and summary[metric] != 'unknown'
                 else 'unknown' for metric in METRICS}
    wall = measure(data.get('end_to_end_wall_seconds', 'unknown'))
    return {'totals': summary, 'by_phase': {phase: totals([r for r in rows if r['phase'] == phase]) for phase in PHASES},
            'successful_tasks': successful, 'attempted_tasks': len(tasks),
            'amortized_per_successful_task': amortized,
            'end_to_end_wall_seconds': wall if wall is not None else 'unknown',
            'quality_verdicts': {task['id']: task['quality_verdict'] for task in tasks}}


if __name__ == '__main__':
    with open(sys.argv[1]) as stream:
        print(json.dumps(summarize(json.load(stream)), indent=2))
