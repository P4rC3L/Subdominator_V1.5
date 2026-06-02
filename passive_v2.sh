#!/bin/bash

# ========= CONFIG =========

VENV_PATH="/home/kali/recon/Subdominator/venv" # <-- Make changes here!
OUTPUT_DIR="./sub_recon"

# ===========================

# Validate input
if [ $# -ne 1 ]; then
    echo "Usage: $(basename "$0") <domain>"
    exit 1
fi

DOMAIN="$1"

# Verify venv exists
if [ ! -f "$VENV_PATH/bin/activate" ]; then
    echo "[!] Virtual environment not found:"
    echo "    $VENV_PATH"
    exit 1
fi

# Create output directory if absent
mkdir -p "$OUTPUT_DIR"

OUTPUT_FILE="$OUTPUT_DIR/${DOMAIN}_passive.txt"

echo "[*] Target: $DOMAIN"
echo "[*] Output: $OUTPUT_FILE"

# Source venv
source "$VENV_PATH/bin/activate"

# Run tool
subdominator \
    -d "$DOMAIN" \
    -rd 2 \
    -o "$OUTPUT_FILE"

STATUS=$?

# Explicit cleanup (optional)
deactivate 2>/dev/null

if [ $STATUS -eq 0 ]; then
    echo "[+] Enumeration complete"
    echo "[+] Saved: $OUTPUT_FILE"
else
    echo "[!] Tool execution failed"
    exit $STATUS
fi
