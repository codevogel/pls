# Project Level Shortcuts (pls)

Project Level Shortcuts (pls) is a command-line tool designed to streamline your workflow by allowing you to create, manage, and execute custom aliases for frequently used commands. Say goodbye to messy bash profiles, and say hello to pls! 🐦

Run your most frequently used commands with ease, e.g. `pls test` to run tests, `pls godot` to open your Godot project and editor, `pls open-here` to open the current directory in your file manager, and whatever else you can think of!

### Quick Start 🚀 

- **Install**

  For advanced users, here's a quick guide to get `pls` working on your system.

  ```bash
  # cd to directory that should house the pls script
  cd /path/to/pls/dir
  # download and make executable
  curl -sS https://raw.githubusercontent.com/codevogel/pls/main/release/pls > pls && chmod +x pls
  # add pls to your PATH
  echo 'export PATH="$PATH:/path/to/pls/dir"' >> ~/.bashrc
  ```
- **Try in Docker**

  If you want to try `pls` without installing it on your own system first, you can use the following commands:

  ```bash
  # cd to directory that should house the Dockerfile
  cd ./pls-test
  # download the Dockerfile
  curl -sS https://raw.githubusercontent.com/codevogel/pls/main/docker/Dockerfile > Dockerfile
  # build and run the Docker container
  docker build -t plsbuntu . --no-cache
  docker run -it plsbuntu
  ```

### Table of Contents

