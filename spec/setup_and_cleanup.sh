setup() {
  TESTING_CWD=$(mktemp -d)
  cp pls $TESTING_CWD
  cp -r spec/samples $TESTING_CWD
  cd $TESTING_CWD
  export TEST_PLS_RC="$TESTING_CWD/.plsrc"
  export TEST_PLS_FILENAME=".pls.test.yml"
  export TEST_PLS_ENABLE_CACHE_CHECK="false"
  export TEST_PLS_ALWAYS_CHECK="false"
  export TEST_PLS_ENABLE_FZF="true"
  export TEST_PLS_DIR="$TESTING_CWD/test_pls_dir"
  echo "PLS_FILENAME=\"$TEST_PLS_FILENAME\"" > $TEST_PLS_RC
  echo "PLS_ENABLE_CACHE_CHECK=\"$TEST_PLS_ENABLE_CACHE_CHECK\"" >> $TEST_PLS_RC
  echo "PLS_ALWAYS_CHECK=\"$TEST_PLS_ALWAYS_CHECK\"" >> $TEST_PLS_RC
  echo "PLS_ENABLE_FZF=\"$TEST_PLS_ENABLE_FZF\"" >> $TEST_PLS_RC
  echo "PLS_DIR=\"$TEST_PLS_DIR\"" >> $TEST_PLS_RC
  export PLS_RC="$TEST_PLS_RC"
}

cleanup() {
  rm -rf $TESTING_CWD
  rm -rf "$TEST_PLS_DIR"
}

setup_global_pls() {
  TEMP_DIR=$(mktemp -d)
  export TEST_PLS_GLOBAL="$TEMP_DIR/.plsglobal"
  echo "PLS_GLOBAL=\"$TEST_PLS_GLOBAL\"" >> $TEST_PLS_RC
  echo "commands:" > $TEST_PLS_GLOBAL
}

export_global_pls() {
  export PLS_GLOBAL="$TEST_PLS_GLOBAL"
}

export_pls_filename() {
  export PLS_FILENAME="$TEST_PLS_FILENAME"
}

cleanup_global_pls() {
  rm -rf $TEMP_DIR
  unset PLS_GLOBAL
}
