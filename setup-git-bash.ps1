# Script de configuration de Git Bash pour Claude Code
# Ce script configure la variable d'environnement CLAUDE_CODE_GIT_BASH_PATH

Write-Host "Recherche de Git Bash..." -ForegroundColor Cyan

# Emplacements courants de Git Bash
$possiblePaths = @(
    "C:\Program Files\Git\bin\bash.exe",
    "C:\Program Files (x86)\Git\bin\bash.exe",
    "$env:LOCALAPPDATA\Programs\Git\bin\bash.exe",
    "$env:ProgramFiles\Git\bin\bash.exe"
)

$bashPath = $null

foreach ($path in $possiblePaths) {
    if (Test-Path $path) {
        $bashPath = $path
        Write-Host "[OK] Git Bash trouve a : $bashPath" -ForegroundColor Green
        break
    }
}

if (-not $bashPath) {
    Write-Host "[ERREUR] Git Bash n'a pas ete trouve." -ForegroundColor Red
    Write-Host ""
    Write-Host "Veuillez installer Git pour Windows depuis :" -ForegroundColor Yellow
    Write-Host "https://git-scm.com/download/win" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Après l'installation, relancez ce script." -ForegroundColor Yellow
    exit 1
}

# Définir la variable d'environnement pour la session actuelle
$env:CLAUDE_CODE_GIT_BASH_PATH = $bashPath
Write-Host "[OK] Variable d'environnement definie pour la session actuelle" -ForegroundColor Green

# Définir la variable d'environnement de manière permanente (utilisateur)
try {
    [System.Environment]::SetEnvironmentVariable("CLAUDE_CODE_GIT_BASH_PATH", $bashPath, [System.EnvironmentVariableTarget]::User)
    Write-Host "[OK] Variable d'environnement definie de maniere permanente (utilisateur)" -ForegroundColor Green
    Write-Host ""
    Write-Host "IMPORTANT : Redémarrez Cursor/VS Code pour que les changements prennent effet." -ForegroundColor Yellow
} catch {
    Write-Host "[ERREUR] Erreur lors de la definition de la variable d'environnement : $_" -ForegroundColor Red
    Write-Host "Vous pouvez définir manuellement la variable avec :" -ForegroundColor Yellow
    Write-Host "[System.Environment]::SetEnvironmentVariable('CLAUDE_CODE_GIT_BASH_PATH', '$bashPath', [System.EnvironmentVariableTarget]::User)" -ForegroundColor Cyan
}
