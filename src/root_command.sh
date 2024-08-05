alias="${args[alias]}"
flag_add="${args[--add]}"
flag_command="${args[--command]}"
flag_target="${args[--target]}"
flag_delete="${args[--delete]}"
flag_list="${args[--list]}"
flag_verbose_list="${args[--List]}"

if [ -n "$flag_list" ]; then
  list_aliases 0
  exit
fi

if [ -n "$flag_verbose_list" ]; then
  list_aliases 1
  exit
fi

if [ -n "$flag_delete" ]; then
  delete_alias
  exit
fi

if [ -n "$flag_add" ]; then
  add_alias
  exit
fi

if [ -z "$alias" ]; then
  pick_and_execute_alias
else 
  execute_alias
fi
