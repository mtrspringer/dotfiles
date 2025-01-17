SHELL = /bin/bash
DOTFILES_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
OS := $(shell bin/is-supported bin/is-macos macos linux)
PATH := $(DOTFILES_DIR)/bin:$(PATH)
HOMEBREW_PREFIX := $(shell bin/is-supported bin/is-arm64 /opt/homebrew /usr/local)
N_NODE_VERSION := lts
export XDG_CONFIG_HOME = $(HOME)/.config
export STOW_DIR = $(DOTFILES_DIR)/stow
export ACCEPT_EULA = Y

.PHONY: test

all: $(OS)

macos: sudo core-macos packages link

linux: core-linux link

core-macos: brew bash git node ruby rust

core-linux:
	apt-get update
	apt-get upgrade -y
	apt-get dist-upgrade -f

stow-macos: brew
	is-executable stow || brew install stow

stow-linux: core-linux
	is-executable stow || apt-get -y install stow

sudo:
ifndef GITHUB_ACTION
	sudo -v
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
endif

packages: brew-packages cask-apps node-packages rust-packages

# TODO: ensure target directories exist before running stow
# TODO: figure out how to support docker config: stow --dotfiles -t $(HOME)/.docker docker
stow-link: stow-$(OS)
	for FILE in $$(\ls -A $(STOW_DIR)/zsh); do if [ -f $(HOME)/$$FILE -a ! -h $(HOME)/$$FILE ]; then \
		mv -v $(HOME)/$$FILE{,.bak}; fi; done
	stow --dotfiles -t $(HOME) zsh
	stow --dotfiles -t $(HOME)/.aws aws
	stow --dotfiles -t $(HOME) git
	stow --dotfiles -t $(HOME)/.gnupg gpg
	stow --dotfiles -t $(HOME)/.hammerspoon hammerspoon
	stow --dotfiles -t $(HOME)/.kube kube

# TODO: figure out how to support docker config: stow --delete --dotfiles -t $(HOME)/.docker docker
stow-unlink: stow-$(OS)
	stow --delete --dotfiles -t $(HOME) zsh
	stow --delete --dotfiles -t $(HOME)/.aws aws
	stow --delete --dotfiles -t $(HOME) git
	stow --delete --dotfiles -t $(HOME)/.gnupg gpg
	stow --delete --dotfiles -t $(HOME)/.hammerspoon hammerspoon
	stow --delete --dotfiles -t $(HOME)/.kube kube
	for FILE in $$(\ls -A $(STOW_DIR)/zsh); do if [ -f $(HOME)/$$FILE.bak ]; then \
		mv -v $(HOME)/$$FILE.bak $(HOME)/$${FILE%%.bak}; fi; done

link: stow-$(OS)
	for FILE in $$(\ls -A runcom); do if [ -f $(HOME)/$$FILE -a ! -h $(HOME)/$$FILE ]; then \
		mv -v $(HOME)/$$FILE{,.bak}; fi; done
	mkdir -p $(XDG_CONFIG_HOME)
	stow -t $(HOME) runcom
	stow -t $(XDG_CONFIG_HOME) config

unlink: stow-$(OS)
	stow --delete -t $(HOME) runcom
	stow --delete -t $(XDG_CONFIG_HOME) config
	for FILE in $$(\ls -A runcom); do if [ -f $(HOME)/$$FILE.bak ]; then \
		mv -v $(HOME)/$$FILE.bak $(HOME)/$${FILE%%.bak}; fi; done

brew:
	is-executable brew || curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash

bash: BASH=$(HOMEBREW_PREFIX)/bin/bash
bash: SHELLS=/private/etc/shells
bash: brew
ifdef GITHUB_ACTION
	if ! grep -q $(BASH) $(SHELLS); then \
		brew install bash bash-completion@2 pcre && \
		sudo append $(BASH) $(SHELLS) && \
		sudo chsh -s $(BASH); \
	fi
else
	if ! grep -q $(BASH) $(SHELLS); then \
		brew install bash bash-completion@2 pcre && \
		sudo append $(BASH) $(SHELLS) && \
		chsh -s $(BASH); \
	fi
endif

git: brew
	brew install git git-extras

node: brew-packages
	n $(N_NODE_VERSION)

ruby: brew
	brew install ruby

rust: brew
	brew install rust

brew-packages: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Brewfile || true

cask-apps: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Caskfile || true
	defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"
	for EXT in $$(cat install/Codefile); do code --install-extension $$EXT; done
	xattr -d -r com.apple.quarantine ~/Library/QuickLook

node-packages: node
	npm install -g $(shell cat install/npmfile)

rust-packages: CARGO=$(HOMEBREW_PREFIX)/bin/cargo
rust-packages: rust
	$(CARGO) install $(shell cat install/Rustfile)

test:
	eval $$(fnm env); bats test
