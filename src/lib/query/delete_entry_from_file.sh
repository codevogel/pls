delete_entry_from_file() {
  local alias="$1"
  local file="$2"

  if [[ -z "$alias" || -z "$file" ]]; then
    echo "Usage Error: delete_entry_from_file <alias> <file>" >&2 
    return 1
  fi

  if [ ! -f "$file" ]; then
    echo "Error: Can not delete from file '$file' as it does not exist." >&2
    return 1
  fi

  yq e -i "del(.commands[] | select(.alias == \"$alias\"))" "$file"
}
