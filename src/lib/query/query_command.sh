query_command() {
  local alias="$1"
  local report_found_in="$2" || 0

  if [ -z "$alias" ]; then
    echo "Usage Error: Alias cannot be empty." >&2
    return 1
  fi

  local global_file="$PLS_GLOBAL"
  local local_file="$(get_closest_file "$PWD" "$PLS_FILENAME")"

  local command
  local found_in
  if [ -f "$global_file" ]; then
    local result=$(query_command_in_file "$alias" "$global_file")
    if [ -n "$result" ]; then
      command="$result"
      found_in="$global_file"
    fi
  fi

  if [ -f "$local_file" ]; then
    local result=$(query_command_in_file "$alias" "$local_file")
    if [ -n "$result" ]; then
      command="$result"
      found_in="$local_file"
    fi
  fi

  echo "$command"
  if [ $report_found_in ]; then
    echo "$found_in"
  fi
}
