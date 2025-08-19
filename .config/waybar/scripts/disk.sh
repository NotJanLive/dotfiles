#!/bin/bash

# This gets the root filesystem's usage (change "/" if needed)
ICON=""
USAGE=$(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')

echo "{\"text\": \"$USAGE\", \"tooltip\": \"Disk usage for /\"}"
