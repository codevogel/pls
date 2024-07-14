Include spec/test_helpers.sh
Include src/lib/query/query_command_in_file.sh

BeforeEach 'setup'
AfterEach 'cleanup'

Describe 'query_command_in_file validation'
  
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

Describe 'query_command_in_file catches format error'
  
  top_level_error() {
    echo "Format Error: '$1' should have 'commands' as the (only) top-level node."
    echo "It currently has $2 top-level nodes."
    echo "$3 of which are 'commands'."
  }

  Parameters
    '[]' 0 0
    '[notcommands][]' 1 0
    '[commands,commands][]' 2 2
    '[commands,notcommands][]' 2 1
  End

  It "getting 'foo' from $1"
    When call query_command_in_file 'foo' "samples/query/$1.yml" 
    The status should be failure
    The stderr should eq "$(top_level_error "samples/query/$1.yml" $2 $3)"
  End
End

Describe 'query_command_in_file returns command'
  Parameters
    '[commands][foo]' 'foo' 'echo "foo"'
    '[commands][foo,bar]' 'foo' 'echo "foo"'
    '[commands][foo,bar]' 'bar' 'echo "bar"'
    '[commands][foo,biz baz]' 'foo' 'echo "foo"'
    '[commands][foo,biz baz]' 'biz baz' 'echo "biz"\necho "baz"'
  End

  It "getting '$2' from $1"
    When call query_command_in_file "$2" "samples/query/$1.yml"
    The status should be success
    The output should eq "$(printf "$3")"
  End
End

Describe 'query_command_in_file returns blank when alias not found'

  Parameters
    '[commands][]'
    '[commands][foo]'
    '[commands][foo,bar]'
    '[commands][foo,biz baz]'
  End
  
  local alias='bee'
  It "getting '$alias' from $1"
    When call query_command_in_file "$alias" "samples/query/$1.yml"
    The status should be success
    The output should be blank
  End
End
