alias="${args[alias]}"

if [ -z "$alias" ]; then
  pick_and_execute_alias
else 
  execute_alias "$alias"
fi
