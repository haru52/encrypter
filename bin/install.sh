#!/bin/sh

current_dir="$(pwd)"

mkdir -p ~/bin
ln -sf "${current_dir}"/src/encrypt.sh ~/bin/encrypt
ln -sf "${current_dir}"/src/decrypt.sh ~/bin/decrypt

if echo "${PATH}" | grep -q -e "${HOME}/bin:" -e ":${HOME}/bin"; then
  exit 0
fi

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
