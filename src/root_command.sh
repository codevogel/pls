alias="${args[alias]}"
flag_add="${args[--add]}"
flag_command="${args[--command]}"
flag_target="${args[--target]}"

if [ -n "$flag_add" ]; then
  add_alias
  exit
fi

if [ -z "$alias" ]; then
  pick_and_execute_alias
else 
  execute_alias
fi
