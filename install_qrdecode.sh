#!/bin/bash
set -e

################################################################################
# CONFIGURATION - Modifier ces variables pour adapter à votre programme
################################################################################

# Informations de l'application
APP_NAME="QRdecode"
APP_DESCRIPTION="Décodeur de QR codes à l'écran"
APP_COMMENT="Décodeur de QR codes à l'écran"
APP_CATEGORIES="Utility;Graphics;"

# URL du dépôt GitHub (sans le / final)
GITHUB_REPO_URL="https://raw.githubusercontent.com/vtflosa/QRdecode/main"

# Liste des fichiers à télécharger depuis GitHub
# Format: "nom_fichier_distant:nom_fichier_local" (ou juste "nom_fichier" si identique)
DOWNLOAD_FILES=(
    "main.py"
    "requirements.txt"
    "QRdecode.png"
)

# Fichier Python principal à exécuter
MAIN_PYTHON_FILE="main.py"

# Fichier de l'icône
ICON_FILE="QRdecode.png"

# Dépendances Python
NEEDS_TKINTER=true  # true si votre programme utilise Tkinter, false sinon

# Dépendances système supplémentaires (en plus de python3-pip, python3-venv et éventuellement python3-tk)
# Laisser vide si aucune dépendance supplémentaire
EXTRA_SYSTEM_DEPS=""

################################################################################
# FIN DE LA CONFIGURATION - Ne pas modifier en dessous de cette ligne
################################################################################

# Calcul automatique du dossier d'installation basé sur APP_NAME
APP_NAME_LOWER=$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]')
INSTALL_SUBDIR=".local/share/${APP_NAME_LOWER}"

echo "╔══════════════════════════════════════════════════╗"
echo "║     Installation de ${APP_NAME}"
echo "║     ${APP_DESCRIPTION}"
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


# #############################################################
# Vérifier que Python 3 est installé
# #############################################################

if ! command -v python3 &> /dev/null; then
    error "Python 3 n'est pas installé !"
    echo "Veuillez installer Python 3 d'abord."
    exit 1
fi

info "Python 3 détecté : $(python3 --version)"


# #############################################################
# Vérifier si tkinter, pip et venv sont déjà installés
# #############################################################

info "Vérification des dépendances Python..."

TKINTER_OK=true  # Par défaut OK si pas nécessaire
PIP_OK=false
VENV_OK=false

# Test tkinter seulement si nécessaire
if [ "$NEEDS_TKINTER" = true ]; then
    TKINTER_OK=false
    if python3 -c "import tkinter" 2>/dev/null; then
        TKINTER_OK=true
    fi
fi

# Test pip
if python3 -m pip --version &>/dev/null; then
    PIP_OK=true
fi

# Test venv
if python3 -m venv --help &>/dev/null; then
    VENV_OK=true
fi

# Vérifier si tout est présent
if [ "$TKINTER_OK" = true ] && [ "$PIP_OK" = true ] && [ "$VENV_OK" = true ]; then
    if [ "$NEEDS_TKINTER" = true ]; then
        info "Toutes les dépendances sont déjà installées (tkinter, pip, venv) ✓"
    else
        info "Toutes les dépendances sont déjà installées (pip, venv) ✓"
    fi
    ALL_INSTALLED=true
else
    # Afficher ce qui manque
    warning "Dépendances manquantes :"
    [ "$NEEDS_TKINTER" = true ] && [ "$TKINTER_OK" = false ] && echo "  ✗ tkinter"
    [ "$PIP_OK" = false ] && echo "  ✗ pip"
    [ "$VENV_OK" = false ] && echo "  ✗ venv"
    ALL_INSTALLED=false
fi

# Installation seulement si quelque chose manque
if [ "$ALL_INSTALLED" = false ]; then
    info "Détection de votre distribution Linux..."
    
    # Construire la liste des paquets à installer
    TKINTER_PACKAGE=""
    if [ "$NEEDS_TKINTER" = true ]; then
        TKINTER_PACKAGE="python3-tk"
    fi
    
    if command -v apt &> /dev/null; then
        PKG_MANAGER="apt"
        DISTRO="Debian/Ubuntu"
        info "Distribution détectée : $DISTRO"
        info "Installation des dépendances manquantes..."
        sudo apt update
        sudo apt install -y $TKINTER_PACKAGE python3-pip python3-venv $EXTRA_SYSTEM_DEPS
        
    elif command -v dnf &> /dev/null; then
        PKG_MANAGER="dnf"
        DISTRO="Fedora/RHEL"
        TKINTER_FEDORA=""
        if [ "$NEEDS_TKINTER" = true ]; then
            TKINTER_FEDORA="python3-tkinter"
        fi
        info "Distribution détectée : $DISTRO"
        info "Installation des dépendances manquantes..."
        sudo dnf install -y $TKINTER_FEDORA python3-pip $EXTRA_SYSTEM_DEPS
        
    elif command -v pacman &> /dev/null; then
        PKG_MANAGER="pacman"
        DISTRO="Arch Linux"
        TKINTER_ARCH=""
        if [ "$NEEDS_TKINTER" = true ]; then
            TKINTER_ARCH="tk"
        fi
        info "Distribution détectée : $DISTRO"
        info "Installation des dépendances manquantes..."
        sudo pacman -S --noconfirm python $TKINTER_ARCH python-pip $EXTRA_SYSTEM_DEPS
        
    else
        error "Distribution non reconnue."
        if [ "$NEEDS_TKINTER" = true ]; then
            error "Veuillez installer manuellement : python3-tk, python3-pip, python3-venv"
        else
            error "Veuillez installer manuellement : python3-pip, python3-venv"
        fi
        exit 1
    fi
    
    # Vérifier que tout est maintenant installé
    info "Vérification post-installation..."
    INSTALL_SUCCESS=true
    
    if [ "$NEEDS_TKINTER" = true ] && ! python3 -c "import tkinter" 2>/dev/null; then
        error "✗ tkinter n'a pas pu être installé"
        INSTALL_SUCCESS=false
    fi
    
    if ! python3 -m pip --version &>/dev/null; then
        error "✗ pip n'a pas pu être installé"
        INSTALL_SUCCESS=false
    fi
    
    if ! python3 -m venv --help &>/dev/null; then
        error "✗ venv n'a pas pu être installé"
        INSTALL_SUCCESS=false
    fi
    
    if [ "$INSTALL_SUCCESS" = true ]; then
        info "Toutes les dépendances ont été installées avec succès ✓"
    else
        error "Certaines dépendances n'ont pas pu être installées"
        exit 1
    fi
