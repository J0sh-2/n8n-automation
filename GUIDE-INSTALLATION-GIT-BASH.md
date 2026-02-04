# Guide d'installation et configuration de Git Bash pour Claude Code

## Problème
Claude Code sur Windows nécessite Git Bash pour fonctionner correctement.

## Solution en 2 étapes

### Étape 1 : Installer Git pour Windows

1. **Télécharger Git pour Windows**
   - Allez sur : https://git-scm.com/download/win
   - Téléchargez la dernière version (le téléchargement démarre automatiquement)

2. **Installer Git**
   - Exécutez le fichier téléchargé (ex: `Git-2.x.x-64-bit.exe`)
   - Suivez l'assistant d'installation
   - **Important** : Acceptez les options par défaut (elles incluent Git Bash)
   - Une fois l'installation terminée, Git Bash sera disponible

### Étape 2 : Configurer la variable d'environnement

**Option A : Utiliser le script automatique (RECOMMANDÉ)**

1. Après l'installation de Git, exécutez dans PowerShell :
   ```powershell
   powershell -ExecutionPolicy Bypass -File "c:\Stage\setup-git-bash.ps1"
   ```

2. Redémarrez Cursor/VS Code

**Option B : Configuration manuelle**

1. Ouvrez PowerShell en tant qu'administrateur

2. Définissez la variable d'environnement (remplacez le chemin si nécessaire) :
   ```powershell
   [System.Environment]::SetEnvironmentVariable("CLAUDE_CODE_GIT_BASH_PATH", "C:\Program Files\Git\bin\bash.exe", [System.EnvironmentVariableTarget]::User)
   ```

3. Redémarrez Cursor/VS Code

**Option C : Via l'interface Windows**

1. Appuyez sur `Win + R`, tapez `sysdm.cpl` et appuyez sur Entrée
2. Allez dans l'onglet "Avancé"
3. Cliquez sur "Variables d'environnement"
4. Sous "Variables utilisateur", cliquez sur "Nouveau"
5. Nom de la variable : `CLAUDE_CODE_GIT_BASH_PATH`
6. Valeur de la variable : `C:\Program Files\Git\bin\bash.exe` (ou le chemin où Git est installé)
7. Cliquez sur "OK" partout
8. Redémarrez Cursor/VS Code

## Vérification

Pour vérifier que tout fonctionne :

1. Ouvrez PowerShell et exécutez :
   ```powershell
   $env:CLAUDE_CODE_GIT_BASH_PATH
   ```
   Cela devrait afficher le chemin vers `bash.exe`

2. Testez Git Bash :
   ```powershell
   & "$env:CLAUDE_CODE_GIT_BASH_PATH" --version
   ```

3. Redémarrez Cursor et l'erreur devrait disparaître

## Emplacements courants de Git Bash

Si Git est installé ailleurs, voici les emplacements possibles :
- `C:\Program Files\Git\bin\bash.exe` (installation 64-bit standard)
- `C:\Program Files (x86)\Git\bin\bash.exe` (installation 32-bit)
- `%LOCALAPPDATA%\Programs\Git\bin\bash.exe` (installation portable)

## Support

Si le problème persiste après l'installation :
1. Vérifiez que Git Bash est bien installé en ouvrant Git Bash depuis le menu Démarrer
2. Vérifiez que le chemin dans la variable d'environnement est correct
3. Assurez-vous d'avoir redémarré Cursor/VS Code après la configuration
