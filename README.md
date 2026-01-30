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
# Supprimer le dossier
rm -rf ~/QRdecode

# Supprimer le raccourci
rm ~/Bureau/QRdecode.desktop
```

---

## Informations techniques

- **Langage :** Python 3
- **Bibliothèques principales :** OpenCV, MSS, Tkinter
- **Capture d'écran :** Utilise MSS pour une capture rapide
- **Détection :** OpenCV QRCodeDetector avec support multi-QR codes
- **Navigateur :** Ouvre le navigateur par défaut du système

---

*Guide créé pour QRdecode - Version 1.0 - by vtf*
