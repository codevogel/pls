Include 'spec/setup_and_cleanup.sh'

BeforeEach 'setup' 'setup_global_pls'
AfterEach 'cleanup' 'cleanup_global_pls'

Describe 'pick_alias_command'

  Describe 'picks with fzf'

    Example "picks 'zulu-global *'"
      cat samples/valid/global_list.yml > "$PLS_GLOBAL"
      cat samples/valid/local_list.yml > ./pls.yml

      Mock fzf
        echo "zulu-global *"
      End

      When call ./pls p
      The status should be success
      The output should eq "global zulu"
    End

    Example "picks 'foxtrot-local'"
      cat samples/valid/global_list.yml > "$PLS_GLOBAL"
      cat samples/valid/local_list.yml > ./pls.yml

      Mock fzf
        echo "foxtrot-local"
      End

      When call ./pls p
      The status should be success
      The output should eq "local foxtrot"
    End
  End

  Describe 'picks when fzf is not installed'
    Example 'picks foxtrot-local by name'

      # Remove fzf from PATH
      export PLS_ENABLE_FZF=false 

      cat samples/valid/global_list.yml > "$PLS_GLOBAL"
      cat samples/valid/local_list.yml > ./pls.yml

      When call bash -c 'echo foxtrot-local | ./pls p' 

      The status should be success
      The output should include "local foxtrot"
    End

    Example 'picks foxtrot-local by number'

      # Remove fzf from PATH
      export PLS_ENABLE_FZF=false 

      cat samples/valid/global_list.yml > "$PLS_GLOBAL"
      cat samples/valid/local_list.yml > ./pls.yml

      When call bash -c 'echo 7 | ./pls p' 

      The status should be success
      The output should include "local foxtrot"
    End

  End
End