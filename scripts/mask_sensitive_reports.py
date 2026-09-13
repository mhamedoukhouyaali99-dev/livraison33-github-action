"""Replace configured secrets before test reports are archived or shared."""

import os
from pathlib import Path


REPORT_ROOT = Path(os.getenv("REPORT_ROOT", "reports"))
SECRET_NAMES = ("API_KEY", "BASE_URL", "TEST_PASSWORD")


def main() -> None:
    secrets = [os.getenv(name) for name in SECRET_NAMES]
    secrets = [secret for secret in secrets if secret and len(secret) >= 4]

    for report in REPORT_ROOT.rglob("*"):
        if not report.is_file() or report.suffix.lower() not in {".html", ".xml", ".txt"}:
            continue
        content = report.read_text(encoding="utf-8", errors="replace")
        masked = content
        for secret in secrets:
            masked = masked.replace(secret, "[MASKED]")
        if masked != content:
            report.write_text(masked, encoding="utf-8")


if __name__ == "__main__":
    main()
