execute_alias() {
  local alias="${1}"

  local result=$(query_command "$alias" 1)

  # command is all but last line
  local command=$(echo "$result" | head -n -1)
  # found_in is the last line
  local found_in=$(echo "$result" | tail -n 1)

  # If no command found, exit
  if [ -z "$command" ]; then
    echo "Alias '$alias' was not found."
    exit 1
  fi

  prompt_to_continue() {
      if [[ "$is_cached" == "true" ]]; then
        echo "This command is already cached."
      fi
      echo 
      echo "$command"
      echo
      read -p "Are you sure you want to invoke the above command? [y/n] " -n 1 -r
      echo 
      if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Command was not invoked."
        echo "Exiting..."
        exit 1
      fi
  }

  if [ "${args[--print]}" ]; then
    echo "$command"
    return
  fi

  if exists_in_cache "$found_in" "$alias" "$command"; then
      if [[ "$PLS_ALWAYS_VERIFY" == "true" ]]; then
        prompt_to_continue
      fi 
  elif [[ "$PLS_ENABLE_CACHE_CHECK" == "true" || "$PLS_ALWAYS_VERIFY" == "true" ]]; then
      echo "Alias '$alias' was found in '$found_in', but this command seems new."
      prompt_to_continue
  fi

  command_args="${args[command_args]}"
  # Create a temporary function
  exec_alias_command() {

      eval "$command"
  }

  # Execute the function with the arguments
  exec_alias_command $command_args

  add_to_cache "$found_in" "$alias" "$command"
}
