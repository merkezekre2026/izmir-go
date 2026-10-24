#!/usr/bin/env python3
"""Switch the iOS Runner target to manual signing for CI release builds.

Usage: ios_manual_signing.py <bundle_id> <team_id> <profile_name> <export_method> <out_plist>

- Replaces the placeholder bundle id of the Runner target (not RunnerTests) in project.pbxproj.
- Adds manual-signing settings to the Runner target's build configurations.
- Writes ExportOptions.plist for `flutter build ipa --export-options-plist`.
Only CI runs this; the committed project keeps automatic signing for local development.
"""

from __future__ import annotations

import plistlib
import re
import sys
from pathlib import Path

PBXPROJ = Path(__file__).resolve().parents[1] / "ios/Runner.xcodeproj/project.pbxproj"
PLACEHOLDER = "com.example.izmirGo"


def main() -> None:
    bundle_id, team_id, profile, method, out = sys.argv[1:6]
    text = PBXPROJ.read_text("utf-8")
    pattern = re.compile(rf"^(\s*)PRODUCT_BUNDLE_IDENTIFIER = {re.escape(PLACEHOLDER)};$", re.M)
    if not pattern.search(text):
        sys.exit("Runner bundle id placeholder not found in project.pbxproj")

    def repl(m: re.Match[str]) -> str:
        indent = m.group(1)
        return "\n".join(
            [
                f"{indent}PRODUCT_BUNDLE_IDENTIFIER = {bundle_id};",
                f"{indent}CODE_SIGN_STYLE = Manual;",
                f"{indent}DEVELOPMENT_TEAM = {team_id};",
                f'{indent}PROVISIONING_PROFILE_SPECIFIER = "{profile}";',
                f'{indent}"CODE_SIGN_IDENTITY[sdk=iphoneos*]" = "Apple Distribution";',
            ]
        )

    PBXPROJ.write_text(pattern.sub(repl, text), "utf-8")
    with Path(out).open("wb") as fh:
        plistlib.dump(
            {
                "method": method,
                "teamID": team_id,
                "signingStyle": "manual",
                "signingCertificate": "Apple Distribution",
                "provisioningProfiles": {bundle_id: profile},
                "uploadSymbols": False,
                "compileBitcode": False,
            },
            fh,
        )
    print(f"configured {bundle_id} with profile '{profile}' ({method})")


if __name__ == "__main__":
    main()
