current_list="$(list_aliases)"

if [[ "$current_list" == "No aliases found." ]]; then
  echo "No aliases found."
  exit 0
fi

# if fzf is not installed, exit
if [[ "$PLS_ENABLE_FZF" == "true" && $(command -v fzf &> /dev/null) -eq 0 ]]; then
  picked_alias="$(echo "$current_list" | fzf)"
  # Remove ' *' from the end of the alias if it exists
else
  # print the list with
  # 1 | content
  echo "$current_list" | awk '{print NR " | " $0}'
  read -p "Enter alias (or n): " input
  if [[ "$input" =~ ^[0-9]+$ && "$input" -gt 0 ]]; then
    # Get alias from line number
    picked_alias="$(echo "$current_list" | sed -n "${input}p")"
  else
    # actually entered an alias instead of a number 
    picked_alias="$input"
  fi
fi
picked_alias="${picked_alias% \*}"
execute_alias "$picked_alias"
