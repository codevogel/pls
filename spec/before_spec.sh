Include spec/test_helpers.sh

BeforeEach 'setup'
AfterEach 'cleanup'

Describe 'before_spec.sh'
  It 'creates $PLS_DIR if it does not exist'
    export PLS_DIR="/tmp/temp_pls_dir"
    rm -rf "/tmp/temp_pls_dir"
    When run ./pls this_does_nothing
    The directory "$PLS_DIR" should be exist 
    rm -rf "/tmp/temp_pls_dir"
  End
End
