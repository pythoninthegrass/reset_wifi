#!/bin/sh

# Credit: http://osxdaily.com/2016/09/22/fix-wi-fi-problems-macos-sierra/
# Repurposed by-hand bits into a script.

# ToDo:
# Needs error handling for that rare possibility wifi PLISTs
# don't exist and will exit 1 the whole script.

# Current user
loggedInUser=$(ls -l /dev/console | cut -d " " -f 4)

# Remove wifi PLISTs
cd /Library/Preferences/SystemConfiguration/
#ls | grep com.apple.airport.preferences.plist
sudo rm -f com.apple.airport.preferences.plist
sudo rm -f com.apple.network.eapolclient.configuration.plist
sudo rm -f com.apple.wifi.message-tracer.plist
sudo rm -f NetworkInterfaces.plist
sudo rm -f preferences.plist

# Reboot
echo "Restarting now. Hit CTRL-C to cancel."
sleep 10s
sudo reboot
