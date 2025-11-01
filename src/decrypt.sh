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

validate_tar_archive () {
  _archive_path=$1
  # Check for Zip Slip vulnerability by validating tar archive contents
  if ! _tar_contents=$(tar -tf "${_archive_path}" 2>/dev/null); then
    error "Failed to read tar archive contents."
  fi

  # Check each file in the archive for dangerous paths
  # Using a while loop without pipe to avoid subshell issues
  while IFS= read -r _file; do
    case "${_file}" in
      */../*|../*|*/..|\.\.)
        error "Dangerous path detected in archive: ${_file}. Archive contains path traversal attempts."
        ;;
      /*)
        error "Absolute path detected in archive: ${_file}. Archive must contain only relative paths."
        ;;
      *)
        # Valid path, continue
        ;;
    esac
  done <<EOF
${_tar_contents}
EOF
}

if [ $# -ne 1 ]; then
  error_with_help "Incorrect number of arguments."
fi

target_path=$1

if [ ! -e "${target_path}" ]; then
  error_with_help "Specified file or directory does not exist."
fi

# Validate path to prevent path traversal
validate_path "${target_path}"

if [ "${target_path##*.}" != "gpg" ]; then
  error_with_help "Unsupported file format."
fi

# Use parameter expansion instead of sed for better security
decrypted_target_path="${target_path%.gpg}"

# Check if decrypted file already exists to prevent overwrite
if [ -e "${decrypted_target_path}" ]; then
  error "Decrypted file '${decrypted_target_path}' already exists. Please remove it first or rename the encrypted file."
fi

if ! gpg -o "${decrypted_target_path}" -d "${target_path}"; then
  error "Decryption failed."
fi

case ${decrypted_target_path} in
  *\.tar.gz|*\.tar)
    # Validate tar archive before extraction to prevent Zip Slip vulnerability
    validate_tar_archive "${decrypted_target_path}"

    if [ "${decrypted_target_path}" != "${decrypted_target_path%.tar.gz}" ]; then
      # tar.gz file
      if ! tar -xzf "${decrypted_target_path}"; then
        rm -f "${decrypted_target_path}"
        error "Extraction failed."
      fi
    else
      # tar file
      if ! tar -xf "${decrypted_target_path}"; then
        rm -f "${decrypted_target_path}"
        error "Extraction failed."
      fi
    fi

    rm -f "${decrypted_target_path}"
    ;;
  *)
    ;;
esac
