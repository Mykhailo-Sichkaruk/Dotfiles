#!/usr/bin/env sh
# NOTE: DONT FORGET TO ADD EXECUTE PERMISSION: chmod +x toggle-mute.sh
pulsemixer --list-sources \
  | awk -F'ID: |, Name:' '/^Source:/ {print $2}' \
  | while IFS= read -r id; do
      pulsemixer --id "$id" --toggle-mute
    done
