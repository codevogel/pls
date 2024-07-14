query_command_in_file() {
  local alias="$1"
  local file="$2"

  local toplevel_nodes_count=$(yq '.[] | length' "$file")
  local commands_nodes_count=$(yq '.commands | length' "$file")
  if [[ "$toplevel_nodes_count" -gt 1 || "$commands_nodes_count" -ne 1 ]]; then
    echo "Error: '$file' should have 'commands' as the top-level node." >&2
    echo "It currently has $toplevel_nodes_count top-level nodes." >&2
    return 1
  fi

  local num_occurrances="$(yq '.commands | map(select(.alias == "'$alias'")) | length' "$file")"

  if [[ "$num_occurrances" -gt 1 ]]; then
    echo "Error: '$file' has multiple commands with the alias '$alias'." >&2
    echo "It should have only one." >&2
    echo "It currently has $num_occurrances occurances." >&2
    return 1
  fi

  if [[ "$num_occurrances" -eq 1 ]]; then
    local command=$(yq ".commands | map(select(.alias == \"$alias\"))[0] | .command" "$file")
    echo "$command"
  fi
}
