get_closest_file() {
    local from_dir="$1"
    local target_file="$2"
    local mock_root="$3"

    # Traverse up the directory tree until we find the target file
    # or reach the root directory.
    # If we reach the root directory, return an empty string.
    local current_dir="$(realpath $from_dir)"
    while [ "$current_dir" != "/" ]; do
        if [ -f "$current_dir/$target_file" ]; then
            # Echo the path of the file
            # (If the current directory is the mock root,
            #  return path as if it were the root directory)
            echo "$([[ "$current_dir" == "$mock_root" ]] && \
              echo "/$target_file" || echo "$current_dir/$target_file"
            )"
            return 0
        fi
        current_dir=$(dirname $(realpath "$current_dir"))
    done
    if [[ -f "/$target_file" ]]; then
        echo "/$target_file" && return 0
    fi
}
