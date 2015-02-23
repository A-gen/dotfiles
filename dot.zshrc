#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Aliases
#  Git
alias g='git'
alias ga='git add'
alias gs='git status'
alias gd='git diff'
if type peco >/dev/null 2>&1; then
  alias -g B='`git branch -a | peco --prompt "GIT BRANCH>" | head -n 1 | sed -e "s/^\*\s*//g"`'
  alias -g R='`git remote | peco --prompt "GIT REMOTE>" | head -n 1`'
  alias -g H='`curl -sL https://api.github.com/users/A-gen/repos | jq -r ".[].full_name" | peco --prompt "GITHUB REPOS>" | head -n 1`'
fi
