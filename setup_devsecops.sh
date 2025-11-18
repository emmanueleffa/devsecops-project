#!/bin/bash

# ------------------------------------------------------
# Script d'installation DevSecOps - Ubuntu 24.04 LTS
# Installe venv, Semgrep, pre-commit, Gitleaks
# ------------------------------------------------------

# Quitter en cas d'erreur
set -e

echo "1️⃣ Mise à jour des paquets..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y python3 python3-venv python3-pip wget tar git

echo "2️⃣ Création de l'environnement virtuel..."
python3 -m venv venv

echo "3️⃣ Activation de l'environnement virtuel..."
source venv/bin/activate

echo "4️⃣ Mise à jour de pip et installation des packages Python..."
python3 -m pip install --upgrade pip setuptools wheel
python3 -m pip install semgrep pre-commit

echo "5️⃣ Vérification des installations Python..."
semgrep --version
pre-commit --version

echo "6️⃣ Installation de Gitleaks..."
GITLEAKS_VERSION="v8.29.0"
wget https://github.com/gitleaks/gitleaks/releases/download/$GITLEAKS_VERSION/gitleaks_8.29.0_linux_x64.tar.gz
tar -xzf gitleaks_8.29.0_linux_x64.tar.gz
sudo mv gitleaks /usr/local/bin/
rm gitleaks_8.29.0_linux_x64.tar.gz

echo "7️⃣ Vérification de Gitleaks..."
gitleaks --version

echo "8️⃣ Création des fichiers de configuration pré-commit et Semgrep..."
# .semgrep.yml
cat <<EOL > .semgrep.yml
rules:
  - id: hardcoded-secret
    patterns:
      - pattern: "password = '\$SECRET'"
    message: "Secret codé en dur détecté"
    severity: WARNING
    languages: [python]

  - id: print-debug
    patterns:
      - pattern: "print(\$X)"
    message: "Debug print détecté"
    severity: INFO
    languages: [python]
EOL

# .pre-commit-config.yaml
cat <<EOL > .pre-commit-config.yaml
repos:
  - repo: https://github.com/returntocorp/semgrep
    rev: v1.30.0
    hooks:
      - id: semgrep
        args: ["--config", ".semgrep.yml"]
EOL

echo "9️⃣ Installation du hook pre-commit..."
pre-commit install

echo "✅ Installation terminée !"
echo "Pour activer l'environnement virtuel : source venv/bin/activate"
echo "Chaque commit lancera automatiquement Semgrep pour détecter les vulnérabilités."
