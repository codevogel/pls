merge_pls_files() {
    local global_file="$1"
    local local_file="$2"
    local combined_file="$(mktemp)"

    # Start with an empty, valid pls file
    echo "commands:" > "$combined_file"
    # If both files exist, merge them
    if [ -f "$local_file" ] && [ -f "$global_file" ]; then
      # Combine into a single yml with nodes 'local' and global' respectively
      local temp_file="$(mktemp)"
      sed "s/commands:/local:/" "$local_file" > "$temp_file"
      sed "s/commands:/global:/" "$global_file" >> "$temp_file"
      # Add a (*) to all aliases that are in the global: section
      yq e -i '.commands = ((.global | map(.alias = .alias + " *")) + .local) | del(.global,.local)' "$temp_file"
      # Combine the two sections into a single section
      # Conflicts are resolved by taking the alias that does not have a * at the end
      yq eval '
        .commands |= (
        map(select(.alias | test(" \\*$") | not)) + 
        map(select(.alias | test(" \\*$"))) | 
        unique_by(.alias | sub(" \\*$"; "")) |
        sort_by(.alias)
      )' "$temp_file" > "$combined_file"
    elif [ -f "$local_file" ]; then
      # If the file has no entries, we are already done
      if [[ "$(yq e '.commands | length' "$local_file")" -eq 0 ]]; then
        return
      fi
      yq eval '.commands | sort_by(.alias)' "$local_file" >> "$combined_file"
    elif [ -f "$global_file" ]; then
      # If the file has no entries, we are already done
      if [[ "$(yq e '.commands | length' "$global_file")" -eq 0 ]]; then
        return
      fi
      # Else use the global file and add a (*) to all aliases
      yq eval '.commands | map(.alias = .alias + " *") | sort_by(.alias)' "$global_file" >> "$combined_file"
    fi
    cat "$combined_file"
    rm "$combined_file"
}
