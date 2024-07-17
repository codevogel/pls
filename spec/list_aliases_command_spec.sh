Include 'spec/setup_and_cleanup.sh'

BeforeEach 'setup' 'setup_global_pls'
AfterEach 'cleanup' 'cleanup_global_pls'

Describe 'list_aliases_command'
  Describe 'without flags'

    expected_output() {
      %= '-> bar (G):'
      %= '   echo "bar"'
      %= '-> biz baz:'
      %= '   echo "biz"' 
      %= '   echo "baz"'
      %= '-> foo:'
      %= '   echo "foo"'
    }

    Example 'lists all aliases'
      cat samples/valid/local_list.yml > ./pls.yml
      cat samples/valid/global_list.yml > "$PLS_GLOBAL"

      When call ./pls list_aliases
      The status should be success
      The output should eq "$(expected_output)"
    End
  End
End


