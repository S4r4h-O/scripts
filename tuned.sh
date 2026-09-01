#!/bin/bash

set -me

profiles=(
	accelerator-performance
	atomic-guest
	atomic-host
	aws
	balanced
	balanced-battery
	cpu-partitioning
	cpu-partitioning-powersave
	default
	desktop
	desktop-powersave
	enterprise-storage
	hpc-compute
	intel-sst
	laptop-ac-powersave
	laptop-battery-powersave
	latency-performance
	mssql
	network-latency
	network-throughput
	openshift
	openshift-control-plane
	openshift-node
	optimize-serial-console
	oracle
	postgresql
	powersave
	realtime
	realtime-virtual-guest
	realtime-virtual-host
	sap-hana
	sap-hana-kvm-guest
	sap-netweaver
	server-powersave
	spectrumscale-ece
	spindown-disk
	throughput-performance
	virtual-guest
	virtual-host
)

profile="$(printf '%s\n' "${profiles[@]}" | fzf)" || exit 1
current="$(tuned-adm profile | gawk -F': ' '/Current active profile/ {print $2}')"

if [[ $current == "$profile" ]]; then
	echo "Already using $profile"
	exit 0
fi

if ! command -v tuned-adm >/dev/null; then
	echo "Tuned is not installed or not in PATH."
	exit 1
elif ! tuned-adm profile "$profile"; then
	echo "$(tput setaf 1)Failed to switch to $profile$(tput sgr0)"
	exit 1
fi
echo "Switched from $(tput setaf 2)$current$(tput sgr0) to $(tput setaf 2)$profile$(tput sgr0) successfully."
