"""Generate one HTML entry point for the four test levels."""

from argparse import ArgumentParser
from html import escape
from pathlib import Path


LEVELS = (
    ("Unitaire", "unitaire", ("unit-test-results.txt",)),
    ("API", "api", ("report.html", "log.html", "output.xml", "api-pytest/results_api.html")),
    ("IHM", "ihm", ("report.html", "log.html", "output.xml")),
    ("Performance", "performance", ("performance-results.txt", "reports-performance.txt")),
)


def build_index(root: Path) -> None:
    root.mkdir(parents=True, exist_ok=True)
    rows = []
    for label, folder, expected_files in LEVELS:
        links = []
        for relative_file in expected_files:
            candidates = list((root / folder).rglob(Path(relative_file).name))
            report = candidates[0] if candidates else None
            if report and report.exists():
                href = report.relative_to(root).as_posix()
                links.append(f'<a href="{escape(href)}">{escape(relative_file)}</a>')
        status = "Disponible" if links else "Absent"
        links_html = "<br>".join(links) or "Aucun rapport genere"
        rows.append(
            f"<tr><th>{escape(label)}</th><td class=\"{status.lower()}\">"
            f"{status}</td><td>{links_html}</td></tr>"
        )

    html = f"""<!doctype html>
<html lang="fr">
<head>
<meta charset="utf-8">
<title>Rapport global des tests</title>
<style>
body {{ font-family: Arial, sans-serif; margin: 2rem; color: #202124; }}
h1 {{ margin-bottom: .4rem; }}
table {{ border-collapse: collapse; width: 100%; max-width: 900px; }}
th, td {{ border: 1px solid #d0d7de; padding: .75rem; text-align: left; vertical-align: top; }}
th {{ background: #f6f8fa; width: 18%; }}
.disponible {{ color: #137333; font-weight: 600; }}
.absent {{ color: #b3261e; font-weight: 600; }}
</style>
</head>
<body>
<h1>Rapport global des tests</h1>
<p>Point d'entree des rapports unitaires, API, IHM et performance.</p>
<table>
<thead><tr><th>Niveau</th><th>Etat</th><th>Rapports</th></tr></thead>
<tbody>{''.join(rows)}</tbody>
</table>
</body>
</html>
"""
    (root / "index.html").write_text(html, encoding="utf-8")


if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument("--root", default="reports", type=Path)
    build_index(parser.parse_args().root)
