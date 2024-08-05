alias="${args[alias]}"
flag_add="${args[--add]}"
flag_command="${args[--command]}"
flag_target="${args[--target]}"
flag_delete="${args[--delete]}"
flag_list="${args[--list]}"
flag_verbose_list="${args[--List]}"
flag_clear_cache="${args[--clear-cache]}"
flag_this_does_nothing="${args[--this-does-nothing]}"

if [ -n "$flag_this_does_nothing" ]; then
  exit
fi

if [ -n "$flag_clear_cache" ]; then
  rm "$PLS_DIR/.cache.yml"
  exit
fi

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
