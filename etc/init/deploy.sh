#!/bin/bash

CUR=$(cd $(dirname $0); pwd)
DOTROOT=$(cd $CUR/../..; pwd)

symlink() {
  src=$1
  dst=$2

  echo " => make symlink ${src} to ${dst}"

  # Create symbolic link
  rm ${dst} 2>/dev/null
  ln -s ${src} ${dst}
}

echo "Deploy dotfiles..."

# vim
echo
echo "vim and some"
symlink $DOTROOT/dotdirs/dot.vim ${HOME}/.vim
symlink $DOTROOT/dot.vimrc       ${HOME}/.vimrc

# zsh
echo
echo "zsh and some"
symlink $DOTROOT/dotdirs/dot.zsh ${HOME}/.zsh
symlink $HOME/.zsh/prezto        ${HOME}/.zprezto
symlink $DOTROOT/dot.zlogin      ${HOME}/.zlogin
symlink $DOTROOT/dot.zlogout     ${HOME}/.zlogout
symlink $DOTROOT/dot.zpreztorc   ${HOME}/.zpreztorc
symlink $DOTROOT/dot.zprofile    ${HOME}/.zprofile
symlink $DOTROOT/dot.zshenv      ${HOME}/.zshenv
symlink $DOTROOT/dot.zshrc       ${HOME}/.zshrc

# tmux
echo "tmux and some"
symlink $DOTROOT/dotdirs/dot.tmux     ${HOME}/.tmux
symlink $DOTROOT/dot.tmux.conf        ${HOME}/.tmux.conf
symlink $DOTROOT/dot.tmux-powerlinerc ${HOME}/.tmux-powerlinerc

# Others
echo
echo "others"
symlink $DOTROOT/dot.gitconfig   ${HOME}/.gitconfig

echo "Deploy finished"
