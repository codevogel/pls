Include 'spec/setup_and_cleanup.sh'
Include 'src/lib/cache/add_to_cache.sh'

BeforeEach 'setup'
AfterEach 'cleanup'

Describe 'add_to_cache'

  Describe 'validation'
    Describe 'fails when argument is blank'
      Parameters
        'origin' '' 'foo' 'echo "foo"'
        'alias' 'origin' '' 'echo "foo"'
        'command' 'origin' 'foo' ''
      End

      Example "'$1'"
        When call add_to_cache "$2" "$3" "$4"
        The status should be failure
        The stderr should eq "Usage Error: add_to_cache <origin> <alias> <command>"
      End
    End

    Describe 'fails when $PLS_DIR does not point to valid directory'
      
      Parameters:value '""' '/tmp/foo/this-directory-does-not-exist'
      
      Example "$1"
        export PLS_DIR="/tmp/foo/this-directory-does-not-exist"
        When call add_to_cache "origin" "foo" "echo \"foo\""
        The status should be failure
        The stderr should eq "Env Error: PLS_DIR is not set or is not a directory"
      End
    End
  End

  Describe 'adds single line command to the cache'
    Parameters
      'origin foo' 'foo' 'echo "foo"'
      'origin bar' 'bar' 'echo "bar"'
    End

    It "for alias '$2'"
      export PLS_DIR="$TEST_PLS_DIR"
      mkdir -p "$TEST_PLS_DIR"
      When call add_to_cache "$1" "$2" "$3"
      The contents of file "$TEST_PLS_DIR/.cache.yml" should eq "$(printf "$1:\n  $2: $3")"
    End
  End

  Describe 'adds multiline command to the cache'
    Parameters
      'origin biz baz' 'biz baz' 'echo "biz"\necho "baz"'
    End

    correct_tab_format() {
      # Takes in a multiline string for printf and puts 4 spaces in front of each line
      echo "    $1" | sed 's/\\n/\n    /'
    }

    It "for alias '$2'"
      export PLS_DIR="$TEST_PLS_DIR" 
      mkdir -p "$TEST_PLS_DIR"
      When call add_to_cache "$1" "$2" 'echo "biz"\necho "baz"'
      The contents of file "$TEST_PLS_DIR/.cache.yml" should eq "$(printf "$1:\n  $2: |-\n$(correct_tab_format "$3")\n")" 
    End
  End

  Describe 'overwrites existing command in the cache'
    original_content() {
      %= "origin biz baz:"
      %= "  biz baz: |-"
      %= "    echo \"biz\""
      %= "    echo \"baz\""
    }

    replaced_content() {
      %= "origin biz baz:"
      %= "  biz baz: |-"
      %= "    echo \"foo\""
      %= "    echo \"bar\""
    }
  
    Example "for alias 'biz baz'"
      export PLS_DIR="$TEST_PLS_DIR" 
      mkdir -p "$TEST_PLS_DIR"
      echo "$original_content" > "$TEST_PLS_DIR/.cache.yml"
      When call add_to_cache "origin biz baz" "biz baz" "echo \"foo\"\necho \"bar\""
      The contents of file "$TEST_PLS_DIR/.cache.yml" should eq "$(printf "$(replaced_content)\n")"
    End
  End
End
