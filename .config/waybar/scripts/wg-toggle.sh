#!/bin/bash

INTERFACE="wg0"
WG="/usr/bin/wg-quick"
NOTIFY="/usr/bin/notify-send"
TIMEOUT=5000  # 5 seconds

if ip link show "$INTERFACE" 2>/dev/null | grep -q "state"; then
    # VPN is up – bring it down
    if sudo "$WG" down "$INTERFACE"; then
        $NOTIFY "VPN Disconnected" "WireGuard interface $INTERFACE is now OFF" -u normal -i network-vpn -t $TIMEOUT
    else
        $NOTIFY "VPN Error" "Failed to bring down $INTERFACE" -u critical -i dialog-error -t $TIMEOUT
    fi
else
    # VPN is down – bring it up
    if sudo "$WG" up "$INTERFACE"; then
        $NOTIFY "VPN Connected" "WireGuard interface $INTERFACE is now ON" -u normal -i network-vpn -t $TIMEOUT
    else
        $NOTIFY "VPN Error" "Failed to bring up $INTERFACE" -u critical -i dialog-error -t $TIMEOUT
    fi
fi

