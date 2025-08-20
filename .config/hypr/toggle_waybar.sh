#!/bin/bash
CURRENT_STATE=$(hyprctl dispatch showbar)
if [ "$CURRENT_STATE" == "true" ]; then
  hyprctl dispatch showbar false
else
  hyprctl dispatch showbar true
fi
