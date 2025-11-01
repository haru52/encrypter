#!/bin/sh

print_error_msg () {
  _error_msg=$1
  echo "Error!: ${_error_msg}"
}

error () {
  _error_msg=$1
  print_error_msg "${_error_msg}"
  exit 1
}

error_with_help () {
  _error_msg=$1
  print_error_msg "${_error_msg}"
  echo "Usage: $ decrypt [file or directory path]"
  exit 1
}

if [ $# -ne 1 ]; then
  error_with_help "Incorrect number of arguments."
fi

target_path=$1

if [ ! -e "${target_path}" ]; then
  error_with_help "Specified file or directory does not exist."
fi

if [ "${target_path##*.}" != "gpg" ]; then
  error_with_help "Unsupported file format."
fi

decrypted_target_path=$(echo "${target_path}" | sed 's/\.gpg$//')
if ! gpg -o "${decrypted_target_path}" -d "${target_path}"; then
  error "Decryption failed."
fi

case ${decrypted_target_path} in
  *\.tar)
    if ! tar -xf "${decrypted_target_path}"; then
      rm -f "${decrypted_target_path}"
      error "Extraction failed."
    fi

    rm -f "${decrypted_target_path}"
    ;;
  *)
    ;;
esac
