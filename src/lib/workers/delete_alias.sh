delete_alias() {
  alias="${args[alias]}"
  target="${args[--target]}"

  target_file="$(target_to_path "$target")"

  if [[ -z "$target_file" ]]; then
    echo "Error: Can not delete from local file as it does exist here or in any parent." >&2
    exit 1
  fi

  delete_entry_from_file "$alias" "$target_file"
}
