# Guide d'Utilisation : Win11-LocalAccount-Creator

Ce guide explique **comment utiliser** les scripts PowerShell pour créer des comptes locaux administrateurs sous Windows 11, que ce soit manuellement ou de manière automatisée.

---

## 📥 Installation

### **1. Cloner le dépôt**
Clone ce dépôt sur ta machine locale :
```bash
git clone https://github.com/valorisa/Win11-LocalAccount-Creator.git
cd Win11-LocalAccount-Creator
```

### **2. Préparer les scripts sur Windows 11**
- Copie les fichiers `Create-LocalAdmin.ps1` et `Create-LocalAdmin-Encrypted.ps1` dans un dossier sur ta machine Windows 11, par exemple `C:\Scripts\`.
- Si tu utilises le script chiffré, crée un dossier `C:\secure\` pour y stocker le fichier de mot de passe chiffré.

---

## 🔧 Utilisation des Scripts

### **1. Script avec Saisie Interactive du Mot de Passe**
Ce script demande le mot de passe à l'exécution, ce qui est idéal pour une utilisation ponctuelle ou des tests.

#### **Étapes :**
1. Ouvre **PowerShell en tant qu'administrateur**.
2. Exécute la commande suivante pour autoriser l'exécution du script :
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force
   ```
3. Exécute le script :
   ```powershell
   .\Create-LocalAdmin.ps1
   ```
4. Saisis le mot de passe quand le script te le demande.

#### **Résultat :**
- Un compte local administrateur nommé `AdminLocal` sera créé.
- Le mot de passe n'est **jamais stocké en clair** dans le script.

---

### **2. Script avec Mot de Passe Chiffré**
Ce script utilise un fichier XML chiffré pour stocker le mot de passe, ce qui est idéal pour les déploiements automatisés.

#### **Étapes :**

##### **a. Générer le fichier de mot de passe chiffré**
1. Ouvre **PowerShell en tant qu'administrateur**.
2. Exécute la commande suivante pour créer un fichier de mot de passe chiffré :
   ```powershell
   $securePassword = Read-Host "Entrez le mot de passe à chiffrer" -AsSecureString
   $securePassword | Export-Clixml -Path "C:\secure\password.xml"
   ```

##### **b. Exécuter le script chiffré**
1. Assure-toi que le fichier `password.xml` est dans `C:\secure\`.
2. Exécute le script :
   ```powershell
   .\Create-LocalAdmin-Encrypted.ps1
   ```

#### **Résultat :**
- Un compte local administrateur sera créé avec le mot de passe chiffré.
- Le fichier `password.xml` **ne peut être déchiffré que par le même utilisateur sur la même machine**.

---

## 🤖 Automatisation avec `unattend.xml`

### **1. Préparer le fichier `unattend.xml`**
- Le fichier `examples/unattend.xml` est déjà configuré pour exécuter le script `Create-LocalAdmin.ps1` après l'installation de Windows 11.

#### **Personnalisation :**
- Modifie le chemin du script dans `unattend.xml` si nécessaire :
  ```xml
  <CommandLine>cmd /c copy D:\Scripts\Create-LocalAdmin.ps1 C:\Scripts\</CommandLine>
  ```
  Remplace `D:\Scripts\` par le chemin réel où se trouve ton script (ex: clé USB, partage réseau).

---

### **2. Utiliser `unattend.xml` pour une installation automatisée**
1. Copie le fichier `unattend.xml` à la racine d'une **clé USB d'installation de Windows 11**.
2. Assure-toi que le script `Create-LocalAdmin.ps1` est accessible depuis la source spécifiée dans `unattend.xml` (ex: `D:\Scripts\`).
3. Démarre l'installation de Windows 11 depuis cette clé USB.
4. Après l'installation, le script sera exécuté automatiquement et créera le compte local administrateur.

---

## 🧪 Tests

### **1. Test en Environnement Sécurisé**
- **Utilise une machine virtuelle** (ex: VirtualBox, Hyper-V) pour tester les scripts sans risque.
- **Étapes :**
  1. Installe Windows 11 sur une machine virtuelle.
  2. Copie les scripts dans `C:\Scripts\`.
  3. Exécute les scripts comme décrit ci-dessus.

---

### **2. Vérification des Comptes Créés**
- Ouvre **Gestion de l'ordinateur** (`compmgmt.msc`).
- Va dans **Utilisateurs et groupes locaux > Utilisateurs** pour vérifier que le compte `AdminLocal` a bien été créé.
- Vérifie que le compte fait partie du groupe **Administrateurs**.

---

## 📂 Structure du Projet
Voici la structure du projet pour référence :
```
Win11-LocalAccount-Creator/
├── README.md
├── LICENSE
├── docs/
│   ├── automatisation.md
│   └── securite.md
├── examples/
│   └── unattend.xml
└── scripts/
    ├── Create-LocalAdmin.ps1
    └── Create-LocalAdmin-Encrypted.ps1
```

---

## 🔒 Bonnes Pratiques de Sécurité

### **1. Ne jamais stocker les mots de passe en clair**
- Utilise toujours `SecureString` ou `Export-Clixml` pour manipuler les mots de passe.

### **2. Tester dans un environnement isolé**
- Utilise des machines virtuelles pour tester les scripts avant de les déployer en production.

### **3. Restreindre les accès**
- Limite l'accès aux scripts et aux fichiers de configuration aux seuls utilisateurs autorisés.

---

## 🤝 Contribution
Les suggestions et améliorations sont les bienvenues ! N'hésite pas à ouvrir une **issue** ou une **pull request** sur GitHub pour contribuer.

---

## ❓ FAQ (Foire Aux Questions)

### **1. Comment modifier le nom du compte créé ?**
- Ouvre le script `Create-LocalAdmin.ps1` ou `Create-LocalAdmin-Encrypted.ps1`.
- Modifie la ligne `$username = "AdminLocal"` pour utiliser le nom de ton choix.

### **2. Comment changer le mot de passe après la création du compte ?**
- Ouvre **PowerShell en tant qu'administrateur** et exécute :
  ```powershell
  $newPassword = Read-Host "Entrez le nouveau mot de passe" -AsSecureString
  Set-LocalUser -Name "AdminLocal" -Password $newPassword
  ```

### **3. Le script ne s'exécute pas via `unattend.xml`. Que faire ?**
- Vérifie que le chemin du script dans `unattend.xml` est correct.
- Assure-toi que le script est accessible depuis la source spécifiée (ex: clé USB).
- Vérifie les logs d'installation de Windows pour identifier les erreurs.

---

© 2025 [valorisa](https://github.com/valorisa)
```

---

### **Étapes pour Ajouter ce 
### **Points Clés du Fichier**
1. **Installation** : Étapes claires pour cloner le dépôt et préparer les scripts.
2. **Utilisation des scripts** : Instructions détaillées pour les deux scripts (interactif et chiffré).
3. **Automatisation** : Guide pour utiliser `unattend.xml` avec des exemples concrets.
4. **Tests** : Méthodes pour tester les scripts en toute sécurité.
5. **FAQ** : Réponses aux questions courantes.
```
