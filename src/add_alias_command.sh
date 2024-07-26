alias="${args[--alias]}"
command="${args[--command]}"
destination="${args[--destination]}"

target_file="$(destination_to_path "$destination")"

# Create file if it doesn't exist
if [ ! -f "$target_file" ]; then
  echo "commands:" > "$target_file"
fi

# If alias already exists in file, --force flag must be used
num_occurances_of_alias="$(yq e ".commands | map(select(.alias == \"$alias\")) | length" "$target_file")"
if [[ $num_occurances_of_alias -eq 1 ]]; then
  if [ ! "${args[--force]}" ]; then
    echo "Error: Alias '$alias' already exists in file '$target_file'. Use --force to overwrite." >&2
    exit 1
  fi
  # Remove the old alias
  delete_entry_from_file "$alias" "$target_file"
fi

# Add alias:command entry to file
add_entry_to_file "$alias" "$command" "$target_file"
