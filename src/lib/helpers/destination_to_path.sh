destination_to_path() {
  local destination="$1"
  # If the destination is "g" or "global", return the global destination
  if [ "$destination" == "g" ] || [ "$destination" == "global" ]; then
    echo "$PLS_GLOBAL"
    return 0
  # If the destination is "l" or "local", return the closest file
  elif [ "$destination" == "l" ] || [ "$destination" == "local" ]; then
    local closest_file="$(get_closest_file "$PWD" "$PLS_FILENAME")"
    # If a closest file is found, return it
    if [ -n "$closest_file" ]; then
      echo "$closest_file"
      return 0
    fi
  # If the destination is not "h" or "here", then it must be invalid
  elif [ "$destination" != "h" ] && [ "$destination" != "here" ]; then
    echo "Error: Invalid argument. Must be one of [ g, global, l, local, h, here ]" >&2
    return 1
  fi
  # Return destination in the current directory
  echo "$(realpath $PWD/$PLS_FILENAME)"
}
