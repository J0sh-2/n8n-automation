# Script d'installation automatique - n8n MCP & Skills
# Executer avec : powershell -ExecutionPolicy Bypass -File install-n8n-tools.ps1

Write-Host "`n[INSTALLATION] n8n-mcp & n8n-skills" -ForegroundColor Cyan
Write-Host "====================================`n" -ForegroundColor Cyan

# Verifier Node.js
Write-Host "Verification de Node.js..." -ForegroundColor Yellow
if (!(Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "[ERREUR] Node.js non trouve dans PATH" -ForegroundColor Red
    Write-Host "`nSolution :" -ForegroundColor Yellow
    Write-Host "1. Ajouter 'C:\Program Files\nodejs' au PATH systeme" -ForegroundColor White
    Write-Host "2. OU executer en PowerShell Admin :" -ForegroundColor White
    Write-Host "   [Environment]::SetEnvironmentVariable('Path', [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';C:\Program Files\nodejs', 'Machine')" -ForegroundColor Gray
    Write-Host "3. Redemarrer PowerShell" -ForegroundColor White
    exit 1
}
$nodeVersion = node --version
Write-Host "[OK] Node.js $nodeVersion detecte" -ForegroundColor Green

# Verifier npm
Write-Host "Verification de npm..." -ForegroundColor Yellow
if (!(Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "[ERREUR] npm non trouve" -ForegroundColor Red
    exit 1
}
$npmVersion = npm --version
Write-Host "[OK] npm $npmVersion detecte" -ForegroundColor Green

# Verifier Git
Write-Host "Verification de Git..." -ForegroundColor Yellow
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "[ERREUR] Git non installe" -ForegroundColor Red
    Write-Host "`nSolution :" -ForegroundColor Yellow
    Write-Host "1. Telecharger Git : https://git-scm.com/download/win" -ForegroundColor White
    Write-Host "2. Installer avec options par defaut" -ForegroundColor White
    Write-Host "3. Redemarrer PowerShell" -ForegroundColor White
    Write-Host "`n[ATTENTION] Installation continue sans Git (n8n-skills ne sera pas clone)" -ForegroundColor Yellow
    $gitAvailable = $false
} else {
    $gitVersion = git --version
    Write-Host "[OK] $gitVersion detecte" -ForegroundColor Green
    $gitAvailable = $true
}

# Creer dossier npm si necessaire
Write-Host "`nPreparation de l'environnement npm..." -ForegroundColor Yellow
$npmDir = "$env:APPDATA\npm"
if (!(Test-Path $npmDir)) {
    New-Item -ItemType Directory -Force -Path $npmDir | Out-Null
    Write-Host "[OK] Dossier npm cree : $npmDir" -ForegroundColor Green
} else {
    Write-Host "[OK] Dossier npm existe" -ForegroundColor Green
}

# Installer n8n-mcp
Write-Host "`n[INSTALL] Installation de n8n-mcp..." -ForegroundColor Cyan
Write-Host "(Cela peut prendre 1-2 minutes...)" -ForegroundColor Gray
try {
    npm install -g n8n-mcp
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] n8n-mcp installe avec succes" -ForegroundColor Green
    } else {
        Write-Host "[ATTENTION] n8n-mcp installe mais avec des avertissements" -ForegroundColor Yellow
    }
} catch {
    Write-Host "[ERREUR] Erreur lors de l'installation de n8n-mcp" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}

# Cloner n8n-skills (si Git disponible)
if ($gitAvailable) {
    Write-Host "`n[INSTALL] Clonage de n8n-skills..." -ForegroundColor Cyan
    
    Set-Location C:\Stage
    
    if (Test-Path "n8n-skills") {
        Write-Host "n8n-skills existe deja, mise a jour..." -ForegroundColor Yellow
        Set-Location n8n-skills
        git pull
        Set-Location ..
        Write-Host "[OK] n8n-skills mis a jour" -ForegroundColor Green
    } else {
        try {
            git clone https://github.com/czlonkowski/n8n-skills.git
            if ($LASTEXITCODE -eq 0) {
                Write-Host "[OK] n8n-skills clone avec succes" -ForegroundColor Green
            }
        } catch {
            Write-Host "[ERREUR] Erreur lors du clonage de n8n-skills" -ForegroundColor Red
            Write-Host $_.Exception.Message -ForegroundColor Red
        }
    }
} else {
    Write-Host "`n[ATTENTION] n8n-skills non clone (Git manquant)" -ForegroundColor Yellow
    Write-Host "Les regles n8n-skills sont disponibles dans :" -ForegroundColor Cyan
    Write-Host "  - .cursorrules" -ForegroundColor White
    Write-Host "  - .github/copilot-instructions.md" -ForegroundColor White
}

# Cloner n8n-mcp (optionnel, pour consultation)
if ($gitAvailable) {
    Write-Host "`n[INSTALL] Clonage de n8n-mcp (documentation)..." -ForegroundColor Cyan
    
    Set-Location C:\Stage
    
    if (Test-Path "n8n-mcp") {
        Write-Host "n8n-mcp existe deja, mise a jour..." -ForegroundColor Yellow
        Set-Location n8n-mcp
        git pull
        Set-Location ..
        Write-Host "[OK] n8n-mcp mis a jour" -ForegroundColor Green
    } else {
        try {
            git clone https://github.com/czlonkowski/n8n-mcp.git
            if ($LASTEXITCODE -eq 0) {
                Write-Host "[OK] n8n-mcp clone avec succes" -ForegroundColor Green
            }
        } catch {
            Write-Host "[ATTENTION] n8n-mcp documentation non clonee (non critique)" -ForegroundColor Yellow
        }
    }
}

# Resume
Write-Host "`n=====================================" -ForegroundColor Cyan
Write-Host "[SUCCES] Installation terminee!" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan

Write-Host "`n[ETAPES] Prochaines etapes :" -ForegroundColor Cyan
Write-Host "`n1. Configurer Claude Desktop" -ForegroundColor Yellow
Write-Host "   Emplacement : %APPDATA%\Claude\claude_desktop_config.json" -ForegroundColor Gray
Write-Host "   Contenu (minimal) :" -ForegroundColor Gray
Write-Host @"
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
"@ -ForegroundColor DarkGray

Write-Host "`n2. Redemarrer Claude Desktop" -ForegroundColor Yellow

Write-Host "`n3. Tester dans Claude Desktop :" -ForegroundColor Yellow
Write-Host "   'List available n8n tools'" -ForegroundColor Gray

Write-Host "`n4. Dans VS Code/Cursor avec GitHub Copilot :" -ForegroundColor Yellow
Write-Host "   'How do I access webhook data in n8n?'" -ForegroundColor Gray
Write-Host "   (Les regles sont dans .cursorrules et .github/copilot-instructions.md)" -ForegroundColor Gray

Write-Host "`n[DOCS] Documentation complete :" -ForegroundColor Cyan
Write-Host "   - INSTALLATION.md (guide detaille)" -ForegroundColor White
Write-Host "   - regles du jeu - automatisation n8n.md (methodologie)" -ForegroundColor White

Write-Host "`n[OK] Pret a construire des workflows n8n de haute qualite !`n" -ForegroundColor Green
