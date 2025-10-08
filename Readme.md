# Win11-LocalAccount-Creator
> **Scripts PowerShell pour créer des comptes locaux administrateurs sous Windows 11, avec chiffrement des mots de passe et automatisation avancée.**

---

## 📜 Description
Ce projet fournit des **scripts PowerShell** pour créer des comptes locaux administrateurs sur Windows 11, **sans dépendre de l’interface graphique ou d’un compte Microsoft**. Il est conçu pour :
- **Automatiser** la création de comptes après un déploiement.
- **Sécuriser** les mots de passe via chiffrement ou saisie interactive.
- **S’intégrer** dans des processus de déploiement (fichiers de réponse, MDT, SCCM).

---

## 📥 Installation
1. **Clone ce dépôt** :
   ```bash
   git clone https://github.com/valorisa/Win11-LocalAccount-Creator.git
   ```
2. Place les scripts dans `C:\Scripts\` (ou un chemin de ton choix) sur la machine Windows 11.
3. Exécute les scripts comme décrit ci-dessous.

---

## 🛠 Prérequis
- **Windows 11** (toutes versions).
- **PowerShell 5.1+** (intégré par défaut).
- **Droits administrateur** pour exécuter les scripts.

---

## 📜 Scripts PowerShell

### **1. Script principal (saisie interactive du mot de passe)**
```powershell
<#
.SYNOPSIS
    Crée un compte utilisateur local avec des droits administrateur sur Windows 11.
.DESCRIPTION
    Ce script crée un compte local, l'ajoute au groupe des administrateurs,
    et demande le mot de passe de manière sécurisée.
.NOTES
    Auteur: Bertrand Brodeau (valorisa)
    Version: 1.1
    GitHub: https://github.com/valorisa/Win11-LocalAccount-Creator
#>

# --- Paramètres à personnaliser ---
$username = "AdminLocal"
$fullname = "Administrateur Local"
$description = "Compte administrateur local créé par script"

# --- Saisie sécurisée du mot de passe ---
$password = Read-Host "Entrez le mot de passe pour $username" -AsSecureString

# --- Vérification de l'existence du compte ---
if (Get-LocalUser -Name $username -ErrorAction SilentlyContinue) {
    Write-Host "[!] Le compte '$username' existe déjà." -ForegroundColor Yellow
    exit
}

try {
    # --- Création du compte ---
    New-LocalUser -Name $username `
                  -Password $password `
                  -Description $description `
                  -FullName $fullname `
                  -AccountNeverExpires `
                  -PasswordNeverExpires

    # --- Ajout au groupe des administrateurs ---
    Add-LocalGroupMember -Group "Administrateurs" -Member $username

    Write-Host "[+] Le compte '$username' a été créé avec succès." -ForegroundColor Green
}
catch {
    Write-Host "[-] Erreur : $_" -ForegroundColor Red
}
```

---

### **2. Script avec mot de passe chiffré (pour déploiement automatisé)**
```powershell
<#
.SYNOPSIS
    Crée un compte local administrateur avec un mot de passe chiffré.
.DESCRIPTION
    Ce script utilise un fichier XML chiffré pour stocker le mot de passe.
    Générez d'abord le fichier avec Export-Clixml.
#>

# --- Paramètres ---
$username = "AdminLocal"
$passwordFile = "C:\secure\password.xml"

# --- Chargement du mot de passe chiffré ---
if (-not (Test-Path $passwordFile)) {
    Write-Host "[-] Fichier de mot de passe introuvable : $passwordFile" -ForegroundColor Red
    exit
}
$password = Import-Clixml -Path $passwordFile

# --- Vérification et création du compte ---
if (Get-LocalUser -Name $username -ErrorAction SilentlyContinue) {
    Write-Host "[!] Le compte '$username' existe déjà." -ForegroundColor Yellow
    exit
}

try {
    New-LocalUser -Name $username -Password $password -AccountNeverExpires -PasswordNeverExpires
    Add-LocalGroupMember -Group "Administrateurs" -Member $username
    Write-Host "[+] Compte '$username' créé avec succès." -ForegroundColor Green
}
catch {
    Write-Host "[-] Erreur : $_" -ForegroundColor Red
}
```

---

### **3. Générer un fichier de mot de passe chiffré**
Pour créer un fichier `.xml` chiffré contenant le mot de passe :
```powershell
$securePassword = Read-Host "Entrez le mot de passe à chiffrer" -AsSecureString
$securePassword | Export-Clixml -Path "C:\secure\password.xml"
```
**⚠️ Important** : Le fichier `.xml` ne peut être déchiffré que par le même utilisateur sur la même machine.

---

## 🔧 Utilisation des scripts

### **1. Exécution manuelle**
1. Ouvre **PowerShell en tant qu’administrateur**.
2. Exécute le script :
   ```powershell
   .\scripts\Create-LocalAdmin.ps1
   ```

### **2. Automatisation via fichier de réponse (`unattend.xml`)**
Ajoute cette section à ton fichier `unattend.xml` pour exécuter le script après l’installation :
```xml
<FirstLogonCommands>
    <SynchronousCommand wcm:action="add">
        <CommandLine>powershell.exe -ExecutionPolicy Bypass -File "C:\Scripts\Create-LocalAdmin.ps1"</CommandLine>
        <Description>Création du compte local administrateur</Description>
        <Order>1</Order>
    </SynchronousCommand>
</FirstLogonCommands>
```

---

## 📂 Structure suggérée du projet
*(À créer manuellement ou via les commandes ci-dessous)*
```
Win11-LocalAccount-Creator/
├── README.md
├── LICENSE
├── scripts/
│   ├── Create-LocalAdmin.ps1          # Script principal (saisie interactive)
│   └── Create-LocalAdmin-Encrypted.ps1 # Script avec mot de passe chiffré
├── docs/
│   ├── automatisation.md              # Guide pour l'automatisation (MDT, SCCM)
│   └── securite.md                    # Bonnes pratiques de sécurité
└── examples/
    └── unattend.xml                   # Exemple de fichier de réponse
```

---

## 💡 Propositions de noms pour le projet
1. **Win11-LocalAccount-Creator**
2. **Win11-OfflineAdmin**
3. **BypassMSA-Win11**
4. **PowerShell-LocalUser**
5. **Win11-AutoAdmin**
6. **LocalAdminToolkit**
7. **Win11-ScriptedAccounts**
8. **AdminBypass-Win11**

---

## 📌 Notes de sécurité
- **Ne stocke jamais les mots de passe en clair** dans les scripts.
- **Utilise `SecureString` ou `Export-Clixml`** pour les environnements sensibles.
- **Teste toujours les scripts** sur une machine virtuelle avant déploiement.

---

## 🤝 Contribution
Les suggestions et améliorations sont les bienvenues ! Ouvre une *issue* ou une *pull request* pour contribuer.

---
© 2025 [(valorisa)](https://github.com/valorisa)
