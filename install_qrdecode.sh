#!/bin/bash
set -e

echo "╔══════════════════════════════════════════════════╗"
echo "║     Installation de QRdecode                    ║"
echo "║     Décodeur de QR codes à l'écran              ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Fonction pour afficher les messages
info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

error() {
    echo -e "${RED}[ERREUR]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[ATTENTION]${NC} $1"
}

# Vérifier que Python 3 est installé
if ! command -v python3 &> /dev/null; then
    error "Python 3 n'est pas installé !"
    echo "Veuillez installer Python 3 d'abord."
    exit 1
fi

info "Python 3 détecté : $(python3 --version)"

# Détection de la distribution et installation de tkinter
info "Détection de votre distribution Linux..."

if command -v apt &> /dev/null; then
    PKG_MANAGER="apt"
    DISTRO="Debian/Ubuntu"
    info "Distribution détectée : $DISTRO"
    info "Installation de python3-tk..."
    sudo apt update
    sudo apt install -y python3-tk python3-pip python3-venv
    
elif command -v dnf &> /dev/null; then
    PKG_MANAGER="dnf"
    DISTRO="Fedora/RHEL"
    info "Distribution détectée : $DISTRO"
    info "Installation de python3-tkinter..."
    sudo dnf install -y python3-tkinter python3-pip
    
elif command -v pacman &> /dev/null; then
    PKG_MANAGER="pacman"
    DISTRO="Arch Linux"
    info "Distribution détectée : $DISTRO"
    info "Installation de tk..."
    sudo pacman -S --noconfirm python tk python-pip
    
else
    warning "Distribution non reconnue. Tkinter doit être installé manuellement."
fi

# Créer le dossier d'installation
INSTALL_DIR="$HOME/.local/share/qrdecode"
info "Création du dossier d'installation : $INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

# Télécharger les fichiers depuis GitHub
info "Téléchargement des fichiers depuis GitHub..."

if ! wget -q --show-progress https://raw.githubusercontent.com/vtflosa/QRdecode/main/main.py; then
    error "Échec du téléchargement de main.py"
    exit 1
fi

if ! wget -q --show-progress https://raw.githubusercontent.com/vtflosa/QRdecode/main/requirements.txt; then
    error "Échec du téléchargement de requirements.txt"
    exit 1
fi

if ! wget -q --show-progress https://raw.githubusercontent.com/vtflosa/QRdecode/main/QRdecode.png; then
    error "Échec du téléchargement de QRdecode.png"
    exit 1
fi

info "Tous les fichiers ont été téléchargés avec succès ✓"

# Créer un environnement virtuel
info "Création de l'environnement virtuel Python..."
python3 -m venv venv

# Activer l'environnement virtuel et installer les dépendances
info "Installation des dépendances Python..."
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

info "Dépendances installées ✓"

# Vérifier que tkinter fonctionne
info "Vérification de tkinter..."
if python3 -c "import tkinter" 2>/dev/null; then
    info "Tkinter fonctionne correctement ✓"
else
    error "Tkinter ne fonctionne pas correctement"
    error "Veuillez installer python3-tk manuellement pour votre distribution avec la commande :"
    error "sudo apt install python3-tk"
    exit 1
fi

# Créer le lanceur .desktop
info "Création du lanceur d'application..."
DESKTOP_DIR="$HOME/.local/share/applications"
mkdir -p "$DESKTOP_DIR"

cat > "$DESKTOP_DIR/qrdecode.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=QRdecode
Comment=Décodeur de QR codes à l'écran
Exec=$INSTALL_DIR/venv/bin/python $INSTALL_DIR/main.py
Icon=$INSTALL_DIR/QRdecode.png
Terminal=false
Categories=Utility;Graphics;
StartupNotify=true
EOF

chmod +x "$DESKTOP_DIR/qrdecode.desktop"

info "Lanceur créé ✓"

# Créer également un lanceur sur le bureau si le dossier existe
DESKTOP_FOLDER=""
if [ -d "$HOME/Bureau" ]; then
    DESKTOP_FOLDER="$HOME/Bureau"
elif [ -d "$HOME/Desktop" ]; then
    DESKTOP_FOLDER="$HOME/Desktop"
fi

if [ -n "$DESKTOP_FOLDER" ]; then
    info "Création du raccourci sur le bureau..."
    cp "$DESKTOP_DIR/qrdecode.desktop" "$DESKTOP_FOLDER/"
    chmod +x "$DESKTOP_FOLDER/qrdecode.desktop"
    
    # Pour GNOME, marquer comme fiable
    if [ "$XDG_CURRENT_DESKTOP" = "GNOME" ] || [ "$XDG_CURRENT_DESKTOP" = "ubuntu:GNOME" ]; then
        gio set "$DESKTOP_FOLDER/qrdecode.desktop" metadata::trusted true 2>/dev/null || true
    fi
    
    info "Raccourci créé sur le bureau ✓"
fi

# Créer un script de désinstallation
cat > "$INSTALL_DIR/uninstall.sh" << 'EOF'
#!/bin/bash
echo "Désinstallation de QRdecode..."
rm -rf ~/.local/share/qrdecode
rm -f ~/.local/share/applications/qrdecode.desktop
rm -f ~/Bureau/qrdecode.desktop
rm -f ~/Desktop/qrdecode.desktop
echo "QRdecode a été désinstallé."
EOF

chmod +x "$INSTALL_DIR/uninstall.sh"

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║         Installation terminée avec succès ! ✓    ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""
info "QRdecode a été installé dans : $INSTALL_DIR"
info "Vous pouvez maintenant lancer l'application depuis :"
echo "  • Le menu des applications (cherchez 'QRdecode')"
if [ -n "$DESKTOP_FOLDER" ]; then
    echo "  • L'icône sur votre bureau"
fi
echo ""
info "Pour désinstaller, exécutez : $INSTALL_DIR/uninstall.sh"
echo ""