- [Quick Start](#quick-start-)
- [What is pls and why do I want pls?](#what-is-pls-and-why-do-i-want-pls)
- [Getting started](#getting-started)
  - [Installation](#installation)
    - [Dependencies](#dependencies)
    - [Instructions](#instructions)
  - [Usage](#usage)
- [Command overview](#command-overview)
  - [Operation Flags](#operation-flags)
  - [Other Flags](#other-flags)
  - [Examples](#examples)
- [Execute commands in the main shell](#execute-commands-in-the-main-shell)
  - [If your main shell is bash](#if-your-main-shell-is-bash)
  - [If your main shell is not bash](#if-your-main-shell-is-not-bash)
    - [Real-world example](#real-world-example)
- [File format](#file-format)
- [Command cache](#command-cache)
- [Configuration](#configuration)
- [Roadmap](#roadmap)
- [Contributing](#contributing)

## What is pls and why do I want pls?

`pls` allows you to store your aliases in `pls` files. You can either define system-wide aliases in a `global` file, or place project-specific aliases in a `local` file, e.g., in the root of your project directory. The `pls` file (by default named `.pls.yml`) contains a list of aliases and their corresponding commands. When you run `pls <alias>`, the command associated with that alias is executed. Aliases from a `local`, project-specific context take precedence over aliases from the `global`, system-wide context, allowing you to reuse the same alias in different contexts. For example, if you have two projects that use different testing frameworks, `pls` allows you to just run `pls test` in either directory, reducing the need to remember framework-specific commands.

`pls` supports single-line and multi-line commands, as well as parameterized commands. Additionally, it caches the commands you run, and warns you when an alias points to an uncached command. This lets you be sure that you are only running the commands that you expect.

<details open>
  <summary>❓Why would I use <code>pls</code>?</summary>
  <ul>
    <li><b>Organized alias management:</b> Instead of cluttering your shell profile with numerous aliases, <code>pls</code> lets you keep them organized in separate files, making it easier to manage and maintain your shortcuts.</li>
    <li><b>Context-aware aliases:</b> <code>pls</code> allows you to have project-specific aliases that override global ones, enabling you to reuse common alias names (like "test") across different projects with varying implementations.</li>
    <li><b>Command cache verification:</b> The command caching feature warns you when you're about to run a new or modified command, helping prevent accidental execution of potentially harmful commands.</li>
    <li><b>Portability and synchronization:</b> Easily sync your aliases between different machines (e.g., work and home computers) by managing your <code>.pls.yml</code> files.</li>
    <li><b>Fuzzy command picker:</b> The built-in alias picker (with optional <code>fzf</code> integration) makes it easy to find and execute aliases without remembering exact names.</li>
    <li><b>Parameterized commands:</b> <code>pls</code> supports parameterized commands, allowing you to pass arguments to your aliases.</li>
    <li><b>Works with bash:</b> <code>pls</code> is a lightweight shell script that works with any shell that supports bash syntax.</li>
  </ul>
</details>

<details>
  <summary>❓How does it work under the hood?</summary>
  If you execute an alias, <code>pls</code> will first query the <code>global</code> context (which is the file that lives at <code>$PLS_GLOBAL</code>). It then searches for the closest file that matches <code>$PLS_FILENAME</code> that lives in the current, or any of the parent directories (excluding <code>$PLS_GLOBAL</code> file). If it finds any conflicts (aliases that appear in both the <code>global</code> and <code>local</code> context), the command from the <code>local</code> file is picked. It then verifies whether this exact command has been ran before, taking into account the alias, the file which it is stored in, and the exact command contents. If the command is new, was moved to a different location, or has changed since the last execution, <code>pls</code> will prompt you to confirm the execution of the command. This is to prevent accidental execution of potentially harmful commands. 
</details>

## Getting started

### Installation

  This is a quick guide to get `pls` working on your system. 🔧🐦
  
  First, make sure you have the dependencies installed, then proceed to the [instructions](#instructions) below.

#### Dependencies
  - `yq` (tested with `v4.44.2`) - A lightweight and portable command-line YAML processor. ([Installation instructions](https://mikefarah.gitbook.io/yq/#install))
  - Optional: `fzf` - A command-line fuzzy finder. ([Installation instructions](https://github.com/junegunn/fzf?tab=readme-ov-file#installation))

> ℹ️ Note: `fzf` is completely optional. It is used only for the `pick_alias` command, which uses a fallback picker if you don't have `fzf` installed.


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
  3. Optionally, add support for running the commands in your main shell process. See the [Use in main shell](#use-in-main-shell) section for more information.
  3. Test the installation by running `pls --help`.

### Usage

1. To get started with `pls`, add your first alias. There are two approaches:

    1. Create a `.pls.yml` file and manually add the following contents (see ['File format'](#file-format) if you want to expand on it further):
        ```yaml
        commands:
          - alias: "hello"
            command: "echo 'Hello, World!'"
        ```
    2. Add an alias using the `pls add` command:
       ```bash:
       pls hello --add  --command "echo 'Hello, World!'" --scope local
       ```
       > ℹ️ Note: As `pls` supports combining flags, this is a shorter equivalent of the above command:
       ```bash:
       pls hello -ac "echo 'Hello, World!'" -s local
       ```
2. To execute the alias, run `pls hello`. 
    You should first be prompted to confirm that you indeed want to run this command. Enter `y` or `Y` and press `Return`.

    > ℹ️ Note: When you execute the alias another time, `pls` will have cached usage of the command, and you will not be prompted until the command (or location of the file) changes.

    ```
    ❯ ./pls hello
    Alias 'hello' was found in '/home/codevogel/work/pls/.pls.yml', but this command seems new.

    echo 'Hello, World!'

    Are you sure you want to invoke the above command? [y/n] y
    Hello, World!

    ❯ ./pls hello
    Hello, World!
    ```

    > ℹ️ Note: When you add the -p flag, the command will be printed instead of executed. This is useful if you want to run the command in your main shell process, or want to pipe the command to run in a different shell.

    

  3. You can also leave out the alias, and `pls` will launch an interactive picker that lets you choose from a list of available aliases. Try it now, just run `pls` !

## Command overview

To keep the syntax for using `pls` as short as possible, and because we want to keep the namespace for aliases clean of commands, `pls` uses just a single root command: `pls`. This command can be followed by an alias, command arguments, or flags.

```
pls [alias] [command_args] [flags]
```

###  Operation Flags

This is an overview of the flags that trigger `pls` to perform alternative operations (instead of the default operation: executing an alias). Each of these operation flags conflict with one another: you can only use one at a time. 

| Operation  | Shorthand | Needs Flags           | Optional Flags            | Description                                                                                                                                                                               |
|------------|-----------|-----------------------|---------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `--add`    | `-a`      | `--command`<br>`--scope` | `--force`           | Adds a new alias for a <br>`--command <command>`<br>to the pls file at a given<br>`--scope <[g]lobal, [l]ocal, [h]ere>`.<br> Use with `--force` to overwrite the alias if it exists.                    |
| `--delete` | `-d`      | `--scope`             |                     | Delete the alias from the pls file at given<br>`--scope  <[g]lobal, [l]ocal, [h]ere>`.                                                                                                       |
| `--list`   | `-l`      |                       | `--scope` `--print` | List all aliases available in the current directory.<br>Or, list aliases only from `--scope <[g]lobal, [l]ocal, [a]ll>`.<br>Use with `--print` to print the command associated with each alias. |  |

### Other Flags

These are the flags that do not represent operations. Some of them are used to provide additional information to operations, or to modify the behavior of the root command.

| Flag            | Needs argument | Used with                    | Description                                                                                                                                                                                                          |
|-----------------|----------------|------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `--command`     | yes              | `--add`                      | Supplies a command to associate with the alias in the  `--add` operation. Pass the command as a string, newline characters ('\n') are allowed.                                                                       |
| `--scope`       |yes              | `--add`<br>`--delete`<br>`--list` | The selected scope for `--add`, `--delete`, and `--list` operations. Allowed scopes are [g]lobal, [l]ocal, [a]ll, [h]ere.  The 'all' scope is exclusive to `--list`. The 'here' scope is excluded from `--list`.     |
| `--print`       |               | root command<br>`--list`        | Prints the command instead of executing it when used with root command.  Useful for piping to other commands or shells. Or, if used in conjunction with `--list`, it additionally prints the command for each alias. |
| `--force`       |              | `--add`                      | Overwrite the alias if it already exists when using the `--add` operation.                                                                                                                                           |
| `--clear-cache` |              |                              | Before doing anything, clears the cache of all commands that have been run with pls.                                                                                                                                 |
| `--help`        |              |                              | Show the help.                                                                                                                                                                                                       |
| `--version`     |              |                              | Show the version number.                                                                                                                                                                                             |
### Examples

View [`EXAMPLES.md` (here)](EXAMPLES.md) to see some examples of how to use commands that `pls` provides.

## Execute commands in the main shell

### If your main shell is bash

If you want `pls` to execute the command in your main shell process, and your shell is `bash`, then you can simply add `.` or `source` in front of your `pls` command:

```bash
# Executes 'cd ~/work/godot/' in the main shell process
. pls godot
```

You could setup an alias for this in your `.bashrc`:

```bash
alias plz=". pls"
```

### If your main shell is not bash

If your main shell is not `bash`, you can still use `pls` in your main shell process. Just know that the command will be executed in a bash subshell. If you want to execute the command in your main shell process, you can make use of the `-p` flag and `eval`. Here is an example for `zsh`, in which we set up a function `plz` that executes the command in the main shell process:

We create a `zsh` function at `~/.zshfuncs/plz`
```zsh
cmd="$(pls "$1" -p)"
execute_command() { # Use a function so we can use parameterized commands as well
   eval "$cmd"
}
execute_command ${@:2}
```

Then we load it in our `.zshrc`:

```bash
# Load the zsh function 'plz'
echo 'fpath=(~/.zshfuncs "${fpath[@]}")' >> ~/.zshrc
echo 'autoload -Uz plz' >> ~/.zshrc
```

Now say we have the following in our `.pls.yml` file:
```yaml
commands:
  - alias: go
    command: cd $1 && ls -al
```

We can use `plz` in our `zsh` shell:

```zsh
plz go ~/work/godot/ # cd's to ~/work/godot/ and lists the contents
```

#### Real-world example
Here is a real-world example of how I load my development environment for a <a href="https://godotengine.org/">Godot</a> project. In my global <code>.pls.yml</code> I have setup the following alias:

```yml
  - alias: godot
    command: |
      wezterm start --always-new-process -- bash -c "cd ~/work/godot/projects/tit-versus-tat && nvim .; exec zsh" &
      disown
      Godot_v4.2.2-stable_linux.x86_64 -e --path ~/work/godot/projects/tit-versus-tat/ --single-window &
      disown
      exit
```
Now, whenever I sit down to work on my game, I just run `plz godot` and my project loads up, along with launching a new terminal with `nvim` open in the project directory. 

## File format 

`pls` uses YAML files to store aliases. YAML is a human-readable data serialization format that is easy to read and write, which should make adding commands a pretty straight-forward experience. An example of a properly formatted `.pls.yml` file is shown here:

```yaml
commands:
  - alias: my-alias
    command: echo "hello from my-alias!"
  - alias: my-multiline-command
    command: |
      echo "echo!"
      echo "... echo!"
  - alias: work
    command: cd ~/some/really/long/path/to/my/directory/work
  - alias: greet me
    command: |
      echo "Hello, my name is $1!"
```
A few points of interest here:
- The `commands` key should be the *only* root key of the YAML file, and must always be present. (This means that at minimum, a `pls` file should contain `commands:`)
- The `commands` key contains an array of objects (which may be empty), and can hold:
  - An `alias` key that contains a *single-line* string representing the alias you want to use. (Spaces and symbols are allowed, but discouraged.)
  - The `command` key that contains *either* a  *single-line* or *multi-line* string containing the command you want to execute. Multi-line commands must be preceded by a `|` or `|-` character and indented.
  - The `command` key can also contain a *parameterized* command, where `$1`, `$2`, etc. are replaced with the arguments passed to the alias.

> ℹ️ Don't worry too much about remembering all this - if you break any of these rules, you should get an error when running `pls`, pointing you in the right direction to correct the formatting.

## Command cache

Each time you execute an alias, `pls` stores:
- The alias that was executed
- The exact command that was executed
- The path to the file where the alias was found

This allows `pls` to warn you when you try to execute an alias that points to a different command than the one you have previously executed. This is especially useful when you are working on a project with multiple collaborators (maybe someone has changed one of the aliases), or when you have multiple aliases with the same name in different directories.

> ℹ️ If you want to be informed about the contents of the command, regardless of it being cached already, or if you want to turn off the warning altogether, see the `PLS_ALWAYS_VERIFY` and `PLS_ENABLE_CACHE_CHECK` environment variables in the [Configuration](#configuration) section.

To clear the cache, you can run `pls clear_cache`.

## Configuration

`pls` can be configured using a `.plsrc` file, which is stored at the environment variable `$PLS_RC`. If you have not set `$PLS_RC`, then it will be created at `$HOME/.config/pls/.plsrc` by default, including the default values listed in the table below:

| Variable                | Description                                                                                   | Default Value |
|-------------------------|-----------------------------------------------------------------------------------------------|---------------|
| `PLS_FILENAME`          | The name of the data file that `pls` looks for.                                                | `.pls.yml`    |
| `PLS_GLOBAL`            | The path to the global `pls` file (system-wide)                                                           | `$HOME/$PLS_FILENAME` |
| `PLS_ENABLE_CACHE_CHECK`| If set to `true`, `pls` will check the cache for the command before executing it.              | `true`        |
| `PLS_ALWAYS_VERIFY`     | If set to `true`, `pls` will always prompt you to confirm the execution of the command, even if `PLS_ENABLE_CACHE_CHECK` is `false`        | `false`       |
| `PLS_ENABLE_FZF`        | If set to `true`, `pls` will use `fzf` as the picker (given that you have it installed).       | N/A       |
| `PLS_DIR`               | The directory where internal `pls` files are stored. Not recommended to place this in `/tmp/` as that would delete the cache on reboot.                                   | `$HOME/local/.share/pls`           |

Make sure each of these variables is on a new line in the `.plsrc` file, and that you are not missing any. If in doubt, you can always delete the `.plsrc` file and `pls` will recreate it with the default values.

## Roadmap

- [x] Add support for single-line commands
- [x] Add support for multi-line commands
- [x] Add support for parameterized commands
- [x] Add context-aware aliases
- [x] Add command cache verification
- [x] List available aliases
- [x] Add alias picker
- [x] Add `.rc` file
- [x] Use `pls` with flags, preventing commands from taking up alias namespace.
- [ ] What else would you like to see? Let us know by opening an issue!

## Contributing
Please refer to the [CONTRIBUTING.md](CONTRIBUTING.md) file for more information on how to contribute to this project.
