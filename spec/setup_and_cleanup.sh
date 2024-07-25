setup() {
  TESTING_CWD=$(mktemp -d)
  cp pls $TESTING_CWD
  cp -r spec/samples $TESTING_CWD
  cd $TESTING_CWD
  export PLS_FILENAME=".pls"
  export PLS_ENABLE_CACHE_CHECK="false"
  export PLS_ALWAYS_CHECK="false"
  export PLS_ENABLE_FZF="true"
}

cleanup() {
  rm -rf $TESTING_CWD
}

setup_global_pls() {
  TEMP_DIR=$(mktemp -d)
  export PLS_GLOBAL="$TEMP_DIR/pls-tmp-global.yml"
  echo "commands:" > $PLS_GLOBAL
}

cleanup_global_pls() {
  rm -rf $TEMP_DIR
  unset PLS_GLOBAL
}


setup_temp_pls_dir() {
  export PLS_DIR="$(mktemp -d)"
}

cleanup_temp_pls_dir() {
  rm -rf "$PLS_DIR"
}
