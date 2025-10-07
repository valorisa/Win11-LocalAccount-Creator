<#
.SYNOPSIS
    Crée un compte utilisateur local avec des droits administrateur sur Windows 11.
.DESCRIPTION
    Ce script crée un compte local, l'ajoute au groupe des administrateurs,
    et demande le mot de passe de manière sécurisée via une invite interactive.
    Il vérifie aussi si le compte existe déjà pour éviter les doublons.
.NOTES
    Auteur: Bertrand Brodeau (valorisa)
    Version: 1.1
    GitHub: https://github.com/valorisa/Win11-LocalAccount-Creator
    Date: 07/10/2025
.EXAMPLE
    .\Create-LocalAdmin.ps1
#>

# --- Paramètres à personnaliser ---
$username = "AdminLocal"          # Nom du compte local
$fullname = "Administrateur Local" # Nom complet affiché
$description = "Compte administrateur local créé par script"

# --- Saisie sécurisée du mot de passe ---
Write-Host "Création du compte local '$username'..."
$password = Read-Host "Entrez le mot de passe pour $username" -AsSecureString

# --- Vérification de l'existence du compte ---
if (Get-LocalUser -Name $username -ErrorAction SilentlyContinue) {
    Write-Host "[!] Le compte '$username' existe déjà." -ForegroundColor Yellow
    exit 1
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

    Write-Host "[✅] Le compte '$username' a été créé avec succès et ajouté au groupe des administrateurs." -ForegroundColor Green
}
catch {
    Write-Host "[❌] Erreur lors de la création du compte : $_" -ForegroundColor Red
    exit 1
}
