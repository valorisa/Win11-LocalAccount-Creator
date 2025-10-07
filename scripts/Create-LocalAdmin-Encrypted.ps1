<#
.SYNOPSIS
    Crée un compte utilisateur local administrateur avec un mot de passe chiffré.
.DESCRIPTION
    Ce script utilise un fichier XML chiffré pour stocker le mot de passe.
    Le fichier doit être généré au préalable avec Export-Clixml.
    Exemple de génération :
    $securePassword = Read-Host "Entrez le mot de passe" -AsSecureString
    $securePassword | Export-Clixml -Path "C:\secure\password.xml"
.NOTES
    Auteur: Bertrand Brodeau (valorisa)
    Version: 1.1
    GitHub: https://github.com/valorisa/Win11-LocalAccount-Creator
    Date: 07/10/2025
.EXAMPLE
    .\Create-LocalAdmin-Encrypted.ps1
#>

# --- Paramètres à personnaliser ---
$username = "AdminLocal"          # Nom du compte local
$fullname = "Administrateur Local" # Nom complet affiché
$description = "Compte administrateur local créé par script"
$passwordFile = "C:\secure\password.xml" # Chemin vers le fichier de mot de passe chiffré

# --- Vérification du fichier de mot de passe ---
if (-not (Test-Path $passwordFile)) {
    Write-Host "[❌] Fichier de mot de passe introuvable : $passwordFile" -ForegroundColor Red
    Write-Host "[i] Générez-le d'abord avec : `n$securePassword = Read-Host 'Entrez le mot de passe' -AsSecureString`n$securePassword | Export-Clixml -Path '$passwordFile'" -ForegroundColor Cyan
    exit 1
}

# --- Chargement du mot de passe chiffré ---
try {
    $password = Import-Clixml -Path $passwordFile
}
catch {
    Write-Host "[❌] Impossible de lire le fichier de mot de passe : $_" -ForegroundColor Red
    exit 1
}

# --- Vérification de l'existence du compte ---
if (Get-LocalUser -Name $username -ErrorAction SilentlyContinue) {
    Write-Host "[!] Le compte '$username' existe déjà." -ForegroundColor Yellow
    exit 0
}

try {
    # --- Création du compte local ---
    Write-Host "[+] Création du compte '$username'..."
    New-LocalUser -Name $username `
                  -Password $password `
                  -Description $description `
                  -FullName $fullname `
                  -AccountNeverExpires `
                  -PasswordNeverExpires

    # --- Ajout au groupe des administrateurs ---
    Write-Host "[+] Ajout de '$username' au groupe 'Administrateurs'..."
    Add-LocalGroupMember -Group "Administrateurs" -Member $username

    Write-Host "[✅] Le compte '$username' a été créé avec succès." -ForegroundColor Green
}
catch {
    Write-Host "[❌] Erreur lors de la création du compte : $_" -ForegroundColor Red
    exit 1
}
