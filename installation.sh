#!/bin/bash

set -e
# ================= CONFIG =================

INSTALL_DIR="/home/kali/recon/"         # <-- Make changes here as required
REPO_URL="https://github.com/RevoltSecurities/Subdominator.git"
REPO_NAME="Subdominator"

SCRIPT_NAME="passive_v2.sh"

SCRIPT_URL="https://raw.githubusercontent.com/P4rC3L/Subdominator_V1.5/ReadMe/passive_v2.sh"

# ===========================================

echo "[*] Starting installation..."
# -------------------------
# Root check
# -------------------------
if [ "$EUID" -ne 0 ]; then
    echo "[!] Run as root:"
    echo "sudo $0"
    exit 1
fi

# -------------------------
# Package checks
# -------------------------
check_package() {

    PACKAGE=$1

    if ! dpkg -s "$PACKAGE" >/dev/null 2>&1; then
        echo "[*] Installing $PACKAGE"
        apt update
        apt install -y "$PACKAGE"
    else

        echo "[+] $PACKAGE already installed"
    fi
}

check_package git
check_package python3
check_package python3-pip
check_package python3-venv
check_package curl

# -------------------------
# Prepare install location
# -------------------------
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

# -------------------------
# Clone/update repo
# -------------------------
if [ -d "$REPO_NAME" ]; then
    echo "[*] Repo exists, updating..."
    cd "$REPO_NAME"
    git pull

else
    echo "[*] Cloning Subdominator..."
    git clone "$REPO_URL"
    cd "$REPO_NAME"
fi

# -------------------------
# Create venv if needed
# -------------------------
if [ ! -d "venv" ]; then
    echo "[*] Creating virtual environment"
    python3 -m venv venv
else
    echo "[+] Virtual environment exists"
fi

# -------------------------
# Activate + install
# -------------------------
echo "[*] Activating venv"

source venv/bin/activate

# Check whether Subdominator already exists in venv
if pip show subdominator >/dev/null 2>&1; then
    echo "[+] Subdominator already installed in venv"
    echo "[+] Skipping installation"
else
    echo "[*] Installing Subdominator"
    pip install .
    echo "[+] Installation complete"
fi

deactivate

# -------------------------
# Download helper script
# -------------------------

if [ ! -f "$SCRIPT_NAME" ]; then
    echo "[*] Downloading $SCRIPT_NAME"
    curl -L -o "$SCRIPT_NAME" "$SCRIPT_URL"
else
    echo "[+] $SCRIPT_NAME already exists"
fi

# -------------------------
# Permissions
# -------------------------
chmod +x "$SCRIPT_NAME"

cp "$SCRIPT_NAME" /usr/bin/

echo
echo "[+] Installation complete"
echo "[+] Tool available system-wide:"
echo
echo "    $SCRIPT_NAME"
echo
echo "[+] Subdominator installed in:"
echo
echo "    $INSTALL_DIR/$REPO_NAME"
echo
