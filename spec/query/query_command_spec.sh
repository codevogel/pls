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
      '$PLS_GLOBAL' '[commands][foo]' 'foo' 'echo "foo"'
      '$PLS_GLOBAL' '[commands][foo,bar]' 'foo' 'echo "foo"'
      '$PLS_GLOBAL' '[commands][foo,bar]' 'bar' 'echo "bar"'
      '$PLS_GLOBAL' '[commands][foo,biz baz]' 'foo' 'echo "foo"'
      '$PLS_GLOBAL' '[commands][foo,biz baz]' 'biz baz' 'echo "biz"\necho "baz"'
      './pls.yml' '[commands][foo]' 'foo' 'echo "foo"'
      './pls.yml' '[commands][foo,bar]' 'foo' 'echo "foo"'
      './pls.yml' '[commands][foo,bar]' 'bar' 'echo "bar"'
      './pls.yml' '[commands][foo,biz baz]' 'foo' 'echo "foo"'
      './pls.yml' '[commands][foo,biz baz]' 'biz baz' 'echo "biz"\necho "baz"'
    End

    It "getting '$3' from $2 in $1"
      local destination="$(get_destination "$1")"
      cat "samples/valid/$2.yml" > "$destination"
      When call query_command "$3"
      The status should be success
      The output should eq "$(printf "$4")"
    End
  End

  Describe 'returns blank when alias not found'

    Parameters
      '[commands][]'
      '[commands][foo]'
      '[commands][foo,bar]'
      '[commands][foo,biz baz]'
    End
    
    local alias='bee'
    It "getting '$alias' from $1"
      When call query_command "$alias" 
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

    It 'command is in ./pls.yml'
      cat "samples/valid/[commands][foo].yml" > "./pls.yml"
      When call query_command 'foo' 1
      The status should be success
      The output should eq "$(printf "echo \"foo\"\n$(realpath ./pls.yml)")"
    End

    It 'command is in ../../pls.yml'
      mkdir -p ./a/b/c
      cp ./pls ./a/b/c/pls
      cat "samples/valid/[commands][foo].yml" > "./a/pls.yml"
      cd ./a/b/c
      When call query_command 'foo' 1
      The status should be success
      The output should eq "$(printf "echo \"foo\"\n$(realpath ../../pls.yml)")"
    End
  End

  Describe 'prefers command in local pls.yml over $PLS_GLOBAL'
    Example "getting 'say' from [commands][say]global in \$PLS_GLOBAL and [commands][say]local in ./pls.yml"
      cat "samples/valid/[commands][say]global.yml" > "$PLS_GLOBAL"
      cat "samples/valid/[commands][say]local.yml" > "./pls.yml"
      When call query_command 'say' 1
      The status should be success
      The output should eq "$(printf "echo local\n$(realpath ./pls.yml)")"
    End  
  End
End


