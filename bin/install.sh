#!/bin/sh

current_dir="$(pwd)"

mkdir -p ~/bin
ln -sfv "${current_dir}"/src/encrypt.sh ~/bin/encrypt
ln -sfv "${current_dir}"/src/decrypt.sh ~/bin/decrypt

case ":${PATH}:" in
  *":${HOME}/bin:"*)
    exit 0
    ;;
  *)
    ;;
esac

shell_name="$(basename "${SHELL}")"

case ${shell_name} in
  "bash")
    shell_rc_path="${HOME}/.bashrc"
    ;;
  "zsh")
    shell_rc_path="${HOME}/.zshrc"
    ;;
  *)
    shell_rc_path="${HOME}/.bashrc"
    ;;
esac

echo "export PATH=\$HOME/bin:\$PATH" >> "${shell_rc_path}"
