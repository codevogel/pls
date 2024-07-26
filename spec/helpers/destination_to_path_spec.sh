Include 'spec/setup_and_cleanup.sh'
Include 'src/lib/helpers/destination_to_path.sh'
Include 'src/lib/helpers/get_closest_file.sh'

prepare_file_structure() {
  # Create a global file
  mkdir -p ./global
  export PLS_GLOBAL="$(realpath ./global/$PLS_FILENAME)"

  # Create a local file
  echo "commands: " > "./$PLS_FILENAME"

  # Create new subdirectory and change to it
  mkdir -p ./new_cwd
  cd ./new_cwd
}

BeforeEach 'setup' 'prepare_file_structure'
AfterEach 'cleanup'

Describe 'destination_to_path'
  Describe 'returns path to the global file for destination'
    Parameters:value 'g' 'global'
    Example "$1"
      When call destination_to_path "$1"
      The output should eq "$PLS_GLOBAL"
    End
  End
  
  Describe 'returns path to the local file for destination'
    Parameters:value 'l' 'local'
    Example "$1"
      When call destination_to_path "$1"
      The output should eq "$(realpath "..")/$PLS_FILENAME"
    End
  End

  Describe 'returns path to the here file (even if local file exists) for destination'
    Parameters:value 'h' 'here'
    Example "$1"
      When call destination_to_path "$1"
      The output should eq "$(realpath ".")/$PLS_FILENAME"
    End
  End

  Describe 'fails when destination is not g, global, l, local, h, here'
    Parameters:value 'invalid' 'foo'
    Example "$1"
      When call destination_to_path "$1"
      The status should be failure
      The stderr should eq "Error: Invalid argument. Must be one of [ g, global, l, local, h, here ]"
    End
  End
End
