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


  local toplevel_nodes_count="$(yq 'length' "$file")"
  local commands_nodes_count
  if [[ "$(yq '. == null' "$file")" == "true" ]]; then
    commands_nodes_count=0
  else
    commands_nodes_count="$(yq 'keys | map(select(. == "commands")) | length' "$file")"
  fi

  if [[ "$toplevel_nodes_count" -gt 1 || "$commands_nodes_count" -ne 1 ]]; then
    echo "Format Error: '$file' should have 'commands' as the (only) top-level node." >&2
    echo "It currently has $toplevel_nodes_count top-level nodes." >&2
    echo "$commands_nodes_count of which are 'commands'." >&2
    return 1
  fi

  local num_occurrances="$(yq ".commands | map(select(.alias == \"$alias\")) | length" "$file")"

  if [[ "$num_occurrances" -gt 1 ]]; then
    echo "Format Error: '$file' has multiple commands with the alias '$alias'." >&2
    echo "It should have only one." >&2
    echo "It currently has $num_occurrances occurances." >&2
    return 1
  fi

  if [[ "$num_occurrances" -eq 1 ]]; then
    local command=$(yq ".commands | map(select(.alias == \"$alias\"))[0] | .command" "$file")

    if [[ "$command" == "null" ]]; then
      echo "Format Error: '$file' has an alias '$alias', but no command." >&2
      echo "Each alias should have exactly one command." >&2
      return 1
    fi
    echo "$command"
  fi
}
