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

# Describe 'query_command_in_file catches format error'
#   
#   top_level_error() {
#     echo "Format Error: 'samples/faulty/$1.yml' should have 'commands' as the (only) top-level node."
#     echo "It currently has $2 top-level nodes."
#     echo "$3 of which are 'commands'."
#   }
#
#   alias_not_unique_error() {
#     echo "Format Error: 'samples/faulty/[commands][foo,foo].yml' has multiple commands with the alias 'foo'."
#     echo "It should have only one."
#     echo "It currently has 2 occurances."
#   }
#
#   alias_has_no_command() {
#     echo "Format Error: 'samples/faulty/[commands][has no command].yml' has an alias 'has no command', but no command."
#     echo "Each alias should have exactly one command."
#   }
#
#   local empty_file='[]'
#   local invalid_top_level_key='[notcommands][]'
#   local duplicate_top_level_key='[commands,commands][]'
#   local valid_and_invalid_top_level_key='[commands,notcommands][]'
#   local duplicate_alias='[commands][foo,foo]'
#   local no_command='[commands][has no command]'
#   Parameters
#     "$empty_file" "foo" "$(top_level_error "$empty_file" 0 0)"
#     "$invalid_top_level_key" "foo" "$(top_level_error "$invalid_top_level_key" 1 0)"
#     "$duplicate_top_level_key" "foo" "$(top_level_error "$duplicate_top_level_key" 2 2)"
#     "$valid_and_invalid_top_level_key" "foo" "$(top_level_error "$valid_and_invalid_top_level_key" 2 1)"
#     "$duplicate_alias" "foo" "$(alias_not_unique_error)"
#     "$no_command" "has no command" "$(alias_has_no_command)"
#   End
#
#   It "getting '$2' from $1"
#     When call query_command_in_file "$2" "samples/faulty/$1.yml" 
#     The status should be failure
#     The stderr should eq "$3"
#     The stdout should be blank
#   End
# End
#
Describe 'query_command_in_file returns command'
  Parameters
    '[commands][foo]' 'foo' 'echo "foo"'
    '[commands][foo,bar]' 'foo' 'echo "foo"'
    '[commands][foo,bar]' 'bar' 'echo "bar"'
    '[commands][foo,biz baz]' 'foo' 'echo "foo"'
    '[commands][foo,biz baz]' 'biz baz' 'echo "biz"\necho "baz"'
  End

  It "getting '$2' from $1"
    When call query_command_in_file "$2" "samples/valid/$1.yml"
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
    When call query_command_in_file "$alias" "samples/valid/$1.yml"
    The status should be success
    The output should be blank
  End
End
