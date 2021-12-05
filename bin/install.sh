#!/bin/sh

mkdir -p ~/bin
ln -sf `pwd`/dist/encrypt ~/bin/encrypt
ln -sf `pwd`/dist/decrypt ~/bin/decrypt

if [ ! `echo $PATH | grep -e "$HOME/bin:" -e ":$HOME/bin"` ]; then
  exit 0
fi

shell_name=`basename $SHELL`

case $shell_name in
  "bash")
    shell_rc_path="$HOME/.bashrc"
    ;;
  "zsh")
    shell_rc_path="$HOME/.zshrc"
    ;;
  *)
    shell_rc_path="$HOME/.bashrc"
    ;;
esac

echo "export PATH=\$HOME/bin:\$PATH" >> $shell_rc_path
