"""Recover the latest available Git copy of media without changing app files.

Usage: python3 scripts/recover_storage_assets.py /tmp/etno-asset-recovery
Output contains upload-ready bucket folders plus a SHA-256 provenance manifest.
This recovers committed files, not student records or cloud-only uploads.
"""
import hashlib
import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
IMAGE_SUFFIXES = {'.png', '.jpg', '.jpeg', '.webp', '.svg', '.gif'}


def git(*args):
    return subprocess.check_output(['git', *args], cwd=ROOT)


def main(output):
    output = Path(output).resolve()
    if output.exists():
        raise SystemExit(f'Refusing to overwrite existing recovery directory: {output}')
    latest = {}
    commit = None
    for line in git('log', '--all', '--diff-filter=AM', '--format=COMMIT %H',
                    '--name-only', '--', 'assets', 'aset-sed').decode().splitlines():
        if line.startswith('COMMIT '):
            commit = line.split()[1]
        elif line and Path(line).suffix.lower() in IMAGE_SUFFIXES:
            latest.setdefault(line, commit)

    recovered = {}
    for path, revision in latest.items():
        local = ROOT / path
        data = local.read_bytes() if local.is_file() else git('show', f'{revision}:{path}')
        if path.startswith('assets/'):
            target = 'media-assets/' + path.removeprefix('assets/')
        else:
            target = path
        recovered[target] = (data, path, revision, 'working_tree' if local.is_file() else 'git')

    # These public URL spellings differ from their committed local filenames.
    aliases = {
        'colenak.png': 'colenak.png',
        'kimchi.png': 'kimchi.png',
        'orek-tempe.png': 'orek_tempe.png',
        'tape-ketan.png': 'tape_ketan.png',
        'tape-singkong.png': 'tape_singkong.png',
    }
    for target, source in aliases.items():
        recovered.setdefault('aset-sed/' + target, recovered['media-assets/images/' + source])

    manifest = []
    for target, (data, source, revision, origin) in sorted(recovered.items()):
        destination = output / 'buckets' / target
        destination.parent.mkdir(parents=True, exist_ok=True)
        destination.write_bytes(data)
        bucket, key = target.split('/', 1)
        manifest.append(dict(bucket=bucket, key=key, bytes=len(data),
                             sha256=hashlib.sha256(data).hexdigest(), source=source,
                             revision=revision, origin=origin))
    (output / 'manifest.json').write_text(json.dumps(manifest, indent=2) + '\n')
    for bucket in sorted({entry['bucket'] for entry in manifest}):
        entries = [entry for entry in manifest if entry['bucket'] == bucket]
        print(bucket, len(entries), 'files;', sum(entry['bytes'] for entry in entries), 'bytes')
    print('Recovery directory:', output)


if __name__ == '__main__':
    main(sys.argv[1])
