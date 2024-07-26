destination_to_path() {
  local destination="$1"
  # If the destination is "g" or "global", return the global destination
  if [ "$destination" == "g" ] || [ "$destination" == "global" ]; then
    echo "$PLS_GLOBAL"
    return 0
  # If the destination is "l" or "local", return the closest file
  elif [ "$destination" == "l" ] || [ "$destination" == "local" ]; then
    local closest_file="$(get_closest_file "$PWD" "$PLS_FILENAME")"
    echo "$closest_file"
    return 0
  # Return destination in the current directory
  elif [ "$destination" == "h" ] || [ "$destination" == "here" ]; then
    echo "$(realpath $PWD/$PLS_FILENAME)"
    return 0
  fi
  echo "Error: Invalid argument. Must be one of [ g, global, l, local, h, here ]" >&2
  return 1
}
