
# Defines environment variables.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

# custom
source "$HOME/.zsh/custom/rbenv"
source "$HOME/.zsh/custom/phpenv"
source "$HOME/.zsh/custom/nodebrew"
source "$HOME/.zsh/custom/composer"
source "$HOME/.zsh/custom/go"
