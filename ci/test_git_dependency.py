#!/usr/bin/env python3
"""Build and run a downstream pixi-build-mojo package against a Git revision."""

from __future__ import annotations

import argparse
import shutil
import subprocess
import tempfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
FIXTURE = ROOT / "ci" / "git-consumer"


def run(*command: str, cwd: Path) -> None:
    subprocess.run(command, cwd=cwd, check=True)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--platform", required=True)
    parser.add_argument("--repository", type=Path, default=ROOT)
    parser.add_argument("--revision")
    parser.add_argument("--pixi", default=shutil.which("pixi") or "pixi")
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    repository = args.repository.resolve()
    revision = args.revision
    if revision is None:
        revision = subprocess.check_output(
            ["git", "rev-parse", "HEAD"], cwd=repository, text=True
        ).strip()

    with tempfile.TemporaryDirectory(prefix="ziprs-git-consumer-") as temporary:
        consumer = Path(temporary)
        shutil.copytree(FIXTURE / "ziprs_ci_consumer", consumer / "ziprs_ci_consumer")
        shutil.copytree(FIXTURE / "tests", consumer / "tests")

        manifest = (FIXTURE / "pixi.toml.in").read_text()
        manifest = manifest.replace("@PLATFORM@", args.platform)
        manifest = manifest.replace("@ZIPRS_GIT@", repository.as_uri())
        manifest = manifest.replace("@ZIPRS_REV@", revision)
        (consumer / "pixi.toml").write_text(manifest)

        run(args.pixi, "install", cwd=consumer)
        run(args.pixi, "run", "t", cwd=consumer)


if __name__ == "__main__":
    main()
