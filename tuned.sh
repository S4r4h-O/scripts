#!/bin/bash

set -me

if ! command -v tuned-adm >/dev/null; then
	echo "Tuned is not installed or not in PATH."
	exit 1
fi

profiles="$(tuned-adm list | awk -F'- ' '/^-/ {print $2}' | sort | sed -e 's/[[:space:]]*$//')"

chosen_profile="$(printf '%s\n' "${profiles[@]}" | fzf)" || exit 1

current="$(tuned-adm active | awk -F': ' '{print $2}')"

if [[ $current == "$chosen_profile" ]]; then
	echo "Already using $chosen_profile"
	exit 0
fi

if ! tuned-adm profile "$chosen_profile"; then
	echo "$(tput setaf 1)Failed to switch to $chosen_profile$(tput sgr0)"
	exit 1
fi
echo "Switched from $(tput setaf 2)$current$(tput sgr0) to $(tput setaf 2)$chosen_profile$(tput sgr0) successfully."
