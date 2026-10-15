#!/bin/bash
# TP DevOps - Campus Tasks - executed in WSL2 Ubuntu
set -u

echo "============================================"
echo "DIAGNOSTIC DU POSTE"
echo "============================================"
uname -a
cat /etc/os-release
whoami
pwd
git --version
curl --version | head -1

echo ""
echo "============================================"
echo "ETAPE 1 - Espace de travail"
echo "============================================"
mkdir -p ~/devops-l3/atelier-01/campus-tasks/docs
cd ~/devops-l3/atelier-01/campus-tasks
printf '%s\n' "# Campus Tasks" > README.md
printf '%s\n' "PORT=8080" > .env.example
printf '%s\n' ".env" "*.log" "logs/" > .gitignore
touch docs/architecture.md
echo "--- Contenu du dossier ---"
ls -la
echo "--- Arborescence ---"
tree -a 2>/dev/null || find . -type f
echo "--- pwd ---"
pwd

echo ""
echo "============================================"
echo "ETAPE 2 - Config Git et initialisation depot"
echo "============================================"
git config --global user.name "Etudiant DevOps L3"
git config --global user.email "etudiant.devops.l3@campus.local"
git config --global init.defaultBranch main
echo "--- config globale ---"
git config --global --list
git init
echo "--- git status ---"
git status
echo "--- git status --short ---"
git status --short
echo "--- dossier .git present ? ---"
ls -d .git

echo ""
echo "============================================"
echo "ETAPE 3 - Trois commits atomiques"
echo "============================================"
# Commit 1 - base du projet
git add README.md .gitignore .env.example
echo "--- avant commit 1 ---"
git status --short
git commit -m "chore: initialiser le projet"

# Commit 2 - architecture
printf '%s\n' "# Architecture" "" "API de gestion de tâches étudiantes." > docs/architecture.md
git add docs/architecture.md
git commit -m "docs: decrire l architecture initiale"

# Commit 3 - observer la difference avant de valider
printf '\n## Démarrage\n\nProjet utilisé dans les ateliers DevOps.\n' >> README.md
echo "--- git diff (travail <-> index) avant add ---"
git diff
git add README.md
echo "--- git diff --staged (index <-> dernier commit) ---"
git diff --staged
git commit -m "docs: ajouter les instructions de demarrage"

echo ""
echo "--- Historique final etape 3 ---"
git log --oneline --graph --decorate --all
echo "--- git show --stat HEAD ---"
git show --stat HEAD
echo "--- git status (doit etre clean) ---"
git status

echo ""
echo "============================================"
echo "ETAPE 4 - Branche de fonctionnalite et fusion"
echo "============================================"
git switch -c feature/healthcheck
printf '\n## Santé du service\n\nPoint prévu : GET /health\n' >> README.md
echo "--- status sur branche ---"
git status --short
git add README.md
git commit -m "docs: documenter le point de sante"

echo "--- diff main..feature/healthcheck ---"
git diff main..feature/healthcheck
git switch main
git merge --no-ff feature/healthcheck -m "merge: integrer la documentation du point de sante"
echo "--- graphe avec fusion ---"
git log --oneline --graph --decorate --all

echo "--- branche mergée ---"
git branch --merged
git branch -d feature/healthcheck
echo "--- branches restantes ---"
git branch

echo ""
echo "--- Test git restore sur modif non validee ---"
printf '\nResponsable : equipe DevOps L3\n' >> README.md
echo "--- diff avant restore ---"
git diff
git restore README.md
echo "--- status apres restore (clean) ---"
git status

echo ""
echo "============================================"
echo "ETAPE 5 - Depot distant"
echo "============================================"
echo "Depot local pret. URL distante a configurer :"
echo "  git remote add origin https://PLATEFORME/UTILISATEUR/campus-tasks.git"
echo "  git push -u origin main"
echo ""
echo "Clone de verification (a faire depuis une copie propre):"
echo "  git clone https://PLATEFORME/UTILISATEUR/campus-tasks.git verification-campus-tasks"

echo ""
echo "============================================"
echo "ETAPE 6 - Incident fichier .env"
echo "============================================"
printf '%s\n' "PORT=8080" "DB_PASSWORD=valeur-fictive" > .env
git add -f .env
echo "--- status apres add -f .env ---"
git status --short
echo "--- contenu .gitignore ---"
cat .gitignore
echo "--- explanation : .gitignore ne retire pas un fichier deja connu ---"

# Retirer .env de l'index sans supprimer le fichier du disque
git rm --cached .env
echo "--- status apres git rm --cached .env ---"
git status --short
echo "--- verifier que .env est ignore ---"
git check-ignore -v .env
echo "--- fichier .env existe toujours sur le disque ? ---"
ls -la .env

# Ne valider que la correction (.gitignore deja suivi, pas besoin de le modifier)
echo "--- commit final (sans .env) ---"
git commit -m "chore: retirer .env de l index (secret non versionne)"

echo ""
echo "============================================"
echo "CONTROLES FINAUX (livrable)"
echo "============================================"
cd ~/devops-l3/atelier-01/campus-tasks
echo "--- git status ---"
git status
echo "--- git log --oneline --graph --decorate --all -n 12 ---"
git log --oneline --graph --decorate --all -n 12
echo "--- git remote -v ---"
git remote -v
echo "--- git ls-files ---"
git ls-files
echo "--- git check-ignore -v .env ---"
git check-ignore -v .env

echo ""
echo "============================================"
echo "TP TERMINE - Dossier : ~/devops-l3/atelier-01/campus-tasks"
echo "============================================"
