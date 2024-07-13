alias="${args[alias]}"

global_file="$PLS_GLOBAL"
local_file="$(get_closest_file "$PWD" "$PLS_FILE_NAME")"

# Query to get command from yml
query='.commands[] | select(.alias == "'$alias'") | .command'

# Query the global and local files. 
# Order is important, as local file has higher precedence
if [ -f "$global_file" ]; then
  command="$(yq "$query" "$global_file")"
fi
if [ -f "$local_file" ]; then
  command="$(yq "$query" "$local_file")"
fi

# If no command found, exit
if [ -z "$command" ]; then
  echo "Alias '$alias' was not found in any of the files."
  exit 1
fi

# Execute the command
eval "$command"
