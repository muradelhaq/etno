"""Read-only REST/Auth checks using only the app's public API key."""
import json
import re
import sys
from pathlib import Path
from urllib.error import HTTPError
from urllib.request import Request, urlopen


def main():
    source = (Path(__file__).resolve().parents[1] /
              'lib/core/services/supabase_service.dart').read_text()
    base = re.search(r"supabaseUrl\s*=\s*'([^']+)'", source).group(1)
    key = re.search(r"supabaseAnonKey\s*=\s*'([^']+)'", source).group(1)

    def get(path):
        request = Request(base + path, headers={'apikey': key})
        try:
            with urlopen(request, timeout=20) as response:
                return response.status, json.load(response)
        except HTTPError as error:
            return error.code, json.load(error)

    failures = []
    for table in ('users', 'quiz_results', 'case_study_answers', 'lab_records'):
        status, body = get(f'/rest/v1/{table}?select=id&limit=0')
        passed = status in (401, 403) and body.get('code') == '42501'
        print(f'{"PASS" if passed else "FAIL"}: {table}: '
              f'HTTP {status}; unauthenticated access must be denied')
        if not passed:
            failures.append(table)
    status, body = get('/rest/v1/module_assets?select=id&limit=0')
    passed = status == 200 and isinstance(body, list)
    print(f'{"PASS" if passed else "FAIL"}: public module_assets: HTTP {status}')
    if not passed:
        failures.append('module_assets')
    status, body = get('/auth/v1/settings')
    passed = status == 200 and body.get('external', {}).get('anonymous_users') is True
    print(f'{"PASS" if passed else "BLOCKED"}: Anonymous Sign-In')
    if not passed:
        failures.append('Anonymous Sign-In')
    return 1 if failures else 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except Exception as error:
        print(f'FAIL: {type(error).__name__}: {error}', file=sys.stderr)
        sys.exit(1)
