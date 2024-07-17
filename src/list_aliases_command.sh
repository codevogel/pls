flag_command="${args[--command]}"
flag_global="${args[--global]}"
flag_local="${args[--local]}"
flag_all="${args[--all]}"

local_file="$(get_closest_file "$PWD" "$PLS_FILE_NAME")"
global_file="$PLS_GLOBAL"


combine_files() {
  if [ -f "$local_file" ] && [ -f "$global_file" ]; then
    # Append the two files, replacing commands: with a: and b: respectively
    local temp_file="$(mktemp)"
    cat "$global_file" | sed "s/commands:/a:/" | sed -E 's/(alias: .*)$/\1/' > "$temp_file"
    cat "$local_file" | sed "s/commands:/b:/" >> "$temp_file"

    # Create a combined file which will hold the merged commands
    local combined_file="$PLS_DIR/.combined.yml"
    echo "commands:" > "$combined_file"

    # Merge the a and b nodes from the temp file into the combined file
    yq '.a *d .b' "$temp_file" >> "$combined_file"
    # Cleanup
    rm "$temp_file"
  elif [-f "$local_file"]; then
    cat "$local_file" > "$PLS_DIR/.combined.yml"
  else
    cat "$global_file" > "$PLS_DIR/.combined.yml"
  fi
}

list_aliases() {
  local file="$1"
  local context="$2" # if 'hidden' print no context
  local should_print_command="$3"
  if [[ "$context" != "hidden" ]]; then
    echo "$context"
  fi

  local alias_query='.commands[] | "-> " + .alias'
  local command_query='.commands[] | "-> " + .alias + "\n" + (.command | split("\n") | map(select(. != "") | "   " + .) | join("\n"))'
  yq e "$([[ "$should_print_command" ]] && echo "$command_query" || echo "$alias_query")" "$file"
}

if [[ "$flag_all" ]]; then
  list_aliases "$global_file" "Global context ($global_file):" "$flag_command"
  list_aliases "$local_file" "Local context ($local_file):" "$flag_command"
elif [[ "$flag_global" ]]; then
  list_aliases "$global_file" "Global context ($global_file):" "$flag_command"
  echo "Note that these may be overridden by local aliases."
elif [[ "$flag_local" ]]; then
  list_aliases "$local_file" "Local context ($local_file):" "$flag_command"
else
  combine_files
  list_aliases "$PLS_DIR/.combined.yml" "hidden" "$flag_command"
fi
