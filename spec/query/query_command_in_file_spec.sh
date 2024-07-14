Include spec/test_helpers.sh
Include src/lib/query/query_command_in_file.sh

BeforeEach 'setup'
AfterEach 'cleanup'

Describe 'query_command_in_file'
  It 'returns the command for single valid entry'
    When call query_command_in_file 'echo_foo' 'samples/query/single_valid_entry.yml'
    The status should be success
    The output should eq 'echo "foo"'
  End
End
