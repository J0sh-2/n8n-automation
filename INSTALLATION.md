# Guide d'installation - n8n MCP Server & n8n Skills

## Problème détecté

Les outils ne s'installent pas car :
1. ❌ **Node.js n'est pas dans le PATH** (installé mais non accessible)
2. ❌ **npm n'est pas accessible** depuis PowerShell
3. ❌ **Git n'est pas installé** (nécessaire pour cloner n8n-skills)

## Solution rapide

### Étape 1 : Ajouter Node.js au PATH (PERMANENT)

**Option A : Via PowerShell (Administrateur)**
```powershell
# Ouvrir PowerShell en tant qu'administrateur
# Ajouter Node.js au PATH système
[Environment]::SetEnvironmentVariable(
    "Path",
    [Environment]::GetEnvironmentVariable("Path", "Machine") + ";C:\Program Files\nodejs",
    "Machine"
)

# Redémarrer PowerShell après cette commande
```

**Option B : Via Interface Windows**
1. Clic droit sur "Ce PC" → Propriétés
2. Paramètres système avancés
3. Variables d'environnement
4. Dans "Variables système", sélectionner "Path"
5. Cliquer "Modifier"
6. Ajouter : `C:\Program Files\nodejs`
7. OK → OK → OK
8. **REDÉMARRER PowerShell/VS Code**

### Étape 2 : Installer Git (requis pour n8n-skills)

**Télécharger et installer Git :**
- Aller sur : https://git-scm.com/download/win
- Télécharger "64-bit Git for Windows Setup"
- Installer avec options par défaut
- **REDÉMARRER PowerShell/VS Code**

### Étape 3 : Vérifier l'installation

```powershell
# Ouvrir un NOUVEAU PowerShell et vérifier :
node --version    # Doit afficher v20.x.x ou similaire
npm --version     # Doit afficher 10.x.x ou similaire
git --version     # Doit afficher git version 2.x.x
```

### Étape 4 : Installer n8n-mcp

```powershell
cd C:\Stage

# Installation globale (recommandée)
npm install -g n8n-mcp

# OU installation via npx (pas besoin d'installation)
npx n8n-mcp
```

### Étape 5 : Cloner n8n-skills

```powershell
cd C:\Stage

# Cloner le dépôt
git clone https://github.com/czlonkowski/n8n-skills.git

# Vérifier le contenu
dir n8n-skills\skills
```

## Configuration Claude Desktop

Une fois les outils installés, créer/éditer le fichier de configuration Claude :

**Emplacement** : `%APPDATA%\Claude\claude_desktop_config.json`

```json
{
  "mcpServers": {
    "n8n-mcp": {
      "command": "npx",
      "args": ["n8n-mcp"],
      "env": {
        "MCP_MODE": "stdio",
        "LOG_LEVEL": "error",
        "DISABLE_CONSOLE_OUTPUT": "true"
      }
    }
  }
}
```

### Avec API n8n (optionnel)
Si vous avez une instance n8n avec API :

```json
{
  "mcpServers": {
    "n8n-mcp": {
      "command": "npx",
      "args": ["n8n-mcp"],
      "env": {
        "MCP_MODE": "stdio",
        "LOG_LEVEL": "error",
        "DISABLE_CONSOLE_OUTPUT": "true",
        "N8N_API_URL": "https://votre-instance-n8n.com",
        "N8N_API_KEY": "votre-api-key"
      }
    }
  }
}
```

**Après configuration** : Redémarrer Claude Desktop

## Configuration n8n-skills

### Pour Claude Code
```powershell
# Installer comme plugin
/plugin install czlonkowski/n8n-skills
```

### Pour VS Code / Cursor / Windsurf
Les fichiers `.cursorrules` et `.github/copilot-instructions.md` sont déjà créés dans votre projet et contiennent toutes les règles des 7 skills n8n.

## Vérification finale

### Test n8n-mcp
```powershell
# Dans Claude Desktop, après redémarrage, demander :
"List available n8n tools"

# Devrait afficher les 20 outils MCP disponibles
```

### Test n8n-skills
```powershell
# Dans VS Code avec GitHub Copilot, demander :
"How do I access webhook data in n8n?"

# Copilot devrait répondre avec {{ $json.body.xxx }}
```

## Problèmes courants

### "npm n'est pas reconnu"
→ Node.js pas dans PATH. Suivre Étape 1 et REDÉMARRER PowerShell.

### "git n'est pas reconnu"
→ Git pas installé. Suivre Étape 2 et REDÉMARRER PowerShell.

### "npx n8n-mcp" prend trop de temps
→ Normal la première fois (téléchargement). Attendre 1-2 minutes.

### Claude Desktop ne voit pas les outils MCP
→ Vérifier que `claude_desktop_config.json` est correct et REDÉMARRER Claude Desktop.

### Erreur ENOENT dans npm
→ Créer le dossier : `mkdir $env:APPDATA\npm`

## Script d'installation automatique

Créer un fichier `install-n8n-tools.ps1` :

```powershell
# Vérifier Node.js
if (!(Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Node.js non trouvé dans PATH" -ForegroundColor Red
    Write-Host "Ajoutez 'C:\Program Files\nodejs' au PATH système" -ForegroundColor Yellow
    exit 1
}

# Vérifier Git
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Git non installé" -ForegroundColor Red
    Write-Host "Téléchargez sur : https://git-scm.com/download/win" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Node.js et Git détectés" -ForegroundColor Green

# Créer dossier npm si nécessaire
$npmDir = "$env:APPDATA\npm"
if (!(Test-Path $npmDir)) {
    New-Item -ItemType Directory -Force -Path $npmDir | Out-Null
    Write-Host "✅ Dossier npm créé" -ForegroundColor Green
}

# Installer n8n-mcp
Write-Host "`n📦 Installation de n8n-mcp..." -ForegroundColor Cyan
npm install -g n8n-mcp

# Cloner n8n-skills
Write-Host "`n📦 Clonage de n8n-skills..." -ForegroundColor Cyan
cd C:\Stage
if (Test-Path "n8n-skills") {
    Write-Host "n8n-skills existe déjà, mise à jour..." -ForegroundColor Yellow
    cd n8n-skills
    git pull
} else {
    git clone https://github.com/czlonkowski/n8n-skills.git
}

Write-Host "`n✅ Installation terminée!" -ForegroundColor Green
Write-Host "`nProchaines étapes:" -ForegroundColor Cyan
Write-Host "1. Configurer Claude Desktop (voir INSTALLATION.md)"
Write-Host "2. Redémarrer Claude Desktop"
Write-Host "3. Tester avec : 'List available n8n tools'"
```

**Exécuter** :
```powershell
cd C:\Stage
powershell -ExecutionPolicy Bypass -File install-n8n-tools.ps1
```

## Support

- **n8n-mcp** : https://github.com/czlonkowski/n8n-mcp
- **n8n-skills** : https://github.com/czlonkowski/n8n-skills
- **Documentation** : Voir `règles du jeu - automatisation n8n.md`

## Résumé rapide

```powershell
# 1. Ajouter Node.js au PATH (via interface Windows)
# 2. Installer Git : https://git-scm.com/download/win
# 3. REDÉMARRER PowerShell
# 4. Vérifier
node --version
npm --version
git --version

# 5. Installer
npm install -g n8n-mcp
git clone https://github.com/czlonkowski/n8n-skills.git

# 6. Configurer Claude Desktop
# 7. REDÉMARRER Claude Desktop
# 8. Tester !
```

🎯 **Objectif** : Avoir n8n-mcp et n8n-skills opérationnels pour construire des workflows n8n de haute qualité !
