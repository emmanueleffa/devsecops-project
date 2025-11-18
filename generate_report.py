import json
from json2html import json2html

# Fichiers JSON
files = {
    "Semgrep": "semgrep-results.json",
    "Gitleaks": "gitleaks-report.json",
    "Trivy Dependencies": "trivy-deps.json",
    "Trivy Docker": "trivy-docker.json"
}

html_content = "<html><head><title>DevSecOps Combined Report</title></head><body>"
html_content += "<h1>DevSecOps Combined Security Report</h1>"

for name, file in files.items():
    try:
        with open(file) as f:
            data = json.load(f)
            html_content += f"<h2>{name}</h2>"
            html_content += json2html.convert(json=data)
    except FileNotFoundError:
        html_content += f"<h2>{name}</h2><p>Report not found</p>"

html_content += "</body></html>"

# Écrire le fichier HTML final
with open("devsecops-final-report.html", "w") as f:
    f.write(html_content)

print("✅ Report generated: devsecops-final-report.html")