fi


# #############################################################
# Créer le dossier d'installation
# #############################################################

INSTALL_DIR="$HOME/$INSTALL_SUBDIR"
info "Création du dossier d'installation : $INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

# Télécharger les fichiers depuis GitHub
info "Téléchargement des fichiers depuis GitHub..."

for file_entry in "${DOWNLOAD_FILES[@]}"; do
    # Séparer le nom distant du nom local si format "distant:local"
    if [[ "$file_entry" == *":"* ]]; then
        remote_file="${file_entry%%:*}"
        local_file="${file_entry##*:}"
    else
        remote_file="$file_entry"
        local_file="$file_entry"
    fi
    
    info "Téléchargement de $remote_file..."
    if ! wget -q --show-progress "$GITHUB_REPO_URL/$remote_file" -O "$local_file"; then
        error "Échec du téléchargement de $remote_file"
        exit 1
    fi
done

info "Tous les fichiers ont été téléchargés avec succès ✓"


# #############################################################
# Environnement virtuel et dépendances
# #############################################################

# Créer un environnement virtuel
info "Création de l'environnement virtuel Python..."
python3 -m venv venv

# Activer l'environnement virtuel et installer les dépendances
info "Installation des dépendances Python..."
source venv/bin/activate

if ! pip install --upgrade pip; then
    error "Échec de la mise à jour de pip"
    deactivate
    exit 1
fi

if ! pip install -r requirements.txt; then
    error "Échec de l'installation des dépendances Python depuis requirements.txt"
    error "Vérifiez le contenu du fichier requirements.txt et votre connexion internet"
    deactivate
    exit 1
fi

info "Dépendances installées ✓"


# #############################################################
# Créer le lanceur .desktop
# #############################################################

info "Création du lanceur d'application..."
DESKTOP_DIR="$HOME/.local/share/applications"
mkdir -p "$DESKTOP_DIR"

cat > "$DESKTOP_DIR/${APP_NAME}.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=${APP_NAME}
Comment=${APP_COMMENT}
Exec=$INSTALL_DIR/venv/bin/python $INSTALL_DIR/${MAIN_PYTHON_FILE}
Icon=$INSTALL_DIR/${ICON_FILE}
Terminal=false
Categories=${APP_CATEGORIES}
StartupNotify=true
EOF

chmod +x "$DESKTOP_DIR/${APP_NAME}.desktop"

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
    cp "$DESKTOP_DIR/${APP_NAME}.desktop" "$DESKTOP_FOLDER/"
    chmod +x "$DESKTOP_FOLDER/${APP_NAME}.desktop"
    
    # Pour GNOME, marquer comme fiable
    if [ "$XDG_CURRENT_DESKTOP" = "GNOME" ] || [ "$XDG_CURRENT_DESKTOP" = "ubuntu:GNOME" ]; then
        gio set "$DESKTOP_FOLDER/${APP_NAME}.desktop" metadata::trusted true 2>/dev/null || true
    fi
    
    info "Raccourci créé sur le bureau ✓"
fi


# #############################################################
# Créer un script de désinstallation
# #############################################################

cat > "$INSTALL_DIR/uninstall.sh" << EOF
#!/bin/bash
echo "Désinstallation de ${APP_NAME}..."
rm -rf "$INSTALL_DIR"
rm -f "$DESKTOP_DIR/${APP_NAME}.desktop"
rm -f ~/Bureau/${APP_NAME}.desktop
rm -f ~/Desktop/${APP_NAME}.desktop
echo "${APP_NAME} a été désinstallé."
EOF

chmod +x "$INSTALL_DIR/uninstall.sh"

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║         Installation terminée avec succès ! ✓    ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""
info "${APP_NAME} a été installé dans : $INSTALL_DIR"
info "Vous pouvez maintenant lancer l'application depuis :"
echo "  • Le menu des applications (cherchez '${APP_NAME}')"
if [ -n "$DESKTOP_FOLDER" ]; then
    echo "  • L'icône sur votre bureau"
fi
echo ""
info "Pour tout désinstaller proprement, exécutez dans la console : $INSTALL_DIR/uninstall.sh"
echo ""
echo ""
echo "Merci !"