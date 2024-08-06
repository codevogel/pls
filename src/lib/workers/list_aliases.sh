list_aliases() {
  local verbose="${args[--print]}"
  local flag_scope="${args[--scope]}"

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

  if [ "$flag_scope" == "a" ] || [ "$flag_scope" == "all" ]; then
    echo "--- Global Aliases ---"
    print_aliases "$global_file" "$verbose"
    echo "--- Local Aliases ---"
    print_aliases "$local_file" "$verbose"
  elif [ "$flag_scope" == "g" ] || [ "$flag_scope" == "global" ]; then
    print_aliases "$global_file" "$verbose"
  elif [ "$flag_scope" == "l" ] || [ "$flag_scope" == "local" ]; then
    print_aliases "$local_file" "$verbose"
  elif [ "$flag_scope" == "h" ] || [ "$flag_scope" == "here" ]; then
    echo "Error: Invalid argument. Must be one of [ g, global, l, local, a, all ]" >&2
    exit 1
  else

    local temp_combined_file="$(mktemp)"
    echo "$(merge_pls_files "$global_file" "$local_file")" > "$temp_combined_file"
    print_aliases "$temp_combined_file" "$verbose"
    rm "$temp_combined_file"
  fi
}
