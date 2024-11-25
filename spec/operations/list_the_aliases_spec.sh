Include 'spec/setup_and_cleanup.sh'

BeforeEach 'setup' 'setup_global_pls'
AfterEach 'cleanup' 'cleanup_global_pls'

Describe 'list_the_aliases'

  expected_output_both() {
    %= 'alpha-global *'
    %= 'bravo-local'
    %= 'charlie-global *'
    %= 'delta-local'
    %= 'duplicate'
    %= 'echo-global *'
    %= 'foxtrot-local'
    %= 'zulu-global *'
  }

  expected_output_local() {
    %= 'bravo-local'
    %= 'delta-local'
    %= 'duplicate'
    %= 'foxtrot-local'
  }

  expected_output_global() {
    %= 'alpha-global *'
    %= 'charlie-global *'
    %= 'duplicate *'
    %= 'echo-global *'
    %= 'zulu-global *'
  }

  Describe 'prints aliases from local and global files'
    
    Example 'when both exist'
      cat samples/valid/local_list.yml > "$TEST_PLS_FILENAME"
      cat samples/valid/global_list.yml > "$TEST_PLS_GLOBAL"

      When call ./pls -l 
      The status should be success
      The output should eq "$(expected_output_both)"
    End

    Example 'when only local exists'
      cat samples/valid/local_list.yml > "$TEST_PLS_FILENAME"

      When call ./pls -l
      The status should be success
      The output should eq "$(expected_output_local)" 
    End

    Example 'when only global exists'
      cat samples/valid/global_list.yml > "$TEST_PLS_GLOBAL"

      When call ./pls -l 
      The status should be success
      The output should eq "$(expected_output_global)" 
    End

    Example 'when neither exist'
      rm "$TEST_PLS_GLOBAL"
      When call ./pls -l
      The status should be success
      The output should eq 'No aliases found.'
    End
  End

  Describe 'prints aliases from only local file with -l flag'
    Example 'when global and local exist'
      cat samples/valid/local_list.yml > "$TEST_PLS_FILENAME"
      cat samples/valid/global_list.yml > "$TEST_PLS_GLOBAL"
      When call ./pls -ls l
      The status should be success
      The output should eq "$(expected_output_local)"
    End

    Example 'when local does not exist'
      cat samples/valid/global_list.yml > "$TEST_PLS_GLOBAL"
      When call ./pls -ls l
      The status should be success
      The output should eq 'No aliases found.'
    End
  End

  Describe 'prints aliases from only global file with -g flag'
    Example 'when global and local exist'
      expected_output_global() {
        %= 'alpha-global'
        %= 'charlie-global'
        %= 'duplicate'
        %= 'echo-global'
        %= 'zulu-global'
      }
      cat samples/valid/local_list.yml > "$TEST_PLS_FILENAME"
      cat samples/valid/global_list.yml > "$TEST_PLS_GLOBAL"
      When call ./pls -ls g
      The status should be success
      The output should eq "$(expected_output_global)"
    End

    Example 'when global does not exist'
      rm "$TEST_PLS_GLOBAL"
      cat samples/valid/local_list.yml > "$TEST_PLS_FILENAME"
      When call ./pls -ls g
      The status should be success
      The output should eq 'No aliases found.'
    End
  End

  Describe 'it prints aliases grouped by global and local with -a flag'
    expected_output_global() {
      %= 'alpha-global'
      %= 'charlie-global'
      %= 'duplicate'
      %= 'echo-global'
      %= 'zulu-global'
    }

    expected_output_local() {
      %= 'bravo-local'
      %= 'delta-local'
      %= 'duplicate'
      %= 'foxtrot-local'
    }

    expected_output_both() {
      %= '--- Global Aliases ---'
      expected_output_global
      %= '--- Local Aliases ---'
      expected_output_local
    }

    expected_output_only_local() {
      %= '--- Global Aliases ---'
      %= 'No aliases found.'
      %= '--- Local Aliases ---'
      expected_output_local
    }

    expected_output_only_global() {
      %= '--- Global Aliases ---'
      expected_output_global
      %= '--- Local Aliases ---'
      %= 'No aliases found.'
    }

    expected_output_neither() {
      %= '--- Global Aliases ---'
      %= 'No aliases found.'
      %= '--- Local Aliases ---'
      %= 'No aliases found.'
    }

    Example 'when global and local exist'
      cat samples/valid/local_list.yml > "$TEST_PLS_FILENAME"
      cat samples/valid/global_list.yml > "$TEST_PLS_GLOBAL"
      When call ./pls -ls a
      The status should be success
      The output should eq "$(expected_output_both)"
    End

    Example 'blank when neither exist'
      rm "$TEST_PLS_GLOBAL"
      When call ./pls -ls a
      The status should be success
      The output should eq "$(expected_output_neither)" 
    End

    Example 'when only local exists'
      cat samples/valid/local_list.yml > "$TEST_PLS_FILENAME"
      rm "$TEST_PLS_GLOBAL"
      When call ./pls -ls a
      The status should be success
      The output should eq "$(expected_output_only_local)"
    End

    Example 'when only global exists'
      cat samples/valid/global_list.yml > "$TEST_PLS_GLOBAL"
      When call ./pls -ls a
      The status should be success
      The output should eq "$(expected_output_only_global)"
    End
  End

  Describe 'prints commands with -c flag'

    expected_output_plain() {
      %= 'alpha-global *'
      %= '   echo "global alpha"'
      %= 'bravo-local'
      %= '   echo "local bravo"'
      %= 'charlie-global *'
      %= '   echo "global charlie"'
      %= 'delta-local'
      %= '   echo "local delta"'
      %= 'duplicate'
      %= '   echo "local duplicate"'
      %= 'echo-global *'
      %= '   echo "global echo!"'
      %= '   echo "...global echo!"'
      %= 'foxtrot-local'
      %= '   echo "local foxtrot"'
      %= 'zulu-global *'
      %= '   echo "global zulu"'
    }

    Example '-lp'
      cat samples/valid/local_list.yml > "$TEST_PLS_FILENAME"
      cat samples/valid/global_list.yml > "$TEST_PLS_GLOBAL"
      When call ./pls -lp 
      The status should be success
      The output should eq "$(expected_output_plain)"
    End

    expected_output_global() {
      %= 'alpha-global'
      %= '   echo "global alpha"'
      %= 'charlie-global'
      %= '   echo "global charlie"'
      %= 'duplicate'
      %= '   echo "global duplicate"'
      %= 'echo-global'
      %= '   echo "global echo!"'
      %= '   echo "...global echo!"'
      %= 'zulu-global'
      %= '   echo "global zulu"'
    }

    Example '-lps g'
      cat samples/valid/local_list.yml > "$TEST_PLS_FILENAME"
      cat samples/valid/global_list.yml > "$TEST_PLS_GLOBAL"
      When call ./pls -lps g
      The status should be success
      The output should eq "$(expected_output_global)"
    End

    expected_output_local() {
      %= 'bravo-local'
      %= '   echo "local bravo"'
      %= 'delta-local'
      %= '   echo "local delta"'
      %= 'duplicate'
      %= '   echo "local duplicate"'
      %= 'foxtrot-local'
      %= '   echo "local foxtrot"'
    }

    Example '-lps l'
      cat samples/valid/local_list.yml > "$TEST_PLS_FILENAME"
      cat samples/valid/global_list.yml > "$TEST_PLS_GLOBAL"
      When call ./pls -lps l 
      The status should be success
      The output should eq "$(expected_output_local)"
    End

    expected_output_both() {
      %= '--- Global Aliases ---'
      expected_output_global
      %= '--- Local Aliases ---'
      expected_output_local
    }

    Example '-lps a'
      cat samples/valid/local_list.yml > "$TEST_PLS_FILENAME"
      cat samples/valid/global_list.yml > "$TEST_PLS_GLOBAL"
      When call ./pls -lps a
      The status should be success
      The output should eq "$(expected_output_both)"
    End
  End
End


