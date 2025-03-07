# >>> pyenv initialize >>>
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"
# <<< pyenv initialize <<<

# >>> pyenv-virtualenv initialize >>>
eval "$(pyenv virtualenv-init -)"
# <<< pyenv-virtualenv initialize <<<
