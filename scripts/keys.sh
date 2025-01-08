#!/bin/bash

# Define key backup directory
KEY_BACKUP_DIR="./key-backup"

# Import SSH Keys
import_ssh_keys() {
    echo "Importing SSH keys..."
    SSH_DIR="$HOME/.ssh"
    mkdir -p "$SSH_DIR"
    chmod 700 "$SSH_DIR"

    # Copy SSH keys to ~/.ssh
    cp "$KEY_BACKUP_DIR/ssh/id_ed25519" "$SSH_DIR/"
    cp "$KEY_BACKUP_DIR/ssh/id_ed25519.pub" "$SSH_DIR/"
    
    chmod 600 "$SSH_DIR/id_ed25519"
    chmod 644 "$SSH_DIR/id_ed25519.pub"

    # Add SSH key to ssh-agent
    eval "$(ssh-agent -s)"
    ssh-add "$SSH_DIR/id_ed25519"
    echo "SSH keys imported successfully!"
}

# Import GPG Keys
import_gpg_keys() {
    echo "Importing GPG keys..."
    # Import the private key
    if gpg --import "$KEY_BACKUP_DIR/gpg/private.key"; then
        echo "Private key imported successfully."
    else
        echo "Failed to import private key!"
        exit 1
    fi

    # Import the public key
    if gpg --import "$KEY_BACKUP_DIR/gpg/public.key"; then
        echo "Public key imported successfully."
    else
        echo "Failed to import public key!"
        exit 1
    fi

    # Import owner trust file
    if gpg --import-ownertrust "$KEY_BACKUP_DIR/gpg/ownertrust.txt"; then
        echo "Owner trust file imported successfully."
    else
        echo "Failed to import owner trust file!"
        exit 1
    fi

    echo "GPG keys imported successfully!"
}

# Main Execution
echo "Starting key import process..."
import_ssh_keys
import_gpg_keys
echo "Key import process completed!"
