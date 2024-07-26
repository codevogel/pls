validate_is_destination() {
  local arg="$1"
  if [ "$arg" != "g" ] && [ "$arg" != "l" ] && [ "$arg" != "h" ] && [ "$arg" != "global" ] && [ "$arg" != "local" ] && [ "$arg" != "here" ]; then
    echo "Error: Invalid argument. Must be one of [ g, global, l, local, h, here ]"
    return 1
  fi
  
}
