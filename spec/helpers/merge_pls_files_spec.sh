Include 'spec/setup_and_cleanup.sh'
Include 'src/lib/helpers/merge_pls_files.sh'

BeforeEach 'setup'
AfterEach 'cleanup'

Describe 'merge_pls_files'
  Describe 'merges and orders'
    It 'local_list and global_list into combined_list'
      local local_list="./samples/valid/local_list.yml"
      local global_list="./samples/valid/global_list.yml"
      When call merge_pls_files "$global_list" "$local_list"
      The status should be success
      The output should eq "$(cat ./samples/valid/combined_list_ordered.yml)"
    End

    It 'local_list into combined_list if global_list does not exist'
      local local_list="./samples/valid/local_list.yml"
      local global_list="non-existent"
      When call merge_pls_files "$global_list" "$local_list"
      The status should be success
      The output should eq "$(cat ./samples/valid/local_list_ordered.yml)"
    End

    It 'global_list into combined_list if local_list does not exist'
      local local_list="non-existent"
      local global_list="./samples/valid/global_list.yml"
      When call merge_pls_files "$global_list" "$local_list"
      The status should be success
      The output should eq "$(cat ./samples/valid/global_list_ordered.yml)"
    End

    It 'empty combined_list if neither local_list or global_list exists'
        local local_list="non-existent"
        local global_list="non-existent"
        When call merge_pls_files "$global_list" "$local_list"
        The status should be success
        The output should eq "commands:"
    End
  End
End


