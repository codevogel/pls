Include 'spec/setup_and_cleanup.sh'

BeforeEach 'setup'
AfterEach 'cleanup'

Describe 'delete_alias_command'

  entry_contents() {
    %= "commands:"
    %= "  - alias: my alias"
    %= "    command: echo 'hello'"
  }

  Describe 'deletes entry for alias'
    Example 'with destination global'
      export PLS_GLOBAL="./global_$PLS_FILENAME"
      local target_file="$PLS_GLOBAL"
      echo "$(entry_contents)" > "$target_file"
      When call ./pls delete_alias -a "my alias" -d g
      The contents of file "$target_file" should eq "commands: []"
    End

    Example 'with destination local'
      local target_file="./$PLS_FILENAME"
      echo "$(entry_contents)" > "$target_file"
      When call ./pls delete_alias -a "my alias" -d l
      The contents of file "$target_file" should eq "commands: []"
    End

    Example 'with destination here'
      local target_file="./$PLS_FILENAME"
      echo "$(entry_contents)" > "./$PLS_FILENAME"
      When call ./pls delete_alias -a "my alias" -d h
      The contents of file "$target_file" should eq "commands: []"
    End
  End

  Describe "fails if file does not exist"
    Example 'with destination global'
      export PLS_GLOBAL="./global_$PLS_FILENAME"
      local target_file="$PLS_GLOBAL"
      When run ./pls delete_alias -a "my alias" -d g
      The status should be failure
      The stderr should eq "Error: Can not delete from file '$target_file' as it does not exist."
    End

    Example 'with destination local'
      local target_file="$(realpath .)/$PLS_FILENAME"
      When run ./pls delete_alias -a "my alias" -d l
      The status should be failure
      The stderr should eq "Error: Can not delete from file '$target_file' as it does not exist."
    End

    Example 'with destination here'
      local target_file="$(realpath .)/$PLS_FILENAME"
      When run ./pls delete_alias -a "my alias" -d h
      The status should be failure
      The stderr should eq "Error: Can not delete from file '$target_file' as it does not exist."
    End

    Example 'with destination here even if local exists'
      mkdir -p ./subdir
      echo "$(entry_contents)" > "./$PLS_FILENAME"
      mv ./pls ./subdir
      cd ./subdir
      local target_file="$(realpath .)/$PLS_FILENAME"
      When run ./pls delete_alias -a "my alias" -d h
      The status should be failure
      The stderr should eq "Error: Can not delete from file '$target_file' as it does not exist."
    End
  End
End
