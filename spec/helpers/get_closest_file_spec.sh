Include spec/setup_and_cleanup.sh
Include src/lib/helpers/get_closest_file.sh

BeforeEach 'setup' 'prepare_directory_structure'
AfterEach 'cleanup'

prepare_directory_structure() {
  mkdir -p ./a/b/c
}

Describe 'get_closest_file'
It 'finds file in same directory'
touch ./a/b/c/my_file
When call get_closest_file ./a/b/c my_file
The status should be success
The output should eq "$TESTING_CWD/a/b/c/my_file"
End

It 'finds file in parent directory'
touch ./a/b/my_file
When call get_closest_file ./a/b/c my_file
The status should be success
The output should eq "$TESTING_CWD/a/b/my_file"
End

It 'finds file in parent of parent directory'
touch ./a/my_file
When call get_closest_file ./a/b/c my_file
The status should be success
The output should eq "$TESTING_CWD/a/my_file"
End

It 'finds file in root directory'
touch ./my_file
When call get_closest_file ./a/b/c my_file "$TESTING_CWD"
The status should be success
The output should eq "/my_file"
End

It 'is blank if file does not exist'
When call get_closest_file "$PWD" my_file
The status should be success
The output should eq ""
End
End
