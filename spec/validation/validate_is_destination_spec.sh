Include 'src/lib/validations/validate_is_destination.sh'

Describe 'validate_is_destination'
  Describe 'is blank on valid destinations'
    Parameters:value g global l local h here

    Example "$1"
      When call validate_is_destination "$1"
      The status should be failure
      The output should be blank
    End
  End

  Describe 'prints on invalid destinations'
    Parameters:value glo globals lo locals he heres

    Example "$1"
      When call validate_is_destination "$1"
      The status should be success
      The output should eq "Error: Invalid argument. Must be one of [ g, global, l, local, h, here ]"
    End
  End
End
