flag_command="${args[--command]}"
flag_global="${args[--global]}"
flag_local="${args[--local]}"
flag_all="${args[--all]}"

local_file="$(get_closest_file "$PWD" "$PLS_FILE_NAME")"
global_file="$PLS_GLOBAL"

list_aliases() {
  local file="$1"
  local should_print_command="$2"

  if [[ ! -f "$file" || "$(yq e '.commands | length' "$file")" -eq 0 ]]; then
    echo "None found."
    return
  fi
  local alias_query='.commands | sort_by(.alias) | .[] | .alias'
  local command_query='.commands | sort_by(.alias) | .[] | .alias + "\n" + (.command | split("\n") | map(select(. != "") | "   " + .) | join("\n"))'
  yq e "$([[ "$should_print_command" ]] && echo "$command_query" || echo "$alias_query")" "$file"
}

if [[ "$flag_all" ]]; then
  echo "--- Global Aliases ---"
  list_aliases "$global_file" "$flag_command"
  echo "--- Local Aliases ---"
  list_aliases "$local_file" "$flag_command"
elif [[ "$flag_global" ]]; then
  list_aliases "$global_file" "$flag_command"
elif [[ "$flag_local" ]]; then
  list_aliases "$local_file" "$flag_command"
else
  temp_combined_file="$(mktemp)"
  echo "$(merge_pls_files "$global_file" "$local_file")" > "$temp_combined_file"
  list_aliases "$temp_combined_file" "$flag_command"
  rm "$temp_combined_file"
fi
