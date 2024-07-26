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
      local target_file="$(realpath ..)/$PLS_FILENAME"
      echo "commands:" > "$target_file"
      When call ./pls a -a "my alias" -c "my command" -d l
      The status should be success
      The contents of file "$target_file" should eq "$(expected_output)" 
    End

    Example "with destination 'global'"
      export PLS_GLOBAL="$(realpath ..)/global/$PLS_FILENAME"
      local target_file="$PLS_GLOBAL"
      echo "commands:" > "$target_file"
      When call ./pls a -a "my alias" -c "my command" -d g
      The status should be success
      The contents of file "$target_file" should eq "$(expected_output)" 
    End

    Example "with destination 'here' (even if local file exists)"
      local target_file="$(realpath .)/$PLS_FILENAME"
      echo "commands:" > "$target_file"
      echo "commands:" > "$(realpath ..)/$PLS_FILENAME"
      When call ./pls a -a "my alias" -c "my command" -d h
      The status should be success
      The contents of file "$target_file" should eq "$(expected_output)" 
    End
  End

  Describe 'creates file if it does not exist'
    Example "with destination 'local'"
      local target_file="$(realpath .)/$PLS_FILENAME"
      When call ./pls a -a "my alias" -c "my command" -d l
      The status should be success
      The contents of file "$target_file" should eq "$(expected_output)" 
    End

    Example "with destination 'global'"
      export PLS_GLOBAL="$(realpath ..)/global/$PLS_FILENAME"
      local target_file="$PLS_GLOBAL"
      When call ./pls a -a "my alias" -c "my command" -d g
      The status should be success
      The contents of file "$target_file" should eq "$(expected_output)" 
    End

    Example "with destination 'here' (even if local file exists)"
      local target_file="$(realpath .)/$PLS_FILENAME"
      echo "commands:" > "$(realpath ..)/$PLS_FILENAME"
      When call ./pls a -a "my alias" -c "my command" -d h
      The status should be success
      The contents of file "$target_file" should eq "$(expected_output)" 
    End
  End

  Describe 'fails when entry already exists'
    Example "when 'my alias' already exists"
      echo "$(expected_output)" > "./$PLS_FILENAME"
      When call ./pls a -a "my alias" -c "my command" -d l
      The status should be failure
      The stderr should eq "Error: Alias 'my alias' already exists in file '$(realpath .)/$PLS_FILENAME'. Use --force to overwrite."
    End
  End

  expected_output_after_edit() {
    %= "commands:"
    %= "  - alias: my alias"
    %= "    command: my new command"
  }

  Describe 'overwrites existing entry if force flag is set'
    Example "when 'my alias' already exists"
      echo "$(expected_output)" > "./$PLS_FILENAME"
      When call ./pls a -a "my alias" -c "my new command" -d l --force
      The status should be success
      The contents of file "$(realpath .)/$PLS_FILENAME" should eq "$(expected_output_after_edit)"
    End
  End
End
