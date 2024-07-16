alias="${args[alias]}"

result=$(query_command "$alias" 1)

# command is all but last line
command=$(echo "$result" | head -n -1)
# found_in is the last line
found_in=$(echo "$result" | tail -n 1)

# If no command found, exit
if [ -z "$command" ]; then
  echo "Alias '$alias' was not found."
  exit 1
fi

prompt_to_continue() {
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

can_continue=false
# If safe mode is not disabled
if [[ ! "$PLS_DISABLE_SAFE_MODE" == "true" ]]; then
  # Check if command is missing from cache
  if ! exists_in_cache "$found_in" "$alias" "$command"; then
    echo "Alias '$alias' was found in '$found_in', but this command seems new."
    prompt_to_continue
    can_continue=true
  fi
fi

if [[ (! can_continue) || "$PLS_ENABLE_EXTRA_SAFE_MODE" == "true" ]]; then
  prompt_to_continue
fi

# Invoke the command and cache it
eval "$command"
add_to_cache "$found_in" "$alias" "$command"
