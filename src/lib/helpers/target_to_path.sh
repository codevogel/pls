target_to_path() {
  local target="$1"
  # If the target is "g" or "global", return the global destination
  if [ "$target" == "g" ] || [ "$target" == "global" ]; then
    echo "$PLS_GLOBAL"
    return 0
  # If the target is "l" or "local", return the closest file
  elif [ "$target" == "l" ] || [ "$target" == "local" ]; then
    local closest_file="$(get_closest_file "$PWD" "$PLS_FILENAME")"
    echo "$closest_file"
    return 0
  # Return target in the current directory
  elif [ "$target" == "h" ] || [ "$target" == "here" ]; then
    echo "$(realpath $PWD/$PLS_FILENAME)"
    return 0
  fi
  echo "Error: Invalid argument. Must be one of [ g, global, l, local, h, here ]" >&2
  return 1
}
