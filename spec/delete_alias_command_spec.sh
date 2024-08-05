Include 'spec/setup_and_cleanup.sh'

BeforeEach 'setup'
AfterEach 'cleanup'

Describe 'delete_alias_command'

  entry_contents() {
    %= "commands:"
    %= "  - alias: my_alias"
    %= "    command: echo 'hello'"
  }

  Describe 'deletes entry for alias'
    Example 'with destination global'
      echo "PLS_GLOBAL=\"./global_$TEST_PLS_FILENAME\"" >> "$TEST_PLS_RC"
      local target_file="./global_$TEST_PLS_FILENAME"
      echo "$(entry_contents)" > "$target_file"
      When call ./pls -d my_alias -t g
      The contents of file "$target_file" should eq "commands: []"
    End

    Example 'with destination local'
      local target_file="./$TEST_PLS_FILENAME"
      echo "$(entry_contents)" > "$target_file"
      When call ./pls -d my_alias -t l
      The contents of file "$target_file" should eq "commands: []"
    End

    Example 'with destination here'
      local target_file="./$TEST_PLS_FILENAME"
      echo "$(entry_contents)" > "./$TEST_PLS_FILENAME"
      When call ./pls -d my_alias -t h
      The contents of file "$target_file" should eq "commands: []"
    End
  End

  Describe "fails if file does not exist"
    Example 'with destination global'
      echo "PLS_GLOBAL=\"./global_$TEST_PLS_FILENAME\"" >> "$TEST_PLS_RC"
      local target_file="./global_$TEST_PLS_FILENAME"
      When run ./pls -d my_alias -t g
      The status should be failure
      The stderr should eq "Error: Can not delete from file '$target_file' as it does not exist."
    End

    Example 'with destination local'
      local target_file="$(realpath .)/$TEST_PLS_FILENAME"
      When run ./pls -d my_alias -t l
      The status should be failure
      The stderr should eq "Error: Can not delete from local file as it does exist here or in any parent."
    End

    Example 'with destination here'
      local target_file="$(realpath .)/$TEST_PLS_FILENAME"
      When run ./pls -d my_alias -t h
      The status should be failure
      The stderr should eq "Error: Can not delete from file '$target_file' as it does not exist."
    End

    Example 'with destination here even if local exists'
      mkdir -p ./subdir
      echo "$(entry_contents)" > "./$TEST_PLS_FILENAME"
      mv ./pls ./subdir
      cd ./subdir
      local target_file="$(realpath .)/$TEST_PLS_FILENAME"
      When run ./pls -d my_alias -t h
      The status should be failure
      The stderr should eq "Error: Can not delete from file '$target_file' as it does not exist."
    End
  End
End
