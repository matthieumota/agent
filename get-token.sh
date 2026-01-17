#!/bin/bash

APP_ID=2672022
INSTALLATION_ID=104604732
PEM_FILE="$HOME/.ssh/app-private-key.pem"

base64url_encode() {
    base64 -w0 | tr -d '=' | tr '/+' '_-'
}

NOW=$(date +%s)
EXP=$((NOW + 600))

HEADER=$(echo -n "{\"alg\":\"RS256\",\"typ\":\"JWT\"}" | base64url_encode)
PAYLOAD=$(echo -n "{\"iat\":$NOW,\"exp\":$EXP,\"iss\":$APP_ID}" | base64url_encode)
SIGNATURE=$(echo -n "${HEADER}.${PAYLOAD}" | openssl dgst -sha256 -sign "$PEM_FILE" | base64url_encode)
JWT="${HEADER}.${PAYLOAD}.${SIGNATURE}"

RESPONSE=$(curl -s -X POST \
    -H "Authorization: Bearer $JWT" \
    -H "Accept: application/vnd.github+json" \
    "https://api.github.com/app/installations/${INSTALLATION_ID}/access_tokens")

TOKEN=$(echo "$RESPONSE" | jq -r '.token')
echo "$TOKEN"
