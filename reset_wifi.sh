#!/usr/bin/env bash

# Repurposed by-hand bits into a script.

# Exit upon failed command
# set -e

# Logs
logTime=$(date +%Y-%m-%d:%H:%M:%S)
resetLog="/tmp/pkg_install_$logTime.log"
exec &> >(tee -a "$resetLog")

# Current user
loggedInUser=$(ls -l /dev/console | cut -d " " -f 4)

# Working directory
scriptDir=$(cd "$(dirname "$0")" && pwd)

# Check for root privileges
if [ $(whoami) != "root" ]; then
    echo "Sorry, you need super user privileges to run this script."
    exit 1
fi

# PLISTs
declare -a plistsArray=(
    com.apple.airport.preferences.plist
    com.apple.network.eapolclient.configuration.plist
    com.apple.wifi.message-tracer.plist
    NetworkInterfaces.plist
    preferences.plist
)
# echo $plistsArray

# Remove wifi PLISTs
cd /Library/Preferences/SystemConfiguration/
for f in "${plistsArray[@]}"; do
    echo "Removed $f."
    [ -f "$f" ] && rm -f "$f"
done

# Reboot
echo "Restarting now. Hit CTRL-C to cancel."
sleep 5s
sudo reboot
