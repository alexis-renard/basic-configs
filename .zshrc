#===================================================
# PATH related
#===================================================

PATH="$PATH:$HOME/.tfenv/bin"
PATH="$PATH:$HOME/.local/bin" #for pip install --user
PATH="$PATH:$HOME/softs"

#===================================================
# zsh related
#===================================================

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# ZSH_THEME="bureau"
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel9k/powerlevel9k"
POWERLEVEL9K_MODE='nerdfont-complete'

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(user dir newline status)
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(user dir kubecontext newline status )
POWERLEVEL9K_DIR_USER_FOREGROUND=249
POWERLEVEL9K_DIR_HOME_FOREGROUND=249
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND=249
POWERLEVEL9K_DIR_ETC_FOREGROUND=249
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND=249
POWERLEVEL9K_DIR_HOME_BACKGROUND=024 #deepskyblue4a
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND=024 #deepskyblue4a
POWERLEVEL9K_DIR_ETC_BACKGROUND=024 #deepskyblue4a
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND=024 #deepskyblue4a
# POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_STATUS_VERBOSE=true
POWERLEVEL9K_STATUS_CROSS=true
POWERLEVEL9K_STATUS_OK_BACKGROUND=017
POWERLEVEL9K_STATUS_ERROR_BACKGROUND=017

POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(vcs time aws battery)
POWERLEVEL9K_VCS_CLEAN_FOREGROUND=017 # navyblue
POWERLEVEL9K_VCS_CLEAN_BACKGROUND=040 # green3a
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=017 # navyblue
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=220 # gold1
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=236 #grey19
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=160 #red3a
POWERLEVEL9K_SHOW_CHANGESET=true
POWERLEVEL9K_DATE_FORMAT=%D{%d.%m.%y}

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

plugins=(git 
	terraform
	zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

#===================================================
# User functions
#===================================================

gpg_decode () {
	echo "$1" | base64 --decode | gpg
}

dropdown_terminal_set_height_function () {
	p=`pwd`
	cd ~/.local/share/gnome-shell/extensions/drop-down-terminal@gs-extensions.zzrough.org
	gsettings --schemadir . set org.zzrough.gs-extensions.drop-down-terminal terminal-size "${1}00px"
	cd $p
}

dropdown_terminal_set_transparency_function () {
	p=`pwd`
	cd ~/.local/share/gnome-shell/extensions/drop-down-terminal@gs-extensions.zzrough.org
	gsettings --schemadir . set org.zzrough.gs-extensions.drop-down-terminal transparency-level $1
	cd $p
}

get_currrent_ip_function () {
	echo "# ----------------------------------------------------------"
	echo "# Command run : host myip.opendns.com resolver1.opendns.com"
	echo "# ----------------------------------------------------------"
	host myip.opendns.com resolver1.opendns.com
	echo "# ----------------------------------------------------------"
	echo "# Command run : curl ifconfig.me"
	echo "# ----------------------------------------------------------"
	curl ifconfig.me
}

terraform_console () {
	export PREVIOUS_PATH=`pwd`
	cd /tmp
	tee /tmp/playground.tf << EOF
terraform {
  # Set version for terraform
  required_version = "~> 1.0"
  # Set version for providers
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
provider "aws" {
  region = "eu-west-3"
  default_tags {
    tags = {
      Environment = "production"
      Owner       = "administrator"
    }
  }
}
resource "aws_instance" "test" {
  ami           = "ami-005e54dee72cc1d00"
  instance_type = "t3.micro"
  tags = {
    Owner = "Coucou"
  }
}
locals {
  example = { "bonjour" = "terraform" }
}
# example à lancer en console : > local.example.bonjour
EOF
	code -r /tmp/playground.tf
	terraform init
	terraform console
}

get_folder_size_function () {
	if [ -n "$1" ] ; then
		# If one arguement had been given
		du -h --max-depth=1 $1
	else
		echo "ERROR : You need to specify the path to the folder to calculate its size"
	fi
}

#===================================================
# Aliases
#===================================================

#----------------------
# files
#----------------------
alias open="code -r $1"

#----------------------
# zsh
#----------------------
alias zshedit="vim $HOME/.zshrc ; source $HOME/.zshrc"
alias rl="cd ; source ~/.zshrc ; cd -"

#----------------------
# network
#----------------------
alias whatismyip="get_currrent_ip_function"
alias lnetwork='sudo cat "$(sudo ls -rt -d -1 /etc/NetworkManager/system-connections/* | grep `iwgetid -r`)"'

#----------------------
# git
#----------------------
alias gad="git add -p"
alias gcm="git commit -m"
alias gh="git diff HEAD"
alias gitaliases="cat ~/.oh-my-zsh/plugins/git/git.plugin.zsh"
alias precommitrunall="pre-commit run --all"
alias git_remove_gone_branches='git fetch -p && for branch in $(git for-each-ref --format "%(refname) %(upstream:track)" refs/heads | awk "$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}"); do git branch -d $branch; done'
alias gstac="git stash"
alias gstap="git stash apply"
alias grset="commit_hash=`git log --oneline | sed -n 2p | awk '{ print $1 }'` && git reset $commit_hash"
alias gada_precommitrunall="git add -A && pre-commit run --all"

#----------------------
# apt
#----------------------
alias fullupdate="sudo apt update && sudo apt upgrade -y"

#----------------------
# dropdown terminal settings
#----------------------
alias ddttransparency=dropdown_terminal_set_transparency_function
alias ddtheight=dropdown_terminal_set_height_function

#----------------------
# apt
#----------------------
alias fullupdate="sudo apt update && sudo apt upgrade -y"

#----------------------
# aws cli
#----------------------
alias aws_sts_get_caller_identity='aws sts get-caller-identity'
alias aws_get_account_alias='aws iam list-account-aliases'

#----------------------
# terraform
#----------------------
alias tfmt="terraform fmt --recursive"

#----------------------
# Kubernetes
#----------------------
alias k="kubectl"
