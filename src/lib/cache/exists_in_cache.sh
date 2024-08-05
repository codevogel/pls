exists_in_cache() {
  local origin="$1"
  local alias="$2"
  local command="$3"

  if [[ -z "$origin" || -z "$alias" || -z "$command" ]]; then
    echo "Usage Error: exists_in_cache <origin> <alias> <command>" >&2
    return 1
  fi

  if [ ! -d "$PLS_DIR" ]; then
    echo "Directory not found at $PLS_DIR" >&2
    return 1
  fi

  if [ ! -f "$PLS_DIR/.cache.yml" ]; then
    return 1
  fi

  local result=$(yq eval ".[\"$origin\"][\"$alias\"]" "$PLS_DIR/.cache.yml")
  if [[ "$result" == "null" ]]; then
    return 1
  fi

  if [[ ! "$(printf "$command")" == "$result" ]]; then
    return 1
  fi
}
