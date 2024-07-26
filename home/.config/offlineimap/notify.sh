#!/bin/bash

MAILDIR="$HOME/Maildir"
NEWMAILDIR="$MAILDIR/new"

# Iterate through each new mail file
for mail in "$NEWMAILDIR"/*; do
    # Check if there are any files in the directory
    if [ -e "$mail" ]; then
        # Extract the subject of the email
        subject=$(grep -m 1 "^Subject: " "$mail" | sed 's/^Subject: //')
        # Send notification
        notify-send "New Mail" "$subject"
    fi
done
