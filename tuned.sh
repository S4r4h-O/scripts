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

if ! command -v tuned-adm >/dev/null; then
  echo "Tuned is not installed or not in PATH."
elif ! tuned-adm profile "$profile"; then
  echo "$(tput setaf 1)Failed to switch to $profile$(tput sgr0)"
  return 1
fi
echo "Switched to $(tput setaf 2)$profile$(tput sgr0) successfully."
