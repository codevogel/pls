Include spec/setup_and_cleanup.sh

BeforeEach 'setup'
AfterEach 'cleanup'

Describe 'prints an alias'

  Describe 'prints with -p flag'
    Example 'prints command'
      cat "samples/valid/[commands][foo,biz baz].yml" > "./$TEST_PLS_FILENAME"
      When call ./pls -p "biz baz"
      The status should be success
      The output should eq "$(printf "echo \"biz\"\necho \"baz\"\n")"
    End
  End
End
