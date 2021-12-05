#!/bin/sh

print_error_msg () {
  error_msg=$1
  echo "Error!: $error_msg"
}

error () {
  error_msg=$1
  print_error_msg "$error_msg"
  exit 1
}

error_with_help () {
  error_msg=$1
  print_error_msg "$error_msg"
  echo "Usage: $ encrypt [file or directory path]"
  exit 1
}

encrypt_with_aes256 () {
  encrypt_target_path=$1
  gpg -c --cipher-algo AES256 --no-symkey-cach $encrypt_target_path
}

if [ $# -ne 1 ]; then
  error_with_help "Incorrect number of arguments."
fi

target_path=$1

if [ ! -e $target_path ]; then
  error_with_help "Specified file or directory does not exist."
fi

if [ -d $target_path ]; then
  archived_target_path=$target_path.tar.gz
  tar cf $archived_target_path $target_path

  if [ $? -ne 0 ]; then
    error "Archive failed."
  fi

  encrypt_with_aes256 $archived_target_path

  if [ $? -ne 0 ]; then
    rm -f $archived_target_path
    error "Encryption failed."
  fi

  rm -f $archived_target_path
  rm -rf $target_path
else
  encrypt_with_aes256 $target_path

  if [ $? -ne 0 ]; then
    error "Encryption failed."
  fi

  rm -f $target_path
fi
