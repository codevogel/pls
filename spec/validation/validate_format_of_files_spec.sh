Include 'spec/setup_and_cleanup.sh'

get_destination() {
  if [[ "$1" == '$PLS_GLOBAL' ]]; then
    echo "$PLS_GLOBAL"
  else
    echo "$1"
  fi
}

Describe 'validate_format_of_files catches format error'

  BeforeEach 'setup' 'setup_global_pls'
  AfterEach 'cleanup' 'cleanup_global_pls'

  Describe "of type 'top level error'"
    local global="$PLS_GLOBAL"

    Parameters
      # $1: destination file
      # $2: sample file
      # $3: number of top level nodes
      # $4: number of 'commands' nodes
      '$PLS_GLOBAL' '[]' 0 0
      '$PLS_GLOBAL' '[notcommands][]' 1 0
      '$PLS_GLOBAL' '[commands,commands][]' 2 2
      '$PLS_GLOBAL' '[commands,notcommands][]' 2 1
      './pls.yml' '[]' 0 0
      './pls.yml' '[notcommands][]' 1 0
      './pls.yml' '[commands,commands][]' 2 2
      './pls.yml' '[commands,notcommands][]' 2 1
    End

    It "in $1 when sample is $2"
      top_level_error() {
        local file="$1"
        local toplevel_nodes_count="$2"
        local commands_nodes_count="$3"
        %= "Format Error: '$file' should have 'commands' as the (only) top-level node."
        %= "It currently has $toplevel_nodes_count top-level nodes."
        %= "$commands_nodes_count of which are titled 'commands'."
      }
      local destination="$(get_destination "$1")"
      cat "samples/faulty/$2.yml" > "$destination"
      When call ./pls this_does_nothing
      The status should be failure
      The stderr should eq "$(top_level_error "$(realpath $destination)" "$3" "$4")"
    End
  End 

  Describe "of type 'missing command/alias'"
    Parameters
      # $1: destination file
      # $2: sample file
      # $3: size of commands
      # $4: number of aliases
      # $5: number of command
      '$PLS_GLOBAL' '[commands][has no alias]' 1 0 1
      '$PLS_GLOBAL' '[commands][has no command]' 1 1 0
      '$PLS_GLOBAL' '[commands][has neither alias nor command]' 1 0 0
      '$PLS_GLOBAL' '[commands][foo,has no alias]' 2 1 2
      '$PLS_GLOBAL' '[commands][foo,has no command]' 2 2 1
      './pls.yml' '[commands][has no alias]' 1 0 1
      './pls.yml' '[commands][has no command]' 1 1 0
      './pls.yml' '[commands][has neither alias nor command]' 1 0 0
      './pls.yml' '[commands][foo,has no alias]' 2 1 2
      './pls.yml' '[commands][foo,has no command]' 2 2 1
    End

    It "in $1 when sample is $2"
      missing_command_or_alias_error() { %text
        local file="$1"
        local size_of_commands_array="$2"
        local num_of_aliases="$3"
        local num_of_command="$4"
        %= "Format Error: '$file' should have 'alias' and 'command' for each command."
        %= "It currently has $size_of_commands_array commands."
        %= "  $num_of_aliases of which have a key 'alias'."
        %= "  $num_of_command of which have a key 'command'."
      }
      local destination="$(get_destination "$1")"
      cat "samples/faulty/$2.yml" > "$destination"
      When call ./pls this_does_nothing
      The status should be failure
      The stderr should eq "$(missing_command_or_alias_error "$(realpath $destination)" "$3" "$4" "$5")"
    End
  End

  Describe "of type 'newline in alias'"
    newlines_in_alias_error() { 
      local file="$1"
      local num_of_aliases_with_newlines="$2"
      %= "Format Error: '$file' should not have newlines in aliases."
      %= "It currently has $num_of_aliases_with_newlines aliases with newlines."
    }

    Parameters
      '$PLS_GLOBAL' '[commands][has newline in alias]'
      '$PLS_GLOBAL' '[commands][has multiple newlines in alias]'
      './pls.yml' '[commands][has newline in alias]'
      './pls.yml' '[commands][has multiple newlines in alias]'
    End

    Example "in $1 when sample is $2"
      local destination="$(get_destination "$1")"
      cat "samples/faulty/$2.yml" > "$destination"
      When call ./pls this_does_nothing
      The status should be failure
      The stderr should eq "$(newlines_in_alias_error "$(realpath $destination)" 1)"
    End
  End

  Describe "of type 'duplicate aliases'"
    duplicate_aliases_error() {
      local file="$1"
      local aliases_count="$2"
      local num_of_unique_aliases="$3"
      local duplicate_aliases="$4"
      %= "Format Error: '$file' should have unique aliases."
      %= "It currently has $aliases_count aliases, but there are only $num_of_unique_aliases unique names."
      %= "The following aliases are duplicated:"
      %= "$duplicate_aliases"
    }

    Parameters
      # $1: destination file
      # $2: sample
      # $3: number of aliases
      # $4: number of unique aliases
      # $5: duplicate aliases
      '$PLS_GLOBAL' '[commands][foo,foo]' 2 1 "$(printf 'foo')"
      '$PLS_GLOBAL' '[commands][foo,bar,foo]' 3 2 "$(printf 'foo')"
      '$PLS_GLOBAL' '[commands][foo,bar,bar,foo]' 4 2 "$(printf 'bar\nfoo')"
      '$PLS_GLOBAL' '[commands][foo,bar,bar,baz,buzz,buzz,glarp]' 7 5 "$(printf 'bar\nbuzz')"
    End

    Example "in $1 when sample is $2"
      local destination="$(get_destination "$1")"
      cat "samples/faulty/$2.yml" > "$destination"
      When call ./pls this_does_nothing
      The status should be failure
      The stderr should eq "$(duplicate_aliases_error "$(realpath $destination)" "$3" "$4" "$5")"
    End
  End

  Describe "of type 'has empty command'"
    empty_command_error() {
      local file="$1"
      local num_of_empty_commands="$2"
      %= "Format Error: '$file' should not have empty 'command' keys."
      %= "It currently has $num_of_empty_commands empty 'command' keys."
    }

    Parameters
      '$PLS_GLOBAL' '[commands][has empty command]'
      './pls.yml' '[commands][has empty command]'
    End

    Example "in $1 when sample is $2"
      local destination="$(get_destination "$1")"
      cat "samples/faulty/$2.yml" > "$destination"
      When call ./pls this_does_nothing
      The status should be failure
      The stderr should eq "$(empty_command_error "$(realpath $destination)" 1)"
    End
  End
End
