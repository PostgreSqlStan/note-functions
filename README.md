# (zsh) Note functions


*This is a learning project, only semi-tested on my machine (macOS 13.6, zsh 5.9) so far. For a more reliable and portable way to manage text notes, I recommend trying this [notes](https://github.com/nickjj/notes/tree/master) shell script.*

:warning: I've learned just enough shell scripting to be dangerous.

---

I've kept a directory of text files in `~/notes`   for several years. It's a easy way to collect personal cheatsheets that are easily edited and viewed from the command line. Highly recommended.

Last year, as a learning project, I created a simple function, [note](#note), to display file stored in `~/notes`. I ended up using it even more than I'd expected to.

Inspired by usefulness of my `note` function, and a general desire to learn more about shell scripting, I've created another function, [nnote](#nnote), to add note entries from the command line. I'm still test-driving `nnote` and am not sure if it will as useful as the `note` function. We'll see.

Usage examples:

```
% nnote -b Dated note file example
% note 20231004_note
▶️  Dated note file example
% nnote -bd -n example Example note entry with bullet and timestamp.
% note example
▶️  [Wed Oct  4 21:32:34 CDT 2023] Example note entry with bullet and timestamp.
% nnote A plain note entry example
% note example
▶️  [Wed Oct  4 21:32:34 CDT 2023] Example note entry with bullet and timestamp.

A plain note entry example
% print piped text | nnote -d -n pipe-example Pipe example
% note pipe-example
[Wed Oct  4 21:34:22 CDT 2023] Pipe example
piped text
```

## `note`

```
note  - display file(s) stored configurable notes directory

Usage:
  note NOTE                    show NOTE
  note                         list files in notes directory

Options:
  -e --edit NOTE               edit note
  -h --help                    show this message
  --version                    show version

Environment parameters:
  NOTE_HOME                    notes directory, default={HOME}/notes

See repo for updates, comments, issues, etc:
  https://github.com/PostgreSqlStan/note-functions
```

## `nnote`

```
nnote  - add entry to default note

Usage:
  nnote [OPTIONS] [TEXT]       add entry to default note

Options:
  -b --bullet                  include bullet
  -d --datetime                include date/time
  -h --help                    show this message
  -n --note NOTE               set default to NOTE
  -s --squeeze                 no empty line before entry
  -v --paste                   add clipboard to entry
  --version                    show version

Environment parameters:
  NOTE_HOME                    notes directory, default={HOME}/notes
  NOTE_NAME                    note to create/append, set with -n option
  NOTE_BULLET                  default='▶️  '

The -n option set the default note for the current shell session:

  nnote -n example Entry Example
  nnote 2nd entry

Piped text is added to a note entry:

  print piped text | nnote Pipe Example

Use -v to add the clipboard to an entry:

  print pasted text | pbcopy && nnote -v Clipboard Example

The -b and -d options add a bullet and stampstamp:

  nnote -bd Bullet Timestamp Example

If the -n option has not be used and NOTE_NAME is not set, a note
named with the current date (yyyymmdd_note) is used.

See repo for updates, comments, issues, etc:
  https://github.com/PostgreSqlStan/note-functions
```


## Installation

There are various ways to save and load custom zsh functions. The simplest way is to include the functions in your zsh config (`.zshrc`). See my [zdotdir](https://github.com/PostgreSqlStan/zdotdir) for an example of having them loaded automatically from a specified directory.

### Test drive

To test the functions with a temporary directory, from the repo directory:

```zsh
source note.zsh nnote.zsh
NOTE_HOME=$(mktemp -d)
nnote Test note entry          # add entry to yyyymmdd_note
note                           # list notes
```

## zsh completions (recommended)

Add custom zsh completions by including the following commands to your zsh config (`.zshrc`).

Configure `note` completions to show files from the notes directory:

```zsh
compdef '_path_files -W "${NOTE_HOME:-${HOME}/notes/}" -g "^.*"' note
```

Configure `nnote` to display completions for its options:

```zsh
compdef _gnu_generic pbnote
```

*Understanding [zshcompletions](https://zsh.sourceforge.io/FAQ/zshfaq04.html#l49) is a [challenge](https://postgresqlstan.github.io/zsh/zshcompletions-confusion/). I'm still trying to figure out to refine these completions further and have them loaded automatically from a directory.*


## aliases (recommended)

```zsh
alias n=note
alias nn=nnote
```

