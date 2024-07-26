Include 'spec/setup_and_cleanup.sh'
Include 'src/lib/query/delete_entry_from_file.sh'

BeforeEach 'setup'
AfterEach 'cleanup'

Describe 'delete_entry_from_file'

  setup_target_file() {
    export TARGET_FILE="$(realpath .)/test.yml"
    echo "commands:" > "$TARGET_FILE"
    echo "  - alias: my alias" >> "$TARGET_FILE"
    echo "    command: my command" >> "$TARGET_FILE"
  }

  BeforeEach 'setup_target_file'

  Describe 'deletes entry from file'
    
    expected_output() {
      %= "commands: []"
    }

    It 'deletes an entry from the file'
      When call delete_entry_from_file 'my alias' "$TARGET_FILE"
      The status should be success
      The output should be blank 
      The contents of file "$TARGET_FILE" should eq "$(expected_output)"
    End
End

  Describe 'fails when arguments are missing'
    Parameters
      "alias" ""
      "" ""
    End

    Example "with args: $1 $2"
      When call delete_entry_from_file "$1" "$2"
      The status should be failure
      The stderr should eq "Usage Error: delete_entry_from_file <alias> <file>" 
    End
  End

  Describe 'fails when file does not exist'
    It 'fails when file does not exist'
      When call delete_entry_from_file 'my alias' 'nonexistent.yml'
      The status should be failure
      The stderr should eq "Error: Can not delete from file 'nonexistent.yml' as it does not exist."
    End
  End
End
