Include 'spec/setup_and_cleanup.sh'

BeforeEach 'setup' 'setup_global_pls'
AfterEach 'cleanup' 'cleanup_global_pls'

Describe 'picks_an_alias'

  Describe 'picks with fzf'

    Example "picks 'zulu-global *'"
      cat samples/valid/global_list.yml > "$TEST_PLS_GLOBAL"
      cat samples/valid/local_list.yml > ./$TEST_PLS_FILENAME

      Mock fzf
        echo "zulu-global *"
      End

      When call ./pls
      The status should be success
      The output should eq "global zulu"
    End

    Example "picks 'foxtrot-local'"
      cat samples/valid/global_list.yml > "$TEST_PLS_GLOBAL"
      cat samples/valid/local_list.yml > ./$TEST_PLS_FILENAME

      Mock fzf
        echo "foxtrot-local"
      End

      When call ./pls
      The status should be success
      The output should eq "local foxtrot"
    End
  End

  Describe 'picks when fzf is not installed'
    Example 'picks foxtrot-local by name'

      # Remove fzf from PATH
      echo "PLS_ENABLE_FZF=false" >> "$TEST_PLS_RC" 

      cat samples/valid/global_list.yml > "$TEST_PLS_GLOBAL"
      cat samples/valid/local_list.yml > ./$TEST_PLS_FILENAME

      When call bash -c 'echo foxtrot-local | ./pls' 

      The status should be success
      The output should include "local foxtrot"
    End

    Example 'picks foxtrot-local by number'

      # Remove fzf from PATH
      echo "PLS_ENABLE_FZF=false" >> "$TEST_PLS_RC" 

      cat samples/valid/global_list.yml > "$TEST_PLS_GLOBAL"
      cat samples/valid/local_list.yml > ./$TEST_PLS_FILENAME

      When call bash -c 'echo 7 | ./pls' 

      The status should be success
      The output should include "local foxtrot"
    End

  End
End
