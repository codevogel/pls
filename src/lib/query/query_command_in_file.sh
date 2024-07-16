query_command_in_file() {
  local alias="$1"
  local file="$2"

  if [ -z "$alias" ]; then
    echo "Usage Error: Alias cannot be empty." >&2
    return 1
  fi

  if [ ! -f "$file" ]; then
    echo "Usage Error: '$file' does not exist." >&2
    return 1
  fi

  local command="$(yq ".commands | map(select(.alias == \"$alias\"))[0] | .command" "$file")"
  [[ $command == "null" ]] && echo "" || echo "$command" 
}
