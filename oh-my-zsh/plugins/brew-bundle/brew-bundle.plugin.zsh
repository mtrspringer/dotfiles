# Exports

# TODO: make this configurable
export HOMEBREW_BUNDLE_FILE=${DOTFILES_HOME}/install/Brewfile

# Aliases

alias bbi="brew bundle install"
alias bbch="brew bundle check"
alias bbcl="brew bundle cleanup"
alias bbd="brew bundle dump --describe --force"
alias bbe="brew bundle exec"
alias bbl="brew bundle list"
alias bbh="brew bundle --help"

# Functions

# Brew alias that automatically updates Brewfile after `brew install|uninstall`: https://github.com/Homebrew/brew/issues/3933
bru() {
  local dump_commands=('install' 'uninstall') # Include all commands that should do a brew dump
  local main_command="${1}"

  brew ${@}

  for command in "${dump_commands[@]}"; do
    # TODO: make Brewfile location configurable
    [[ "${command}" == "${main_command}" ]] && bbd
  done
}
