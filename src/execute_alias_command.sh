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

# Execute the command
eval "$command"
