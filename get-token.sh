#!/bin/bash
set -e  # Exit on error

APP_ID=2672022
INSTALLATION_ID=104604732
PEM_FILE="$HOME/.ssh/app-private-key.pem"

# Check if PEM file exists
if [ ! -f "$PEM_FILE" ]; then
    echo "❌ Error: PEM file not found at $PEM_FILE" >&2
    exit 1
fi

base64url_encode() {
    base64 -w0 | tr -d '=' | tr '/+' '_-'
}

# Create JWT
NOW=$(date +%s)
EXP=$((NOW + 600))

HEADER=$(echo -n "{\"alg\":\"RS256\",\"typ\":\"JWT\"}" | base64url_encode)
PAYLOAD=$(echo -n "{\"iat\":$NOW,\"exp\":$EXP,\"iss\":$APP_ID}" | base64url_encode)
SIGNATURE=$(echo -n "${HEADER}.${PAYLOAD}" | openssl dgst -sha256 -sign "$PEM_FILE" | base64url_encode)
JWT="${HEADER}.${PAYLOAD}.${SIGNATURE}"

# Request token from GitHub
RESPONSE=$(curl -s -X POST \
    -H "Authorization: Bearer $JWT" \
    -H "Accept: application/vnd.github+json" \
    "https://api.github.com/app/installations/${INSTALLATION_ID}/access_tokens")

# Validate response
if [ -z "$RESPONSE" ]; then
    echo "❌ Error: Empty response from GitHub API" >&2
    exit 1
fi

# Extract token
TOKEN=$(echo "$RESPONSE" | jq -r '.token')

# Validate token
if [ -z "$TOKEN" ] || [ "$TOKEN" = "null" ]; then
    echo "❌ Error: Failed to extract token from response" >&2
    echo "Response: $RESPONSE" >&2
    exit 1
fi

echo "$TOKEN"
