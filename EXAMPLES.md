# Examples

## Execute Alias


- `pls execute_alias build`
   
  Executes the command associated with the alias 'build'.

- `pls e test`

  Executes the command associated with the alias 'test'.

- `pls deploy`

  Executes the command associated with the alias 'deploy'.

- `pls`
  
  Launches an interactive prompt to select an alias to execute. (This is equivalent for [pick alias](#pick_alias))

## Add Alias

ℹ️ Note that adding and deleting aliases through the CLI is optional, as the `pls` files use an easily modifiable YAML format.

- `pls add_alias -a build -c 'npm run build' -d l`

  Adds an alias 'build' that runs a single-line command to the closest pls file (except the global file).

- `pls a -a test -c 'echo hello\necho world!' -d g`

  Adds an alias 'hello' that runs a multi-line command to the global pls file.

- `pls a -a my_name -c 'echo "My name is $1"' -d h`

  Adds an alias 'foo' that runs a parameterized command and stores it in the pls file in the current directory. The command can be run with 'pls my_name <name>'.

## Delete Alias

ℹ️ Note that adding and deleting aliases through the CLI is optional, as the `pls` files use an easily modifiable YAML format.

  - `pls delete_alias -a build -d l`
  
    Removes the entry for alias 'build' from the closest local file.
  - `pls d -a deploy -d g`
    
    Removes the entry for alias 'deploy' from the global file.
  
  - `pls d -a foo -d h`
    
    Removes the entry for alias 'foo' from the file in the current directory.

## List Aliases

  - `pls list_aliases`
    
      Lists all aliases available for invocation in the current directory.
      Alias names that come from the global file are shown with a '*' at the end.

  - `pls l`

      Equivalent to the above command.
  
  - `pls l -gc`

      Lists all the aliases listed in the global file, and additionally show the command associated with each alias.

## Pick Alias

ℹ️ This command uses [fzf](https://github.com/junegunn/fzf) when you have it installed. If you don't, it uses a fallback picker instead.

  - `pls pick_alias`
    
    Launches an interactive prompt to select an alias to execute.

  - `pls p`

    Equivalent to the above command.

  - `pls`

    Equivalent to the above command.

#### Execute Alias


- `pls execute_alias build`
   
  Executes the command associated with the alias 'build'.

- `pls e test`

  Executes the command associated with the alias 'test'.

- `pls deploy`

  Executes the command associated with the alias 'deploy'.

- `pls`
  
  Launches an interactive prompt to select an alias to execute. (This is equivalent for [pick alias](#pick_alias))

#### Add Alias

ℹ️ Note that adding and deleting aliases through the CLI is optional, as the `pls` files use an easily modifiable YAML format.

- `pls add_alias -a build -c 'npm run build' -d l`

  Adds an alias 'build' that runs a single-line command to the closest pls file (except the global file).

- `pls a -a test -c 'echo hello\necho world!' -d g`

  Adds an alias 'hello' that runs a multi-line command to the global pls file.

- `pls a -a my_name -c 'echo "My name is $1"' -d h`

  Adds an alias 'foo' that runs a parameterized command and stores it in the pls file in the current directory. The command can be run with 'pls my_name <name>'.

#### Delete Alias

ℹ️ Note that adding and deleting aliases through the CLI is optional, as the `pls` files use an easily modifiable YAML format.

  - `pls delete_alias -a build -d l`
  
    Removes the entry for alias 'build' from the closest local file.
  - `pls d -a deploy -d g`
    
    Removes the entry for alias 'deploy' from the global file.
  
  - `pls d -a foo -d h`
    
    Removes the entry for alias 'foo' from the file in the current directory.

#### List Aliases

  - `pls list_aliases`
    
      Lists all aliases available for invocation in the current directory.

  - `pls l`

      Equivalent to the above command.
  
  - `pls l -gc`

      Lists all the aliases listed in the global file, and additionally show the command associated with each alias.

#### Pick Alias

ℹ️ This command uses [fzf](https://github.com/junegunn/fzf) when you have it installed. If you don't, it uses a fallback picker instead.

  - `pls pick_alias`
    
    Launches an interactive prompt to select an alias to execute.

  - `pls p`

    Equivalent to the above command.

  - `pls`

    Equivalent to the above command.
