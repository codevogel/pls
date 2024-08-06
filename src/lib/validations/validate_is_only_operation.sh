validate_is_only_operation() {
  flag_add="${args[--add]}"
  flag_delete="${args[--delete]}"
  flag_list="${args[--list]}"
  is_only_operation "$flag_add" "$flag_delete" "$flag_list" 
}

is_only_operation() {
  flag_add="$1"
  flag_delete="$2"
  flag_list="$3"

  num_operations=0
  if [ -n "$flag_add" ]; then
    num_operations=$((num_operations + 1))
  fi
  if [ -n "$flag_delete" ]; then
    num_operations=$((num_operations + 1))
  fi
  if [ -n "$flag_list" ]; then
    num_operations=$((num_operations + 1))
  fi

  if [ "$num_operations" -eq 0 ]; then
    echo "No operation flag supplied."
    return
  fi

  if [ "$num_operations" -ne 1 ]; then
    echo "Can only use one operation flag (--add, --delete, --list) at a time."
  fi
}
