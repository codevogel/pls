# Project Level Shortcuts (pls)

Project Level Shortcuts (pls) is a command-line tool designed to streamline your workflow by allowing you to create, manage, and execute custom aliase for frequently used commands. Say goodbye to messy bash profiles, and say hello to pls!

## What does it do?

`pls` works by creating a `.pls.yml` file in the root of your project directory. This file contains a list of aliases and their corresponding commands. When you run `pls <alias>` in (any subdirectory of) your project, the command associated with that alias is executed. Additionally, you can create a global `.pls` file that contains aliases that are available system-wide. Local aliases take precedence over global aliases.

`pls` supports both single-line and multi-line commands, as well as parameterized commands. Additionally, it caches the commands you run, and warns you when an alias points to an uncached command. This lets you be sure that you are only running the commands that you expect.

## Getting started


### Installation

  This is a quick guide to get `pls` working on your system. 👷
  
  First, make sure you have the dependencies installed, then proceed to the [instructions](#instructions) below.

#### Dependencies
  - `yq` - A lightweight and portable command-line YAML processor. ([Installation instructions](https://mikefarah.gitbook.io/yq/#install))
  - Optional: `fzf` - A command-line fuzzy finder. ([Installation instructions](https://github.com/junegunn/fzf?tab=readme-ov-file#installation))

ℹ️ Note that `fzf` is completely optional. It is used only for the `pick_alias` command, which uses a fallback picker if you don't have `fzf` installed.


  #### Instructions

  1. Download the `pls` script and extract it to a directory on your `PATH` (or add it to your `PATH` in step 2).
     
     - using `curl`: `curl -O https://raw.githubusercontent.com/codevogel/pls/main/release/pls`
     - using `wget`: `wget https://raw.githubusercontent.com/codevogel/pls/main/release/pls`
     - Clone this repository and copy the `release/pls` script.
     - Download the `pls` script from [here](https://github.com/codevogel/pls/blob/main/release/pls) manually.

  2. Add the `pls` script to your `PATH`.
     - If your shell is `bash`: `echo 'export PATH="$PATH:/path/to/dir"' >> ~/.bashrc`
     - If your shell is `zsh`: `echo 'export PATH="$PATH:/path/to/dir"' >> ~/.zshrc`
     - If your shell is something else, do the equivalent of the above.
  3. Test the installation by running `pls --help`.

### Usage

1. To get started with `pls`, you need to add your first alias. To do that, there are two approaches:

    1. Create a `.pls.yml` file and manually add the following contents:
        ```yaml
        commands:
          - alias: "hello"
            command: "echo 'Hello, World!'"
        ```
    2. Add an alias using the `pls add` command:
       ```bash:
       pls add_alias --alias  "hello" --command "echo 'Hello, World!'" --destination local
       ```
       Note that this is a shorter equivalent of the above command:
       ```bash:
       pls a -a "hello" -c "echo 'Hello, World!'" -d local
       ```
2. To execute the alias, run the following command:
    ```bash
    pls hello
    ```
    The output should be:
    ```bash
    Hello, World!
    ```

## Command overview

| Command       | Shorthand | Args               | Flags                                                 | Description                                                         |
|---------------|-----------|--------------------|-------------------------------------------------------|---------------------------------------------------------------------|
| `execute_alias` | `e`         | `alias` <br> `command_args` |                                                       | Execute the command associated with given ALIAS. (default)          |
| `add_alias`     | `a`         |                    | `-a/--alias` <br> `-c/--command` <br> `-d/--destination` <br> `[-f/--force]` | Add or alter a new alias in the current directory.                  |
| `delete_alias`  | `d`         |                    | `-a/--alias` <br> `-d/--destination`                           | Remove an alias from the desired directory.                         |
| `list_aliases`  | `l`         |                    | `-l/--local` <br> `-g/--global` <br> `-a/--all` <br> `-c/--command`          | List all aliases available for invocation in the current directory. |
| `pick_alias`    | `p`         |                    |                                                       | Pick an alias from the list of available aliases to execute.        |
| `clear_cache`   |           |                    |                                                       | Clear the cache of all commands that have been run with pls.        |

### Examples

Here follow some examples of how to use commands that `pls` provides.

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
