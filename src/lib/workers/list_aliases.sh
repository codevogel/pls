list_aliases() {
  local flag_command="${args[--command]}"
  local flag_global="${args[--global]}"
  local flag_local="${args[--local]}"
  local flag_all="${args[--all]}"

  local local_file="$(get_closest_file "$PWD" "$PLS_FILENAME")"
  local global_file="$PLS_GLOBAL"

  print_aliases() {
    local file="$1"
    local should_print_command="$2"

    if [[ ! -f "$file" || "$(yq e '.commands | length' "$file")" -eq 0 ]]; then
      echo "No aliases found."
      return
    fi
    local alias_query='.commands | sort_by(.alias) | .[] | .alias'
    local command_query='.commands | sort_by(.alias) | .[] | .alias + "\n" + (.command | split("\n") | map(select(. != "") | "   " + .) | join("\n"))'
    yq e "$([[ "$should_print_command" ]] && echo "$command_query" || echo "$alias_query")" "$file"
  }

  if [[ "$flag_all" ]]; then
    echo "--- Global Aliases ---"
    print_aliases "$global_file" "$flag_command"
    echo "--- Local Aliases ---"
    print_aliases "$local_file" "$flag_command"
  elif [[ "$flag_global" ]]; then
    print_aliases "$global_file" "$flag_command"
  elif [[ "$flag_local" ]]; then
    print_aliases "$local_file" "$flag_command"
  else
    local temp_combined_file="$(mktemp)"
    echo "$(merge_pls_files "$global_file" "$local_file")" > "$temp_combined_file"
    print_aliases "$temp_combined_file" "$flag_command"
    rm "$temp_combined_file"
  fi
}
