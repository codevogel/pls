check_version() {
  local min_version="$1"
  local actual_version="$2"
  if [[ "$(printf '%s\n%s' "$min_version" "$actual_version" | sort -V | head -n1)" != "$min_version" ]]; then
    return 1
  fi
}
