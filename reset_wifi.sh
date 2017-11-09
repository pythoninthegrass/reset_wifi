#!/usr/bin/env bash

# Exit upon failed command
# set -e

# Logs
logTime=$(date +%Y-%m-%d:%H:%M:%S)
resetLog="/tmp/$(basename "$0" | cut -d. -f1)_$logTime.log"
exec &> >(tee -a "$resetLog")

# Current user
# loggedInUser=$(stat -f%Su /dev/console)

# Working directory
# scriptDir=$(cd "$(dirname "$0")" && pwd)

# Ensure running as root
if [[ "$(id -u)" != "0" ]]; then
  exec sudo "$0" "$@"
fi

# Set $IFS to eliminate whitespace in pathnames
IFS="$(printf '\n\t')"

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
cd /Library/Preferences/SystemConfiguration/ || exit
for f in "${plistsArray[@]}"; do
    echo "Removed $f."
    [[ -f "$f" ]] && rm -f "$f"
done

unset IFS

# Reboot
confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case "$response" in
        [yY][eE][sS]|[yY])
            true
            ;;
        *)
            false
            ;;
    esac
}
confirm "Do you want to reboot now [Y/n]?" && /usr/bin/sudo sh -c "reboot"
