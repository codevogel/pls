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
