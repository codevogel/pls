Include 'spec/setup_and_cleanup.sh'

BeforeEach 'setup'
AfterEach 'cleanup'

Describe 'clear_cache_command'
  It 'Removes the cache file'
    mkdir -p "$TEST_PLS_DIR"
    touch "$TEST_PLS_DIR/.cache.yml"
    When call ./pls clear_cache
    The status should be success
    The file "$TEST_PLS_DIR/.cache.yml" should not be exist
  End
End
