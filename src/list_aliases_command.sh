flag_command="${args[--command]}"
flag_global="${args[--global]}"
flag_local="${args[--local]}"
flag_all="${args[--all]}"

local_file="$(get_closest_file "$PWD" "$PLS_FILE_NAME")"
global_file="$PLS_GLOBAL"

combine_files() {
  echo "commands:" > "$PLS_DIR/.combined.yml"
  if [ -f "$local_file" ] && [ -f "$global_file" ]; then
    # Append the two files, replacing commands: with a: and b: respectively
    local temp_file="$(mktemp)"
    sed "s/commands:/local:/" "$local_file" > "$temp_file"
    sed "s/commands:/global:/" "$global_file" >> "$temp_file"
    # Add a (*) to all aliases that are in the a: section
    yq e -i '.commands = ((.global | map(.alias = .alias + " *")) + .local) | del(.global,.local)' "$temp_file"
    yq eval '
      .commands |= (
      map(select(.alias | test(" \\*$") | not)) + 
      map(select(.alias | test(" \\*$"))) | 
      unique_by(.alias | sub(" \\*$"; "")) |
      sort_by(.alias)
    )' "$temp_file" > "$PLS_DIR/.combined.yml"
  elif [ -f "$local_file" ]; then
    cat "$local_file" > "$PLS_DIR/.combined.yml"
  elif [ -f "$global_file" ]; then
    if [[ "$(yq e '.commands | length' "$global_file")" -eq 0 ]]; then
      return
    fi
    yq eval '.commands | map(.alias = .alias + " *")' "$global_file" >> "$PLS_DIR/.combined.yml"
  fi
}

list_aliases() {
  local file="$1"
  local should_print_command="$2"

  if [[ ! -f "$file" || "$(yq e '.commands | length' "$file")" -eq 0 ]]; then
    echo "None found."
    return
  fi

  local alias_query='.commands | sort_by(.alias) | .[] | "-> " + .alias'
  local command_query='.commands | sort_by(.alias) | .[] | "-> " + .alias + "\n" + (.command | split("\n") | map(select(. != "") | "   " + .) | join("\n"))'
  yq e "$([[ "$should_print_command" ]] && echo "$command_query" || echo "$alias_query")" "$file"
}

if [[ "$flag_all" ]]; then
  echo "Global aliases:"
  list_aliases "$global_file" "$flag_command"
  echo "Local aliases:"
  list_aliases "$local_file" "$flag_command"
elif [[ "$flag_global" ]]; then
  list_aliases "$global_file" "$flag_command"
elif [[ "$flag_local" ]]; then
  list_aliases "$local_file" "$flag_command"
else
  combine_files
  list_aliases "$PLS_DIR/.combined.yml" "$flag_command"
fi
