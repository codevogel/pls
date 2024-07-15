alias="${args[alias]}"

command=$(query_command "$alias")

# If no command found, exit
if [ -z "$command" ]; then
  echo "Alias '$alias' was not found."
  exit 1
fi

# Execute the command
eval "$command"
