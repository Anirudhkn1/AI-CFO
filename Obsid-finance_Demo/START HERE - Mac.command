#!/bin/bash
# Obsid-finance demo launcher for macOS. Double-click to run. Nothing is installed or uploaded.
cd "$(dirname "$0")" || exit 1
clear
echo "Starting Obsid-finance..."
echo
if [ ! -f "app/index.html" ]; then
  echo "The 'app' folder is missing. Please unzip the whole package and try again."
  read -r -p "Press Enter to close."
  exit 1
fi
/usr/bin/perl "launcher/server.pl" "app" 8765
echo
read -r -p "Stopped. Press Enter to close."
