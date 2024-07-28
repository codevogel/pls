Include 'src/lib/helpers/check_version.sh'

Describe 'check_version'
  Describe 'succeeds if version is higher or equal to v4.44.2'
    Parameters:value v4.44.2 v4.44.3 v4.45.2 v5.0.0
    Example "$1"
      When call check_version "v4.44.2" "$1" 
      The status should be success
    End
  End

  Describe 'fails if version is lower than v4.44.2'
    Parameters:value v4.44.1 v4.43.2 v4.0.0 v3.99.99

    Example "$1"
      When call check_version "v4.44.2" "$1" 
      The status should be failure
    End
  End
End
