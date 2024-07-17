Include 'spec/setup_and_cleanup.sh'
Include 'src/lib/cache/exists_in_cache.sh'

BeforeEach 'setup' 'setup_temp_pls_dir'
AfterEach 'cleanup' 'cleanup_temp_pls_dir'

content_in_cache() {
  %= "foo origin:"
  %= "  foo: echo \"foo\""
  %= "  bar: echo \"bar\""
  %= "  baz: |-"
  %= "    echo \"baz\""
  %= "    echo \"BAZ!\""
  %= "bar origin:"
  %= "  bar: |-"
  %= "    echo \"bar\""
  %= "    echo \"BAR!\""
}

Describe 'exists_in_cache'
  Describe 'validation'
    Describe 'fails when argument is blank'
      Parameters
        'origin' '' 'foo' 'echo "foo"'
        'alias' 'origin' '' 'echo "foo"'
        'command' 'origin' 'foo' ''
      End

      Example "'$1'"
        When call exists_in_cache "$2" "$3" "$4"
        The status should be failure
        The stderr should eq "Usage Error: exists_in_cache <origin> <alias> <command>"
      End
    End 
  End

  Describe 'succeeds for cached origin|alias|command'
    Parameters
      "foo origin" "foo" 'echo "foo"'
      "foo origin" "bar" 'echo "bar"'
      "foo origin" "baz" 'echo "baz"\necho "BAZ!"'
      "bar origin" "bar" 'echo "bar"\necho "BAR!"'
    End

    Example "$(printf '%-12s | %-10s | %-15s \n' "$1" "$2" "$3")" 
      echo "$(content_in_cache)" > "$PLS_DIR/.cache.yml"
      When call exists_in_cache "$1" "$2" "$3" 
      The status should be success
      The output should be blank
    End
  End

  Describe 'fails for uncached origin|alias|command'
    Parameters
      "faultyorigin" "foo" 'echo "foo"'
      "foo origin" "faulty" 'echo "bar"'
      "foo origin" "baz" 'faulty command'
    End

    Example "$(printf '%-12s | %-10s | %-15s \n' "$1" "$2" "$3")" 
      echo "$(content_in_cache)" > "$PLS_DIR/.cache.yml"
      When call exists_in_cache "$1" "$2" "$3" 
      The status should be failure
      The output should be blank
    End
  End
End




