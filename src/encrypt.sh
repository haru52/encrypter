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
  echo "Usage:"
  echo "$ encrypt [file or directory path] [recipient]"
  echo "$ encrypt pub [file or directory path] [recipient]"
  echo "$ encrypt sym [file or directory path]"
  exit 1
}

validate_path () {
  _path=$1
  # Check for path traversal attempts - only match actual path traversal patterns
  case "${_path}" in
    ../*|*/../*|*/..|\.\.)
      error "Path traversal detected. Path must not contain directory traversal sequences."
      ;;
    */*)
      # Path contains directory separators - validate it resolves within current directory or subdirectories
      _path_dir=$(dirname "${_path}") || true
      _path_base=$(basename "${_path}") || true
      if ! _resolved_dir=$(cd "${_path_dir}" 2>/dev/null && pwd -P); then
        error "Cannot resolve path directory: ${_path_dir}"
      fi
      _resolved_path="${_resolved_dir}/${_path_base}"
      _current_dir=$(pwd -P) || error "Cannot get current directory"
      case "${_resolved_path}" in
        "${_current_dir}"*|"${_current_dir}")
          ;;
        *)
          error "Path must be within the current directory or its subdirectories."
          ;;
      esac
      ;;
    *)
      # Path without directory separators, acceptable
      ;;
  esac
}

validate_recipient () {
  _recipient=$1
  # Check for dangerous characters that could lead to command injection
  case "${_recipient}" in
    *[\;\&\|\$\`\\]*|*[\(\)]*|*[\<\>]*)
      error "Invalid characters in recipient. Recipient must not contain: ; & | \$ \` \\ ( ) < >"
      ;;
    "")
      error "Recipient cannot be empty."
      ;;
    *)
      # Valid recipient
      ;;
  esac
}

archive_with_tar_gzip () {
  _archived_target_path=$1
  _target_path=$2
  tar -czf "${_archived_target_path}" "${_target_path}"
}

encrypt_with_gpg () {
  _recipient=$1
  _target_path=$2
  gpg -e -r "${_recipient}" "${_target_path}"
}

encrypt_with_aes256 () {
  _target_path=$1
  gpg -c --cipher-algo AES256 --no-symkey-cache "${_target_path}"
}

if [ $# -ne 2 ] && [ $# -ne 3 ]; then
  error_with_help "Incorrect number of arguments."
fi

if [ "$1" != "pub" ] && [ "$1" != "sym" ] ; then
  crypto_type="pub"
else
  crypto_type="$1"
fi

case ${crypto_type} in
  "pub")
    case $# in
      2)
        target_path=$1
        recipient=$2
        ;;
      3)
        target_path=$2
        recipient=$3
        ;;
      *)
        error_with_help "Incorrect number of arguments."
        ;;
    esac
    ;;
  "sym")
    target_path=$2
    ;;
  *)
    error_with_help "Invalid cryptographic mode command."
    ;;
esac

if [ ! -e "${target_path}" ]; then
  error_with_help "Specified file or directory does not exist."
fi

# Validate path to prevent path traversal
validate_path "${target_path}"

# Validate recipient for public key encryption
if [ "${crypto_type}" = "pub" ]; then
  validate_recipient "${recipient}"
fi

case ${crypto_type} in
  "pub")
    if [ -d "${target_path}" ]; then
      archived_target_path=${target_path}.tar.gz
      if ! archive_with_tar_gzip "${archived_target_path}" "${target_path}"; then
        error "Archive failed."
      fi

      if ! encrypt_with_gpg "${recipient}" "${archived_target_path}"; then
        rm -f "${archived_target_path}"
        error "Encryption failed."
      fi

      rm -f "${archived_target_path}"
    else
      if ! encrypt_with_gpg "${recipient}" "${target_path}"; then
        error "Encryption failed."
      fi
    fi
    ;;
  "sym")
    if [ -d "${target_path}" ]; then
      archived_target_path=${target_path}.tar.gz
      if ! archive_with_tar_gzip "${archived_target_path}" "${target_path}"; then
        error "Archive failed."
      fi

      if ! encrypt_with_aes256 "${archived_target_path}"; then
        rm -f "${archived_target_path}"
        error "Encryption failed."
      fi

      rm -f "${archived_target_path}"
    else
      if ! encrypt_with_aes256 "${target_path}"; then
        error "Encryption failed."
      fi
    fi
    ;;
  *)
    error_with_help "Invalid cryptographic mode command."
    ;;
esac
