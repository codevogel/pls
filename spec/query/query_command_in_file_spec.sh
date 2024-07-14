Include spec/setup_and_cleanup.sh
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
    echo "Format Error: 'samples/query/$1.yml' should have 'commands' as the (only) top-level node."
    echo "It currently has $2 top-level nodes."
    echo "$3 of which are 'commands'."
  }

  alias_not_unique_error() {
    echo "Format Error: 'samples/query/[commands][foo,foo].yml' has multiple commands with the alias 'foo'."
    echo "It should have only one."
    echo "It currently has 2 occurances."
  }

  alias_has_no_command() {
    echo "Format Error: 'samples/query/[commands][has no command].yml' has an alias 'has no command', but no command."
    echo "Each alias should have exactly one command."
  }

  Parameters
    '[]' "foo" "$(top_level_error "[]" 0 0)"
    '[notcommands][]' "foo" "$(top_level_error "[notcommands][]" 1 0)"
    '[commands,commands][]' "foo" "$(top_level_error "[commands,commands][]" 2 2)"
    '[commands,notcommands][]' "foo" "$(top_level_error "[commands,notcommands][]" 2 1)"
    '[commands][foo,foo]' "foo" "$(alias_not_unique_error)"
    '[commands][has no command]' "has no command" "$(alias_has_no_command)" 
  End

  It "getting '$2' from $1"
    When call query_command_in_file "$2" "samples/query/$1.yml" 
    The status should be failure
    The stderr should eq "$3"
    The stdout should be blank
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
