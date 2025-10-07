# Guide de Sécurité pour les Scripts PowerShell

Ce document présente les **bonnes pratiques de sécurité** essentielles pour utiliser les scripts de création de comptes locaux sous Windows 11. Ces recommandations visent à protéger les systèmes contre les accès non autorisés et les vulnérabilités potentielles.

---

## 🔒 Sécurité des Mots de Passe

### **1. Ne Jamais Stocker les Mots de Passe en Clair**
- **Interdiction absolue** : Ne stockez jamais les mots de passe en texte brut dans les scripts ou les fichiers de configuration.
- **Alternatives sécurisées** :
  - Utilisez **`SecureString`** pour manipuler les mots de passe en mémoire.
  - Utilisez **`Export-Clixml`** pour stocker les mots de passe chiffrés sur le disque.

#### **Exemple : Chiffrement d'un Mot de Passe**
```powershell
# Chiffrer un mot de passe (à exécuter une seule fois pour générer le fichier)
\$securePassword = Read-Host "Entrez le mot de passe" -AsSecureString
\$securePassword | Export-Clixml -Path "C:\secure\password.xml"

# Utilisation du mot de passe chiffré dans un script
\$password = Import-Clixml -Path "C:\secure\password.xml"
