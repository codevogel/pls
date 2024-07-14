query_command() {
  local alias="$1"

  local global_file="$PLS_GLOBAL"
  local local_file="$(get_closest_file "$PWD" "$PLS_FILENAME")"

  local command
  if [ -f "$global_file" ]; then
    command=$(query_command_in_file "$alias" "$global_file")
    if [ $? -neq 0 ]; then
      exit 1
    fi
  fi

  if [ -f "$local_file" ]; then
    command=$(query_command_in_file "$alias" "$local_file")
    if [ $? -neq 0 ]; then
      exit 1
    fi
  fi

  if [ -n "$command" ]; then
     echo "$command"
  fi
}