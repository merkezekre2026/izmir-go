"""Write the OpenAPI document to a file: `python -m izmirgo.api.export_openapi <path>`."""

from __future__ import annotations

import json
import sys
from pathlib import Path

from izmirgo.api.app import create_app
from izmirgo.core.config import Settings


def export(path: Path) -> None:
    spec = create_app(Settings(env="test")).openapi()
    path.write_text(json.dumps(spec, ensure_ascii=False, indent=2, sort_keys=True) + "\n", "utf-8")


if __name__ == "__main__":
    export(Path(sys.argv[1] if len(sys.argv) > 1 else "../contracts/openapi.json"))
