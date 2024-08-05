Include spec/setup_and_cleanup.sh

BeforeEach 'setup'
AfterEach 'cleanup'

Describe 'before.sh'

  It 'creates $PLS_RC if it does not exist and directory exists'
    temp_pls_rc="$TESTING_CWD/.config/pls/temp_pls_rc"
    export PLS_RC="$temp_pls_rc"
    mkdir -p "$TESTING_CWD/.config/pls" 
    rm -f "$temp_pls_rc"
    When run ./pls this_does_nothing
    The directory "$(dirname "$temp_pls_rc")" should be exist
    The file "$temp_pls_rc" should be exist
  End

  It 'creates $PLS_RC if it does not exist and directory exists'
    temp_pls_rc="$TESTING_CWD/.config/pls/temp_pls_rc"
    export PLS_RC="$temp_pls_rc"
    rm -f "$temp_pls_rc"
    When run ./pls this_does_nothing
    The directory "$(dirname "$temp_pls_rc")" should be exist
    The file "$temp_pls_rc" should be exist
  End

  It 'creates $PLS_DIR if it does not exist'

    PLS_DIR="$TESTING_CWD/test_pls_dir"
    echo "PLS_DIR=\"$PLS_DIR\"" >> "$TEST_PLS_RC"
    rm -rf "$PLS_DIR"
    When run ./pls this_does_nothing
    The directory "$PLS_DIR" should be exist 
  End
End
