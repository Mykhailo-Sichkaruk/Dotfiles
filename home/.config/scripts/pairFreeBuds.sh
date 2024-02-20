#!/bin/bash

# Define the MAC address of your Bluetooth headphones
headphones_mac="28:6F:40:41:3F:6D"

# Check if Bluetooth is enabled
if [[ $(bluetoothctl show | grep "Powered: yes") ]]; then
  # Bluetooth is already enabled, so check if the headphones are connected
  connected=$(bluetoothctl info "$headphones_mac" | grep "Connected: yes")
  
  echo "Disconnecting Bluetooth headphones..."
  bluetoothctl disconnect "$headphones_mac"

  # Bluetooth is disabled, so enable it
  echo "Disabling Bluetooth..."
  bluetoothctl power off
else
  # Bluetooth is disabled, so enable it
  echo "Enabling Bluetooth..."
  bluetoothctl power on
  
  # Wait for a moment before checking and connecting to the headphones
  sleep 3

  # Check if the headphones are already connected
  connected=$(bluetoothctl info "$headphones_mac" | grep "Connected: yes")

  if [ -n "$connected" ]; then
    # Headphones are already connected, so disconnect them
    echo "Already connected Bluetooth headphones..."
  else
    # Headphones are not connected, so try to connect
    echo "Connecting to Bluetooth headphones..."
    bluetoothctl connect "$headphones_mac"
  fi
fi
