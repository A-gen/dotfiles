source ~/.zplug/init.zsh

zplug "peco/peco",   as:command, from:gh-r
zplug "motemen/ghq", as:command, from:gh-r
zplug "stedolan/jq", as:command, from:gh-r, rename-to:jq
zplug 'joel-porquet/zsh-dircolors-solarized'
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting"

zplug "themes/robbyrussell", from:oh-my-zsh

if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi
zplug load

setupsolarized dircolors.ansi-light

setopt hist_ignore_all_dups

if zplug check peco/peco; then

  function peco_select_history() {
    local tac
    if which tac > /dev/null; then
      tac="tac"
    else
      tac="tail -r"
    fi
    BUFFER=$(fc -l -n 1 | eval $tac | peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
  }
  zle -N peco_select_history
  bindkey '^r' peco_select_history

  if zplug check motemen/ghq; then
    function peco-src () {
      local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
      if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
      fi
      zle clear-screen
    }
    zle -N peco-src
    bindkey '^]' peco-src
  fi

fi

export HISTFILE=${HOME}/.zsh_history
export HIST_STAMPS="yyyy-mm-dd"
export SAVEHIST=10000000
export HISTSIZE=$SAVEHIST
export TERM=xterm-256color
setopt share_history

#autoload -U compinit
#compinit
zstyle ':completion:*:default' menu select=2

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*:options' description 'yes'

zstyle ':completion:*' group-name ''

alias ls='ls --color=auto -F'

alias g='git'
alias gst='git status'
alias ga='git add'
alias gci='git ci'
alias glg='git lg'

if (which zprof > /dev/null 2>&1) ;then
  zprof
fi
