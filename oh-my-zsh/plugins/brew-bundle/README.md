# brew-bundle plugin

The plugin adds several aliases for common [brew bundle](https://github.com/Homebrew/homebrew-bundle) commands.

To use it, add `brew-bundle` to the plugins array of your zshrc file:

```zsh
plugins=(... brew-bundle)
```

## Aliases

| Alias   | Command                               | Description                                                                                   |
|---------|---------------------------------------|-----------------------------------------------------------------------------------------------|
| `bbi`   | `brew bundle install`                 | Install and upgrade (by default) all dependencies from the Brewfile.                          |
| `bbch`  | `brew bundle check`                   | Check if all dependencies are installed from the Brewfile.                                    |
| `bbcl`  | `brew bundle cleanup --force`         | Uninstall all dependencies not listed from the Brewfile.                                      |
| `bbd`   | `brew bundle dump --describe --force` | Write all installed casks/formulae/images/taps into the Brewfile.                             |
| `bbe`   | `brew bundle exec`                    | Run an external command in an isolated build environment based on the Brewfile dependencies.  |
| `bbl`   | `brew bundle list`                    | List all dependencies present in the Brewfile.                                                |
| `bbh`   | `brew bundle --help`                  | Show the help message.                                                                        |

