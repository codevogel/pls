exists_in_cache() {
  local origin="$1"
  local alias="$2"
  local command="$3"

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
