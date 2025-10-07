# Guide d'Automatisation

Ce guide explique comment **automatiser** la création de comptes locaux sous Windows 11 à l'aide des scripts fournis. Plusieurs méthodes sont disponibles selon vos besoins : déploiement en masse, intégration avec des outils comme MDT/SCCM, ou utilisation de fichiers de réponse (`unattend.xml`).

---

## 📜 Méthodes d'Automatisation

### **1. Utilisation d'un Fichier de Réponse (`unattend.xml`)**
Les fichiers de réponse permettent d'automatiser l'installation de Windows 11 et d'exécuter des scripts après le déploiement.

#### **Exemple de Fichier `unattend.xml`**
```xml
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
    <settings pass="oobeSystem">
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <FirstLogonCommands>
                <SynchronousCommand wcm:action="add">
                    <CommandLine>powershell.exe -ExecutionPolicy Bypass -File "C:\Scripts\Create-LocalAdmin.ps1"</CommandLine>
                    <Description>Création du compte local administrateur</Description>
                    <Order>1</Order>
                </SynchronousCommand>
            </FirstLogonCommands>
        </component>
    </settings>
</unattend>
