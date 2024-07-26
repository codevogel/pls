
alias="${args[--alias]}"
destination="${args[--destination]}"

target_file="$(destination_to_path "$destination")"

if [[ -z "$target_file" ]]; then
  echo "Error: Can not delete from local file as it does exist here or in any parent." >&2
  exit 1
fi

delete_entry_from_file "$alias" "$target_file"
