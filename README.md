# QRdecode - Guide d'installation et d'utilisation pour Linux

## Description
QRdecode est un programme Python qui détecte automatiquement les QR codes affichés à l'écran de votre ordinateur, les décode et ouvre les liens correspondants dans votre navigateur.

---

## Installation

### 1. Créer le dossier et copier les fichiers

Ouvrez un terminal et exécutez les commandes suivantes :

```bash
# Créer le dossier QRdecode dans votre répertoire personnel
mkdir -p ~/QRdecode

# Se déplacer dans ce dossier
cd ~/QRdecode
```

Copiez ensuite les fichiers `main.py` et `requirements.txt` dans ce dossier.

---

### 2. Créer un environnement virtuel Python

```bash
# Créer l'environnement virtuel
python3 -m venv venv

# Activer l'environnement virtuel
source venv/bin/activate
```

> **Note :** Vous verrez `(venv)` apparaître au début de votre ligne de commande, indiquant que l'environnement virtuel est activé.

---

### 3. Installer les dépendances Python

```bash
# Installer les packages depuis requirements.txt
pip install -r requirements.txt
```

---

### 4. Vérifier l'installation de Tkinter

Tkinter est généralement pré-installé avec Python, mais vérifiez son installation :

```bash
# Tester Tkinter
python3 -c "import tkinter"
```

Si vous obtenez une erreur, installez Tkinter :

**Pour Ubuntu/Debian :**
```bash
sudo apt-get update
sudo apt-get install python3-tk
```

**Pour Fedora :**
```bash
sudo dnf install python3-tkinter
```

**Pour Arch Linux :**
```bash
sudo pacman -S tk
```

---


### 5. Créer un raccourci sur le bureau

Créez un fichier `.desktop` pour le raccourci (Linux Mint):

```bash
xed ~/Bureau/QRdecode.desktop
```

Sur Ubuntu :

```bash
gedit ~/Bureau/QRdecode.desktop
```

> **Note :** Sur certaines distributions, le dossier peut s'appeler `Desktop` au lieu de `Bureau`. Il peut être nécessaire de changer l'éditeur de texte par défaut

Copiez-y le contenu suivant :

```desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=QRdecode
Comment=Détecter et décoder les QR codes à l'écran
Exec= ~/QRdecode/venv/bin/python3 ~/QRdecode/main.py
Icon= ~/QRdecode/QRdecode.png
Terminal=false
Categories=Utility;
```

Rendez le fichier `.desktop` exécutable :

```bash
chmod +x ~/Bureau/QRdecode.desktop
```

Sur certains environnements de bureau (comme GNOME), vous devrez peut-être autoriser le lancement :
- Clic droit sur l'icône → "Autoriser le lancement" ou "Trust and Launch"

---

## Utilisation

### Comment utiliser QRdecode

1. **Affichez le QR code à l'écran**
   - Ouvrez l'image, le site web ou le document contenant le QR code
   - Assurez-vous que le QR code est **bien visible et entièrement affiché** à l'écran
   - Le QR code peut être n'importe où sur l'écran (même avec plusieurs moniteurs)

2. **Lancez le programme**
   - Double-cliquez sur l'icône QRdecode sur votre bureau

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

## Dépannage

### Le programme ne démarre pas
```bash
# Vérifiez que l'environnement virtuel fonctionne
cd ~/QRdecode
source venv/bin/activate
python main.py
```

### Erreur "No module named cv2"
```bash
cd ~/QRdecode
source venv/bin/activate
pip install --upgrade opencv-python
```

### Erreur Tkinter
```bash
# Réinstallez python3-tk
sudo apt-get install --reinstall python3-tk
```

### Aucun QR code détecté
- Vérifiez que le QR code est entièrement visible
- Augmentez la taille du QR code à l'écran

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

## Support

En cas de problème, vérifiez :
1. La version de Python (minimum 3.6) : `python3 --version`
2. Les logs dans le terminal lors du lancement manuel
3. Les permissions d'exécution des fichiers

---

*Guide créé pour QRdecode - Version 1.0 - by vtf*
