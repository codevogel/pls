setup() {
  TESTING_CWD=$(mktemp -d)
  cp pls $TESTING_CWD
  cp -r spec/samples $TESTING_CWD
  cd $TESTING_CWD
  export PLS_FILE_NAME="pls.yml"
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
