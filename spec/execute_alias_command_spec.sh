Include spec/setup_and_cleanup.sh

BeforeEach 'setup' 'setup_global_pls'
AfterEach 'cleanup' 'cleanup_global_pls'

Describe 'execute_alias'

  Describe 'fails when alias is not found'
    Parameters
      'bee' '[commands][]'
      'bee' '[commands][foo]'
      'bee' '[commands][foo,bar]'
      'bee' '[commands][foo,biz baz]'
    End

    Example "'$1' in $2"
      cat "samples/valid/$2.yml" > "pls.yml"
      When call ./pls execute_alias "$1"
      The status should be failure
      The output should eq "Alias '$1' was not found."
    End
  End

  Describe 'executes command for alias'
    Describe 'found in $PLS_GLOBAL'

      BeforeEach 'setup_global_pls'
      AfterEach 'cleanup_global_pls'

      Parameters
        'foo' '[commands][foo]' 'foo'
        'foo' '[commands][foo,bar]' 'foo'
        'bar' '[commands][foo,bar]' 'bar'
        'foo' '[commands][foo,biz baz]' 'foo'
        'biz baz' '[commands][foo,biz baz]' 'biz\nbaz'
      End
      
      It "'$1' in $2"
        cat "samples/valid/$2.yml" > "$PLS_GLOBAL"
        When call ./pls execute_alias "$1"
        The status should be success
        The output should eq "$(printf "$3")"
      End
    End

    Describe 'found in ./pls.yml'
      Parameters
        'foo' '[commands][foo]' 'foo'
        'foo' '[commands][foo,bar]' 'foo'
        'bar' '[commands][foo,bar]' 'bar'
        'foo' '[commands][foo,biz baz]' 'foo'
        'biz baz' '[commands][foo,biz baz]' 'biz\nbaz'
      End
      
      It "'$1' in $2"
        cat "samples/valid/$2.yml" > "./pls.yml"
        When call ./pls execute_alias "$1"
        The status should be success
        The output should eq "$(printf "$3")"
      End
    End

    Describe 'found in ./pls.yml over alias found in $PLS_GLOBAL'

      BeforeEach 'setup_global_pls'
      AfterEach 'cleanup_global_pls'

      It "'say' echos 'local' in [commands][say]global and [commands][say]local"
        cat "samples/valid/[commands][say]global.yml" > "$PLS_GLOBAL"
        cat "samples/valid/[commands][say]local.yml" > "./pls.yml"
        When call ./pls execute_alias say
        The status should be success
        The output should eq "local"
      End
    End

    Describe 'when PWD is ./a/b/c/ and pls.yml is in'
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

      It "$1/pls.yml"
        cat "samples/valid/[commands][foo].yml" > "$1/pls.yml"
        mv ./pls "./a/b/c/pls"
        cd "./a/b/c"
        When call ./pls execute_alias foo
        The status should be success
        The output should eq "foo"
      End
    End

    Describe 'when PWD is ./a/b/c/ and local pls.yml is in both'
      prepare_directory_structure() {
        mkdir -p ./a/b/c
      }

      BeforeEach 'prepare_directory_structure'

      Parameters
        './a/b/c' './a/b'
        './a/b' './a'
        './a' '.'
      End

      It "$1/pls.yml (close) and $2/pls.yml (far)"
        cat "samples/valid/[commands][say]close.yml" > "$1/pls.yml"
        cat "samples/valid/[commands][say]far.yml" > "$2/pls.yml"
        mv ./pls "./a/b/c/pls"
        cd "./a/b/c"
        When call ./pls execute_alias say
        The status should be success
        The output should eq "close"
      End
    End
  End
End
