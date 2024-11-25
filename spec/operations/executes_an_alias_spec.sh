
Include spec/setup_and_cleanup.sh

BeforeEach 'setup' 'setup_global_pls'
AfterEach 'cleanup' 'cleanup_global_pls'

Describe 'executes_an_alias'

  Describe 'fails when alias is not found'
    Parameters
      'bee' '[commands][]'
      'bee' '[commands][foo]'
      'bee' '[commands][foo,bar]'
      'bee' '[commands][foo,biz baz]'
    End

    Example "'$1' not in $2"
      cat "samples/valid/$2.yml" > "./$TEST_PLS_FILENAME"
      When call ./pls "$1"
      The status should be failure
      The output should eq "Alias '$1' was not found."
    End
  End

  Describe 'executes command for alias'
    Describe 'found in $PLS_GLOBAL'

      Parameters
        'foo' '[commands][foo]' 'foo'
        'foo' '[commands][foo,bar]' 'foo'
        'bar' '[commands][foo,bar]' 'bar'
        'foo' '[commands][foo,biz baz]' 'foo'
        'biz baz' '[commands][foo,biz baz]' 'biz\nbaz'
      End
      
      It "'$1' in $2"
        cat "samples/valid/$2.yml" > "$TEST_PLS_GLOBAL"
        When call ./pls "$1"
        The status should be success
        The output should eq "$(printf "$3")"
      End
    End

    Describe 'found in ./$PLS_FILENAME'
      Parameters
        'foo' '[commands][foo]' 'foo'
        'foo' '[commands][foo,bar]' 'foo'
        'bar' '[commands][foo,bar]' 'bar'
        'foo' '[commands][foo,biz baz]' 'foo'
        'biz baz' '[commands][foo,biz baz]' 'biz\nbaz'
      End
      
      It "'$1' in $2"
        cat "samples/valid/$2.yml" > "./$TEST_PLS_FILENAME"
        When call ./pls "$1"
        The status should be success
        The output should eq "$(printf "$3")"
      End
    End

    Describe 'found in ./$PLS_FILENAME over alias found in $PLS_GLOBAL'

      It "'say' echos 'local' in [commands][say]global and [commands][say]local"
        cat "samples/valid/[commands][say]global.yml" > "$TEST_PLS_GLOBAL"
        cat "samples/valid/[commands][say]local.yml" > "./$TEST_PLS_FILENAME"
        When call ./pls say
        The status should be success
        The output should eq "local"
      End
    End

    Describe 'when PWD is ./a/b/c/ and pls file is in'
      prepare_directory_structure() {
        mkdir -p ./a/b/c
      }

      BeforeEach 'prepare_directory_structure'

      Parameters
        './a/b/c'
        './a/b'
        './a'
        '.' 
      End

      It "$1/$PLS_FILENAME"
        cat "samples/valid/[commands][foo].yml" > "$1/$TEST_PLS_FILENAME"
        mv ./pls "./a/b/c/pls"
        cd "./a/b/c"
        When call ./pls foo
        The status should be success
        The output should eq "foo"
      End
    End

    Describe 'when PWD is ./a/b/c/ and local pls file is in both'
      prepare_directory_structure() {
        mkdir -p ./a/b/c
      }

      BeforeEach 'prepare_directory_structure'

      Parameters
        './a/b/c' './a/b'
        './a/b' './a'
        './a' '.'
      End

      It "$1/$PLS_FILENAME (close) and $2/$PLS_FILENAME (far)"
        cat "samples/valid/[commands][say]close.yml" > "$1/$TEST_PLS_FILENAME"
        cat "samples/valid/[commands][say]far.yml" > "$2/$TEST_PLS_FILENAME"
        mv ./pls "./a/b/c/pls"
        cd "./a/b/c"
        When call ./pls say
        The status should be success
        The output should eq "close"
      End
    End
  End

  Describe 'executes parameterized command'
    Example 'both parameters'
      cat "samples/valid/[commands][params].yml" > "./$TEST_PLS_FILENAME"
      When call ./pls params 'foo' 'bar'
      The status should be success
      The output should eq "$(printf 'param 1: foo\nparam 2: bar')"
    End

    Example 'one parameter left out leaves it empty'
      cat "samples/valid/[commands][params].yml" > "./$TEST_PLS_FILENAME"
      When call ./pls params 'foo'
      The status should be success
      The output should eq "$(printf 'param 1: foo\nparam 2: ')"
    End

    Example 'no parameters leaves both empty'
      cat "samples/valid/[commands][params].yml" > "./$TEST_PLS_FILENAME"
      When call ./pls params
      The status should be success
      The output should eq "$(printf 'param 1: \nparam 2: ')"
    End
  End

  Describe 'cache validation'

    setup_modes() { 
      echo "PLS_ENABLE_CACHE_CHECK=\"$1\"" >> "$TEST_PLS_RC"
      echo "PLS_ALWAYS_VERIFY=\"$2\"" >> "$TEST_PLS_RC"
    }

    unset_modes() {
      unset PLS_ENABLE_CACHE_CHECK
      unset PLS_ALWAYS_VERIFY
    }

    Describe "when SAFE MODE is 'true' and EXTRA SAFE MODE is 'false'"

      BeforeEach 'setup_modes true false'
      AfterEach 'unset_modes'

      It 'prompts when not cached'
        cat "samples/valid/[commands][foo].yml" > "./$TEST_PLS_FILENAME"
        When call bash -c "echo 'y' | ./pls foo"
        The status should be success
        The output should include "this command seems new"
      End

      It 'is quiet when cached'
        cat "samples/valid/[commands][foo].yml" > "./$TEST_PLS_FILENAME"
        bash -c "echo 'y' | ./pls foo" > /dev/null
        When call bash -c "echo 'y' | ./pls foo"
        The status should be success
        The output should eq "foo"
      End
    End

    Describe "when SAFE MODE is 'true' and EXTRA SAFE MODE is 'true'"

      BeforeEach 'setup_modes true true'
      AfterEach 'unset_modes'

      It 'only prompts once when not cached'
        cat "samples/valid/[commands][foo].yml" > "./$TEST_PLS_FILENAME"
        When call bash -c "echo 'y' | ./pls foo"
        The status should be success
        The output should eq "$(printf "Alias 'foo' was found in '$(realpath ./$TEST_PLS_FILENAME)', but this command seems new.\n\necho \"foo\"\n\n\nfoo")"
      End

      It 'it prompts when already cached'
        cat "samples/valid/[commands][foo].yml" > "./$TEST_PLS_FILENAME"
        bash -c "echo 'y' | ./pls foo" > /dev/null
        When call bash -c "echo 'y' | ./pls foo"
        The status should be success
        The output should eq "$(printf "\necho \"foo\"\n\n\nfoo")"
      End
    End

    Describe "when SAFE MODE is 'false' and EXTRA SAFE MODE is 'false'"

      BeforeEach 'setup_modes false false'
      AfterEach 'unset_modes'

      It 'is quiet when not cached'
        cat "samples/valid/[commands][foo].yml" > "./$TEST_PLS_FILENAME"
        When call bash -c "echo 'y' | ./pls foo"
        The status should be success
        The output should eq "$(printf "foo")"
      End

      It 'it is quiet when already cached'
        cat "samples/valid/[commands][foo].yml" > "./$TEST_PLS_FILENAME"
        bash -c "echo 'y' | ./pls foo" > /dev/null
        When call bash -c "echo 'y' | ./pls foo"
        The status should be success
        The output should eq "$(printf "foo")"
      End
    End

    Describe "when SAFE MODE is 'false' and EXTRA SAFE MODE is 'true'"

      BeforeEach 'setup_modes false true'
      AfterEach 'unset_modes'

      It 'it prompts fully when not cached'
        cat "samples/valid/[commands][foo].yml" > "./$TEST_PLS_FILENAME"
        When call bash -c "echo 'y' | ./pls foo"
        The status should be success
        The output should eq "$(printf "Alias 'foo' was found in '$(realpath ./$TEST_PLS_FILENAME)', but this command seems new.\n\necho \"foo\"\n\n\nfoo")"
      End

      It 'it prompts partially when cached'
        cat "samples/valid/[commands][foo].yml" > "./$TEST_PLS_FILENAME"
        bash -c "echo 'y' | ./pls foo" > /dev/null
        When call bash -c "echo 'y' | ./pls foo"
        The status should be success
        The output should eq "$(printf "\necho \"foo\"\n\n\nfoo")"
      End
    End
  End
End
