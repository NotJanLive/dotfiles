#!/bin/bash

INTERFACE="wg0"

short_key() {
  echo "$1" | cut -c1-8
}

# Get local IP address of wg0 interface
LOCAL_IP=$(ip -4 addr show dev "$INTERFACE" 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n1)
[ -z "$LOCAL_IP" ] && LOCAL_IP="N/A"

# Check if interface is up
if ip link show "$INTERFACE" 2>/dev/null | grep -q "state"; then
    PEERS=$(sudo wg show "$INTERFACE" peers 2>/dev/null)
    NOW=$(date +%s)

    TOOLTIP="WireGuard connected\nLocal IP: $LOCAL_IP\n"

    if [ -z "$PEERS" ]; then
        TOOLTIP+="No peers found"
    else
        while read -r PEER; do
            SHORT=$(short_key "$PEER")

            # Get endpoint (fallback to config if not available)
            ENDPOINT=$(sudo wg show "$INTERFACE" endpoint "$PEER" 2>/dev/null)
            if [ -z "$ENDPOINT" ]; then
                ENDPOINT=$(sudo cat /etc/wireguard/wg0.conf | awk -v key="$PEER" '
                    $1 == "[Peer]" { found=0 }
                    $1 == "PublicKey" && $3 == key { found=1 }
                    found && $1 == "Endpoint" { print $3; exit }
                ')
                [ -z "$ENDPOINT" ] && ENDPOINT="N/A"
            fi

            # Get allowed IPs (fallback to config)
            ALLOWED_IPS=$(sudo wg show "$INTERFACE" allowed-ips "$PEER" 2>/dev/null)
            if [ -z "$ALLOWED_IPS" ]; then
                ALLOWED_IPS=$(sudo cat /etc/wireguard/wg0.conf | awk -v key="$PEER" '
                    $1 == "[Peer]" { found=0 }
                    $1 == "PublicKey" && $3 == key { found=1 }
                    found && $1 == "AllowedIPs" { print substr($0, index($0,$2)); exit }
                ')
                [ -z "$ALLOWED_IPS" ] && ALLOWED_IPS="N/A"
            fi

            # Get last handshake
            LAST_HANDSHAKE=$(sudo wg show "$INTERFACE" latest-handshakes "$PEER" 2>/dev/null)
            if [[ "$LAST_HANDSHAKE" -eq 0 ]]; then
                HS="Never"
            else
                AGE=$((NOW - LAST_HANDSHAKE))
                if (( AGE < 60 )); then
                    HS="${AGE}s ago"
                elif (( AGE < 3600 )); then
                    HS="$((AGE / 60))m ago"
                else
                    HS="$((AGE / 3600))h ago"
                fi
            fi

            TOOLTIP+="Endpoint: $ENDPOINT\nAllowed IPs: $ALLOWED_IPS\nLast handshake: $HS"
        done <<< "$PEERS"
    fi

    TOOLTIP_ESCAPED=$(echo -e "$TOOLTIP" | sed ':a;N;$!ba;s/\n/\\n/g' | sed 's/"/\\"/g')
    echo "{\"text\": \"<span color=\\\"#2ecc71\\\">⏻ VPN</span>\", \"tooltip\": \"$TOOLTIP_ESCAPED\", \"class\": \"connected\"}"
else
    echo "{\"text\": \"<span color=\\\"#ff9999\\\">⏻ VPN</span>\", \"tooltip\": \"WireGuard is disconnected\", \"class\": \"disconnected\"}"
fi

