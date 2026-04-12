_get_pid() {
  local proc_name=$1
  if ! pgrep -d, "$proc_name"; then
    echo "Process not found: $proc_name" >&2
    return 1
  fi
}

_get_info() {
  local proc=$1
  # ps -o rss,vsz,comm -p $(_get_pid "$proc") | awk '$1 ~ /^[0-9]+$/ {print $1}'
  ps -o rss,vsz,comm -p "$(_get_pid "$proc")" | awk '
  NR > 1 {
    $1 = $1/1024 " MB |";
    $2 = $2/1024 " MB (virtual)";
    print
  }'
}

for i in "$@"; do
  _get_info "$i"
done
