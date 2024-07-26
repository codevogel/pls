Include 'src/lib/validations/validate_not_empty.sh'

Describe 'validate_not_empty'
  Example 'blank if value is not empty'
    When call validate_not_empty "foo"
    The status should be failure
    The stdout should be blank
  End

  Example 'prints when value is empty'
    When call validate_not_empty ""
    The status should be success
    The stdout should eq "must not be empty"
  End
End
