#!/bin/bash

# Run the 'pomodoro status' command and save the output
POMODORO_STATUS=$(pomodoro status)

# Display the output in a notification
notify-send "Pomodoro Status" "$POMODORO_STATUS"
