#!/bin/bash

# Run the 'pomodoro status' command and save the output
POMODORO_STATUS=$(pomodoro status)

# Check if Pomodoro time is 0 or status is empty
if [[ "$POMODORO_STATUS" == \!* ]] || [[ -z "$POMODORO_STATUS" ]]; then
    # Send error notification
    notify-send "Pomodoro Error" "No active task" -u low
else
    # Display the current Pomodoro status
    notify-send "Pomodoro Status" "$POMODORO_STATUS"
fi
