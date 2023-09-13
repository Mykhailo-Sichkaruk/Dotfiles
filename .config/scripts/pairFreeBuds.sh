#!/bin/bash

# Define the MAC address of your Bluetooth headphones
headphones_mac="B0:45:02:CF:BE:16"

# Check if the headphones are already connected
connected=$(bluetoothctl info "$headphones_mac" | grep "Connected: yes")

if [ -n "$connected" ]; then
  # Headphones are already connected, so disconnect them
  echo "Disconnecting Bluetooth headphones..."
  bluetoothctl disconnect "$headphones_mac"
else
  # Headphones are not connected, so try to connect
  echo "Connecting to Bluetooth headphones..."
  bluetoothctl connect "$headphones_mac"
fi
