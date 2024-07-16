add_to_cache() {
  local origin="$1" # Is a file path, so can contain special characters such as whitespace
  local alias="$2" # Is a string which cannot be multiline
  local command="$3" # Is a string which can be multiline
  local cache_file="$PLS_DIR/.cache.yml"

  # Check if all arguments are provided
  if [ -z "$origin" ] || [ -z "$alias" ] || [ -z "$command" ]; then
    echo "Usage Error: add_to_cache <origin> <alias> <command>"
    return 1
  fi

  # Create cache if it does not exist
  if [[ ! -d "$PLS_DIR" ]]; then
    echo "Env Error: PLS_DIR is not set or is not a directory"
    return 1
  fi
  [[ ! -f "$cache_file" ]] && touch "$cache_file"

  local escaped_command=$(printf '%s' "$command" | sed 's/"/\\"/g')

  yq -i eval ".[\"$origin\"][\"$alias\"] = \"$escaped_command\"" "$cache_file"
}
