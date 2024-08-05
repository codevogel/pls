Include 'spec/setup_and_cleanup.sh'

BeforeEach 'setup'
AfterEach 'cleanup'

Describe 'add_alias_command'

  prepare_file_structure() {
    mkdir -p ./new_dir
    mkdir -p ./global
    mv ./pls ./new_dir
    cd ./new_dir
  }

  BeforeEach 'prepare_file_structure'

  expected_output() {
    %= "commands:"
    %= "  - alias: my alias"
    %= "    command: my command"
  }

  Describe 'adds entry to file'

    Example "with destination 'local'"
      local target_file="$(realpath ..)/$TEST_PLS_FILENAME"
      echo "commands:" > "$target_file"
      When call ./pls -a "my alias" -c "my command" -t l
      The status should be success
      The contents of file "$target_file" should eq "$(expected_output)" 
    End

    Example "with destination 'global'"
      echo "PLS_GLOBAL=\"$(realpath ..)/global/$TEST_PLS_FILENAME\"" >> "$TEST_PLS_RC"
      local target_file="$(realpath ..)/global/$TEST_PLS_FILENAME"
      echo "commands:" > "$target_file"
      When call ./pls -a "my alias" -c "my command" -t g
      The status should be success
      The contents of file "$target_file" should eq "$(expected_output)" 
    End

    Example "with destination 'here' (even if local file exists)"
      local target_file="$(realpath .)/$TEST_PLS_FILENAME"
      echo "commands:" > "$target_file"
      echo "commands:" > "$(realpath ..)/$TEST_PLS_FILENAME"
      When call ./pls -a "my alias" -c "my command" -t h
      The status should be success
      The contents of file "$target_file" should eq "$(expected_output)" 
    End
  End

  Describe 'creates file if it does not exist'
    Example "with destination 'local'"
      local target_file="$(realpath .)/$TEST_PLS_FILENAME"
      When call ./pls -a "my alias" -c "my command" -t l
      The status should be success
      The contents of file "$target_file" should eq "$(expected_output)" 
    End

    Example "with destination 'global'"
      echo "PLS_GLOBAL=\"$(realpath ..)/global/$TEST_PLS_FILENAME\"" >> "$TEST_PLS_RC"
      local target_file="$(realpath ..)/global/$TEST_PLS_FILENAME"
      When call ./pls -a "my alias" -c "my command" -t g
      The status should be success
      The contents of file "$target_file" should eq "$(expected_output)" 
    End

    Example "with destination 'here' (even if local file exists)"
      local target_file="$(realpath .)/$TEST_PLS_FILENAME"
      echo "commands:" > "$(realpath ..)/$TEST_PLS_FILENAME"
      When call ./pls -a "my alias" -c "my command" -t h
      The status should be success
      The contents of file "$target_file" should eq "$(expected_output)" 
    End
  End

  Describe 'fails when entry already exists'
    Example "when 'my alias' already exists"
      echo "$(expected_output)" > "./$TEST_PLS_FILENAME"
      When call ./pls -a "my alias" -c "my command" -t l
      The status should be failure
      The stderr should eq "Error: Alias 'my alias' already exists in file '$(realpath .)/$TEST_PLS_FILENAME'. Use --force to overwrite."
    End
  End

  expected_output_after_edit() {
    %= "commands:"
    %= "  - alias: my alias"
    %= "    command: my new command"
  }

  Describe 'overwrites existing entry if force flag is set'
    Example "when 'my alias' already exists"
      echo "$(expected_output)" > "./$TEST_PLS_FILENAME"
      When call ./pls -a "my alias" -c "my new command" -t l --force
      The status should be success
      The contents of file "$(realpath .)/$TEST_PLS_FILENAME" should eq "$(expected_output_after_edit)"
    End
  End
End
