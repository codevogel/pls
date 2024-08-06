Include 'src/lib/validations/validate_is_only_operation.sh'

Describe 'is_only_operation'

  Describe 'fails when no operation is supplied'
    It 'no arg'
      When call is_only_operation
      The status should be success
      The output should eq "No operation flag supplied."
    End
  End

  Describe 'passes when only one operation is used'
    Example '--add'
      When call is_only_operation 1
      The status should be success
    End
  End

  Describe 'fails when more than one operation is used'
    Example '--add --delete'
      When call is_only_operation 1 1
      The status should be success
      The output should eq "Can only use one operation flag (--add, --delete, --list) at a time."
    End
  End
End
