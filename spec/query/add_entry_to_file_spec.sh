Include 'spec/setup_and_cleanup.sh'
Include 'src/lib/query/add_entry_to_file.sh'

BeforeEach 'setup'
AfterEach 'cleanup'

Describe 'add_entry_to_file'

  setup_target_file() {
    export TARGET_FILE="$(realpath .)/test.yml"
    echo "commands:" > "$TARGET_FILE"
  }

  BeforeEach 'setup_target_file'

  Describe 'adds entry to file'
    
    expected_output() {
      %= "commands:"
      %= "  - alias: my alias"
      %= "    command: my command"
    }

    It 'adds single-line entry to file'
      When call add_entry_to_file 'my alias' 'my command' "$TARGET_FILE"
      The status should be success
      The output should be blank 
      The contents of file "$TARGET_FILE" should eq "$(expected_output)"
    End

    expected_output_multiline() {
      %= "commands:"
      %= "  - alias: my alias"
      %= "    command: |-"
      %= "      my command"
      %= "      more of my command"
    }

    It 'adds multi-line entry to file'
      When call add_entry_to_file 'my alias' 'my command\nmore of my command' "$TARGET_FILE"
      The status should be success
      The output should be blank 
      The contents of file "$TARGET_FILE" should eq "$(expected_output_multiline)"
    End
  End

  Describe 'fails when arguments are missing'
    Parameters
      "alias" "command" ""
      "alias" "" ""
      "" "" ""
    End

    Example "with args: $1 $2 $3"
      When call add_entry_to_file "$1" "$2" "$3"
      The status should be failure
      The stderr should eq "Usage Error: add_entry_to_file <alias> <command> <file>"
    End
  End

  Describe 'fails when file does not exist'
    It 'fails when file does not exist'
      When call add_entry_to_file 'my alias' 'my command' 'nonexistent.yml'
      The status should be failure
      The stderr should eq "Error: Can not add to file 'nonexistent.yml' as it does not exist."
    End
  End
End
