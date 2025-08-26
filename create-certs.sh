#!/bin/bash
set -e

# Load environment variables
set -o allexport
source .env
set +o allexport

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WEBROOT="$SCRIPT_DIR/webroot"
DEST_DIR="$SCRIPT_DIR/ssl"

# Convert domains string to array
IFS=' ' read -r -a DOMAIN_ARRAY <<< "$DOMAINS"

# Create SSL directory if it doesn't exist
mkdir -p "$DEST_DIR"

echo ">>> Criando certificados SSL iniciais..."
for DOMAIN in "${DOMAIN_ARRAY[@]}"; do
    echo ">>> Criando certificado para $DOMAIN"
    
    certbot certonly --webroot -w "$WEBROOT" \
        -d "$DOMAIN" \
        --non-interactive --agree-tos -m "$EMAIL"

    echo ">>> Copiando certificados para pasta ssl/"
    cp "/etc/letsencrypt/live/$DOMAIN/fullchain.pem" "$DEST_DIR/${DOMAIN%%.*}-fullchain.pem"
    cp "/etc/letsencrypt/live/$DOMAIN/privkey.pem" "$DEST_DIR/${DOMAIN%%.*}-privkey.pem"
done

echo ">>> Certificados criados e copiados com sucesso!"