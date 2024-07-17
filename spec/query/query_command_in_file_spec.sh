Include spec/setup_and_cleanup.sh
Include src/lib/query/query_command_in_file.sh

BeforeEach 'setup'
AfterEach 'cleanup'

Describe 'query_command_in_file'
  Describe 'validation'
    
    It 'fails when alias is blank'
      When call query_command_in_file '' 'samples/query/single_valid_entry.yml'
      The status should be failure
      The stderr should eq 'Usage Error: Alias cannot be empty.'
    End

    It 'fails when file does not exist'
      When call query_command_in_file 'foo' 'non_existent_file'
      The status should be failure
      The stderr should eq "Usage Error: 'non_existent_file' does not exist."
    End
  End

  Describe 'returns alias from sample'
    Parameters
      '[commands][foo]' 'foo' 'echo "foo"'
      '[commands][foo,bar]' 'foo' 'echo "foo"'
      '[commands][foo,bar]' 'bar' 'echo "bar"'
      '[commands][foo,biz baz]' 'foo' 'echo "foo"'
      '[commands][foo,biz baz]' 'biz baz' 'echo "biz"\necho "baz"'
    End

    Example "'$2' from $1"
      When call query_command_in_file "$2" "samples/valid/$1.yml"
      The status should be success
      The output should eq "$(printf "$3")"
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
      When call query_command_in_file "$alias" "samples/valid/$1.yml"
      The status should be success
      The output should be blank
    End
  End
End
