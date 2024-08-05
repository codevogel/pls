# Create the PLS_DIR if it does not exist.
if [ ! -d $(dirname "$PLS_RC") ]; then
    mkdir -p "$(dirname "$PLS_RC")"
fi

if [ ! -f "$PLS_RC" ]; then
  echo '
# The name of the data file in which your aliases live.
# It is not recommended to change this value for consistency sake, but you can if you feel the need to do so.
PLS_FILENAME=.pls.yml

# The path to the global pls file (contains aliases that are available in all directories). 
# Default is determined by \$HOME/\$PLS_FILENAME.
PLS_GLOBAL=\$HOME/\$PLS_FILENAME

# The path to the directory used by pls for storing internal files, such as the command cache. 
# It is not recommended to set this to a directory in /tmp as this may break caching across reboots. 
# Default is determined by \$HOME/.local/share/pls.
PLS_DIR=\$HOME/.local/share/pls

# Enable or disable cache checking, which prevents you from unexpectedly running the wrong command. 
# Setting this to false turns off the verification warning that appears when you run an uncached command.
# This is not recommended, especially not on sensitive systems. 
# This setting is overridden by 'pls_always_cache_check'.
PLS_ENABLE_CACHE_CHECK=true

# This will always prompt you to confirm every command before running it, even if it is already cached. 
# Does not assure that the command is safe, but does give you a chance to review it. This setting overrides 'pls_enable_cache_check'.
PLS_ALWAYS_VERIFY=false

# Enable or disable the use of fzf for interactive selection. Note that this is only relevant for the 'pick_alias' command. If fzf is not installed, th
PLS_ENABLE_FZF=true
' > $PLS_RC
fi

source $PLS_RC

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
