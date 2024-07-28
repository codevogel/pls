# Create the PLS_DIR if it does not exist.
mkdir -p $PLS_DIR
if [ ! -d $PLS_DIR ]; then
    echo "Failed to create directory $PLS_DIR" 
    exit 1
fi

# Ensure yq is installed and is at least version v4.44.2
min_version="v4.44.2"
actual_version="$(yq --version | awk '{print $NF}')"
if ! check_version "$name" "$actual_version" "$min_version"; then
  echo "Error: Your yq version $actual_version is older than $min_version . Please upgrade it to use pls" <&2
  exit 1
fi

# Validate syntax of pls files
validate_format_of_files
