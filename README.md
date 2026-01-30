# QRdecode - Guide d'installation et d'utilisation / Installation and User Guide

**[🇫🇷 Version Française](#version-française) | [🇬🇧 English Version](#english-version)**

---

## Version Française

# QRdecode - Guide d'installation et d'utilisation pour Linux

## Description
QRdecode est un programme Python qui détecte automatiquement les QR codes affichés à l'écran de votre ordinateur, les décode et ouvre les liens correspondants dans votre navigateur.

---

## Installation

Télécharger le fichier [install_qrdecode.sh](https://raw.githubusercontent.com/vtflosa/QRdecode/main/install_qrdecode.sh) (clique-droit -> enregistre la cible du lien sous...)

Ouvrez un terminal là ou le fichier est téléchargé et exécutez la commande dans un terminal:

```bash
bash install_qrdecode.sh
```

## Utilisation

### Comment utiliser QRdecode

1. **Affichez le QR code à l'écran**
   - Ouvrez l'image, le site web ou le document contenant le QR code
   - Assurez-vous que le QR code est **bien visible et entièrement affiché** à l'écran
   - Le QR code peut être n'importe où sur l'écran (même avec plusieurs moniteurs)

2. **Lancez le programme**
   - Double-cliquez sur l'icône QRdecode sur votre bureau
   - Ou lancez-le depuis menu des applications (cherchez 'QRdecode')

3. **Validation des liens**
   - Une fenêtre popup s'affiche pour chaque QR code détecté
   - Elle vous montre le lien décodé
   - Cliquez sur **"OK"** pour ouvrir le lien dans votre navigateur
   - Cliquez sur **"Annuler"** pour ignorer ce lien

4. **Résultat**
   - Les liens validés s'ouvrent automatiquement dans des onglets de votre navigateur
   - Si aucun QR code n'est détecté, un message vous en informe

### Conseils d'utilisation

- ✅ Le QR code doit être **net et bien contrasté**
- ✅ Fonctionne avec **plusieurs QR codes** simultanément
- ✅ Compatible **multi-écrans**
- ❌ Ne fonctionne pas si le QR code est partiellement masqué
- ❌ Ne fonctionne pas si le QR code est trop petit ou flou

---

## Désinstallation

Pour supprimer complètement QRdecode :

```bash
bash ~/.local/share/qrdecode/uninstall.sh
```

---

## Informations techniques

- **Langage :** Python 3
- **Bibliothèques principales :** OpenCV, MSS, Tkinter
- **Capture d'écran :** Utilise MSS pour une capture rapide
- **Détection :** OpenCV QRCodeDetector avec support multi-QR codes
- **Navigateur :** Ouvre le navigateur par défaut du système

---

**[⬆ Retour en haut](#qrdecode---guide-dinstallation-et-dutilisation--installation-and-user-guide) | [🇬🇧 English Version](#english-version)**

---
---

## English Version

# QRdecode - Installation and User Guide for Linux

## Description
QRdecode is a Python program that automatically detects QR codes displayed on your computer screen, decodes them, and opens the corresponding links in your browser.

---

## Installation

Download the file [install_qrdecode.sh](https://raw.githubusercontent.com/vtflosa/QRdecode/main/install_qrdecode.sh) (right-click -> save link as...)

Open a terminal where the file is downloaded and run the command:

```bash
bash install_qrdecode.sh
```

## Usage

### How to use QRdecode

1. **Display the QR code on screen**
   - Open the image, website, or document containing the QR code
   - Make sure the QR code is **clearly visible and fully displayed** on screen
   - The QR code can be anywhere on the screen (even with multiple monitors)

2. **Launch the program**
   - Double-click the QRdecode icon on your desktop
   - Or launch it from the applications menu (search for 'QRdecode')

3. **Link validation**
   - A popup window appears for each detected QR code
   - It shows you the decoded link
   - Click **"OK"** to open the link in your browser
   - Click **"Cancel"** to ignore this link

4. **Result**
   - Validated links automatically open in tabs in your browser
   - If no QR code is detected, a message informs you

### Usage tips

- ✅ The QR code must be **sharp and well contrasted**
- ✅ Works with **multiple QR codes** simultaneously
- ✅ **Multi-screen** compatible
- ❌ Does not work if the QR code is partially hidden
- ❌ Does not work if the QR code is too small or blurry

---

## Uninstallation

To completely remove QRdecode:

```bash
bash ~/.local/share/qrdecode/uninstall.sh
```

---

## Technical Information

- **Language:** Python 3
- **Main libraries:** OpenCV, MSS, Tkinter
- **Screenshot:** Uses MSS for fast capture
- **Detection:** OpenCV QRCodeDetector with multi-QR code support
- **Browser:** Opens the system's default browser

---

**[⬆ Back to top](#qrdecode---guide-dinstallation-et-dutilisation--installation-and-user-guide) | [🇫🇷 Version Française](#version-française)**

---

*Guide created for QRdecode - Version 1.0 - by vtf*
