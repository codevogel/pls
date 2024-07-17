setup() {
  TESTING_CWD=$(mktemp -d)
  cp pls $TESTING_CWD
  cp -r spec/samples $TESTING_CWD
  cd $TESTING_CWD
  export PLS_FILE_NAME="pls.yml"
  export PLS_ENABLE_SAFE_MODE="false"
  export PLS_ENABLE_EXTRA_SAFE_MODE="false"
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
