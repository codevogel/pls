Include 'spec/setup_and_cleanup.sh'
Include 'src/lib/helpers/get_closest_file.sh'
Include 'src/lib/query/query_command.sh'
Include 'src/lib/query/query_command_in_file.sh'

get_destination() {
  if [[ "$1" == '$PLS_GLOBAL' ]]; then
    echo "$PLS_GLOBAL"
  else
    echo "$1"
  fi
}

Describe 'query_command'

  BeforeEach 'setup' 'setup_global_pls'
  AfterEach 'cleanup' 'cleanup_global_pls'

  Describe 'validation'
    It 'fails when alias is missing'
      When call query_command '' 
      The status should be failure
      The stderr should eq 'Usage Error: Alias cannot be empty.'
    End
  End

  Describe 'returns command'
    Parameters
      '[commands][foo]' 'foo' 'echo "foo"'
      '[commands][foo,bar]' 'foo' 'echo "foo"'
      '[commands][foo,bar]' 'bar' 'echo "bar"'
      '[commands][foo,biz baz]' 'foo' 'echo "foo"'
      '[commands][foo,biz baz]' 'biz baz' 'echo "biz"\necho "baz"'
    End
    Describe 'in $PLS_GLOBAL'
      Example "$(printf '%s in %s' "$2" "$1")"
        cat "samples/valid/$1.yml" > "$PLS_GLOBAL"
        When call query_command "$2"
        The status should be success
        The output should eq "$(printf "$3")"
      End
    End

    Describe 'in ./$PLS_FILENAME'
      Example "$(printf '%s in %s' "$2" "$1")"
        cat "samples/valid/$1.yml" > "./$PLS_FILENAME"
        When call query_command "$2"
        The status should be success
        The output should eq "$(printf "$3")"
      End
    End
  End

  Describe 'returns blank when alias not found and'
    Parameters
      'not' 'not' 'neither'
      '$PLS_GLOBAL' 'not' 'global'
      'not' './$PLS_FILENAME' 'local'
      '$PLS_GLOBAL' './$PLS_FILENAME' 'global and local'
    End

    Example "$3 $PLS_FILENAME exists"
    cat "samples/valid/[commands][foo].yml" > $([[ "$1" == '$PLS_GLOBAL' ]] && echo "$PLS_GLOBAL" || echo "$1")
      cat "samples/valid/[commands][foo].yml" > "$2"
      When call query_command 'bar'
      The status should be success
      The output should be blank
    End
  End

  Describe 'reports origin of command if requested and'
    It 'command is in $PLS_GLOBAL'
      cat "samples/valid/[commands][foo].yml" > "$PLS_GLOBAL"
      When call query_command 'foo' 1
      The status should be success
      The output should eq "$(printf "echo \"foo\"\n$PLS_GLOBAL")"
    End

    It 'command is in ./$PLS_FILENAME'
      cat "samples/valid/[commands][foo].yml" > "./$PLS_FILENAME"
      When call query_command 'foo' 1
      The status should be success
      The output should eq "$(printf "echo \"foo\"\n$(realpath ./$PLS_FILENAME)")"
    End

    It 'command is in ../../$PLS_FILENAME'
      mkdir -p ./a/b/c
      cp ./pls ./a/b/c/pls
      cat "samples/valid/[commands][foo].yml" > "./a/$PLS_FILENAME"
      cd ./a/b/c
      When call query_command 'foo' 1
      The status should be success
      The output should eq "$(printf "echo \"foo\"\n$(realpath ../../$PLS_FILENAME)")"
    End
  End

  Describe 'prefers command in local $PLS_FILENAME over $PLS_GLOBAL'
    Example "getting 'say' from [commands][say]global in \$PLS_GLOBAL and [commands][say]local in ./$PLS_FILENAME"
      cat "samples/valid/[commands][say]global.yml" > "$PLS_GLOBAL"
      cat "samples/valid/[commands][say]local.yml" > "./$PLS_FILENAME"
      When call query_command 'say' 1
      The status should be success
      The output should eq "$(printf "echo local\n$(realpath ./$PLS_FILENAME)")"
    End  
  End
End


