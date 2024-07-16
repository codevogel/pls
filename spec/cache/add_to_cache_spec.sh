Include 'spec/setup_and_cleanup.sh'
Include 'src/lib/cache/add_to_cache.sh'

BeforeEach 'setup' 'setup_temp_pls_dir'
AfterEach 'cleanup' 'cleanup_temp_pls_dir'

Describe 'add_to_cache'
  Describe 'adds single line command to the cache'
    Parameters
      'origin foo' 'foo' 'echo "foo"'
      'origin bar' 'bar' 'echo "bar"'
    End

    It 'for alias '$2''
      When call add_to_cache "$1" "$2" "$3"
      The contents of file "$PLS_DIR/.cache.yml" should eq "$(printf "$1:\n  $2: $3")"
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

    It "for alias $2"
      When call add_to_cache "$1" "$2" 'echo "biz"\necho "baz"'
      The contents of file "$PLS_DIR/.cache.yml" should eq "$(printf "$1:\n  $2: |-\n$(correct_tab_format "$3")\n")" 
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
      echo "$original_content" > "$PLS_DIR/.cache.yml"
      When call add_to_cache "origin biz baz" "biz baz" "echo \"foo\"\necho \"bar\""
      The contents of file "$PLS_DIR/.cache.yml" should eq "$(printf "$(replaced_content)\n")"
    End
  End
End
