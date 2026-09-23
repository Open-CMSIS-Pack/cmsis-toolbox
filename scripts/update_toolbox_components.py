#!/usr/bin/env python3
"""Update toolbox component pins from published GitHub releases."""

from __future__ import annotations

import argparse
import json
import subprocess
from pathlib import Path


COMPONENTS = {
    "schema": ("Open-CMSIS-Pack/Open-CMSIS-Pack-Spec", "v", "tags"),
    "buildmgr": ("Open-CMSIS-Pack/devtools", "tools/buildmgr/", "releases"),
    "projmgr": ("Open-CMSIS-Pack/devtools", "tools/projmgr/", "releases"),
    "cbridge": ("Open-CMSIS-Pack/generator-bridge", "v", "releases"),
    "cbuild": ("Open-CMSIS-Pack/cbuild", "v", "releases"),
    "cbuild2cmake": ("Open-CMSIS-Pack/cbuild2cmake", "v", "releases"),
    "cpackget": ("Open-CMSIS-Pack/cpackget", "v", "releases"),
    "packchk": ("Open-CMSIS-Pack/devtools", "tools/packchk/", "releases"),
    "svdconv": ("Open-CMSIS-Pack/devtools", "tools/svdconv/", "releases"),
    "vidx2pidx": ("Open-CMSIS-Pack/vidx2pidx", "v", "releases"),
}


def github_tags(repository: str) -> list[str]:
    result = subprocess.run(
        ["gh", "api", f"repos/{repository}/git/matching-refs/tags", "--paginate", "--slurp"],
        check=True, capture_output=True, text=True, encoding="utf-8",
    )
    pages = json.loads(result.stdout)
    return [entry["ref"].removeprefix("refs/tags/") for page in pages for entry in page]


def github_release_tags(repository: str) -> list[str]:
    result = subprocess.run(
        ["gh", "api", f"repos/{repository}/releases", "--paginate", "--slurp"],
        check=True, capture_output=True, text=True, encoding="utf-8",
    )
    pages = json.loads(result.stdout)
    return [
        release["tag_name"]
        for page in pages
        for release in page
        if not release["draft"] and not release["prerelease"]
    ]


def version_key(tag: str) -> tuple[int, ...] | None:
    version = tag.rsplit("/", 1)[-1].removeprefix("v")
    try:
        return tuple(int(part) for part in version.split("."))
    except ValueError:
        return None


def latest_version(repository: str, prefix: str, source: str) -> tuple[int, ...]:
    tags = github_release_tags(repository) if source == "releases" else github_tags(repository)
    candidates = [tag for tag in tags if tag.startswith(prefix) and version_key(tag) is not None]
    if not candidates:
        raise RuntimeError(f"No semantic-version {source} found for {repository} matching {prefix!r}")
    return max(version_key(tag) for tag in candidates if version_key(tag) is not None)


def update_manifest(manifest_path: Path) -> bool:
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    changed = False
    if set(manifest) != set(COMPONENTS) or not all(version_key(version) is not None for version in manifest.values()):
        raise RuntimeError("Manifest must contain one semantic version for every toolbox component")
    for name, (repository, prefix, source) in COMPONENTS.items():
        current_version = version_key(manifest[name])
        latest = latest_version(repository, prefix, source)
        if latest != current_version:
            latest_text = ".".join(map(str, latest))
            print(f"{name}: {manifest[name]} -> {latest_text}")
            manifest[name] = latest_text
            changed = True
    if changed:
        manifest_path.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    return changed


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("manifest", type=Path, nargs="?", default=Path(".github/toolbox-components.json"))
    arguments = parser.parse_args()
    return 0 if update_manifest(arguments.manifest) else 1


if __name__ == "__main__":
    raise SystemExit(main())
