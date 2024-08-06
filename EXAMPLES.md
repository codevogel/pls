# Examples

- [Execute alias](#execute-alias)
- [Pick and  execute an alias](#pick-and-execute-an-alias)
- [Add alias](#add-alias)
- [Delete alias](#delete-alias)
- [List aliases](#list-aliases)
- [Print an alias instead of executing it](#print-an-alias-instead-of-executing-it)
- [Clear the command cache](#clear-the-command-cache)

## Execute alias

- `pls build`
   
  Executes the command associated with the alias 'build'.

- `pls deploy`

  Executes the command associated with the alias 'deploy'.

## Pick and execute an alias

ℹ️ This command uses [fzf](https://github.com/junegunn/fzf) when you have it installed. If you don't, it uses a fallback picker instead.

  - `pls pick_alias`
    
    Launches an interactive prompt to select an alias to execute.

  - `pls p`

    Equivalent to the above command.

  - `pls`

    Equivalent to the above command.

## Add alias

ℹ️ Note that adding and deleting aliases through the CLI is optional, as the `pls` files use an easily modifiable YAML format.

- `pls -a build -c 'npm run build' -s l`

  Adds an alias 'build' that runs a single-line command to the closest pls file (except the global file).

- `pls test -ac 'echo hello\necho world!' -s g`

  Adds an alias 'hello' that runs a multi-line command to the global pls file.

- `pls -a my_name -c 'echo "My name is $1"' -s h`

  Adds an alias 'foo' that runs a parameterized command and stores it in the pls file in the current directory. The command can be run with 'pls my_name <name>'.

## Delete alias

ℹ️ Note that adding and deleting aliases through the CLI is optional, as the `pls` files use an easily modifiable YAML format.

  - `pls -d build -s l`
  
    Removes the entry for alias 'build' from the closest local file.
  - `pls deploy -ds g`
    
    Removes the entry for alias 'deploy' from the global file.
  
  - `pls -d foo -s h`
    
    Removes the entry for alias 'foo' from the file in the current directory.

## List aliases

  - `pls -l`
    
      Lists all aliases available for invocation in the current directory.

  - `pls -ls g`

      Lists all the aliases listed in the global file.

  - `pls -lp -s g`

      Lists all the aliases listed in the global file, and additionally show the command associated with each alias.

  - `pls -lps g`

      Equivalent to the above command.

## Print an alias instead of executing it

- `pls build -p`
   
  Executes the command associated with the alias 'build'.

- `pls deploy -p`

  Executes the command associated with the alias 'deploy'.

## Clear the command cache

- `pls --clear-cache`

  Clears the cache of *all* executed commands.
