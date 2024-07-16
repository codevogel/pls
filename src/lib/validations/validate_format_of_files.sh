validate_format_of_file() {
  local file="$1"
  # # Check if 'commands' is the only top-level node
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
    echo "$commands_nodes_count of which are titled 'commands'." >&2
    return 1
  fi

  # Check if 'commands' has an equal number of 'alias' and 'command' keys
  local size_of_commands_array="$(yq '.commands | length' "$file")"
  local num_of_aliases="$(yq '.commands | map(select(has("alias"))) | length' "$file")"
  local num_of_command="$(yq '.commands | map(select(has("command"))) | length' "$file")"
  if [[ "$size_of_commands_array" -ne "$num_of_aliases" || "$size_of_commands_array" -ne "$num_of_command" ]]; then
    echo "Format Error: '$file' should have 'alias' and 'command' for each command." >&2
    echo "It currently has $size_of_commands_array commands." >&2
    echo "  $num_of_aliases of which have a key 'alias'." >&2
    echo "  $num_of_command of which have a key 'command'." >&2
    return 1
  fi

  if [[ "$size_of_commands_array" -eq 0 ]]; then
    return 0
  fi

  # Check if all 'alias' have no newlines
  local num_of_aliases_with_newlines="$(yq '.commands | map(select(.alias | contains("\n"))) | length' "$file")"
  if [[ "$num_of_aliases_with_newlines" -gt 0 ]]; then
    echo "Format Error: '$file' should not have newlines in aliases." >&2
    echo "It currently has $num_of_aliases_with_newlines aliases with newlines." >&2
    return 1
  fi
  
  # Check if all 'alias' are unique
  local aliases="$(yq '.commands[].alias' "$file")"
  local unique_aliases="$(echo "$aliases" | sort | uniq)"
  local num_of_unique_aliases="$(echo "$unique_aliases" | wc -l)"
  if [[ "$num_of_aliases" -ne "$num_of_unique_aliases" ]]; then
    echo "Format Error: '$file' should have unique aliases." >&2
    echo "It currently has $num_of_aliases aliases, but there are only $num_of_unique_aliases unique names." >&2
    echo "The following aliases are duplicated:" >&2
    diff --changed-group-format='%<' --unchanged-group-format='' <(echo "$aliases" | sort) <(echo "$unique_aliases" | sort) >&2  
    return 1
  fi

  # Check if all 'command' are not empty
  local num_of_empty_commands="$(yq '.commands | map(select(.command | test("^\\s*$"))) | length' "$file")"
  if [[ "$num_of_empty_commands" -gt 0 ]]; then
    echo "Format Error: '$file' should not have empty 'command' keys." >&2
    echo "It currently has $num_of_empty_commands empty 'command' keys." >&2
    return 1
  fi
}

validate_format_of_files() {
  local global_file="$PLS_GLOBAL"
  local local_file=$(get_closest_file "$PWD" "pls.yml")

  if [[ -f "$global_file" ]]; then
    validate_format_of_file "$global_file"
  fi

  if [[ -f "$local_file" ]]; then
    validate_format_of_file "$local_file"
  fi
}
