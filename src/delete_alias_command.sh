
alias="${args[--alias]}"
destination="${args[--destination]}"

target_file="$(destination_to_path "$destination")"

delete_entry_from_file "$alias" "$target_file"
