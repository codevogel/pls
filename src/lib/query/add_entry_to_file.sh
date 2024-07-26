add_entry_to_file() {
  local alias="$1"
  local command="$2"
  local target_file="$3"

  if [[ -z "$alias" || -z "$command" || -z "$target_file" ]]; then
    echo "Usage Error: add_entry_to_file <alias> <command> <file>" >&2
    return 1
  fi

  if [ ! -f "$target_file" ]; then
    echo "Error: Can not add to file '$target_file' as it does not exist." >&2
    return 1
  fi

  yq e -i ".commands += [{\"alias\": \"$alias\", \"command\": \"$command\"}]" "$target_file"
}
