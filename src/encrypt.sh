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

if [ $# != "1" ]; then
  error_with_help "Incorrect number of arguments."
fi

target_path=$1

if [ ! -e $target_path ]; then
  error_with_help "Specified file or directory doesn't exist."
fi

if [ -d $target_path ]; then
  new_target_path=$target_path.tar.gz
  tar cf $new_target_path $target_path
  rm -rf $target_path
  target_path=$new_target_path
fi

gpg -c --cipher-algo AES256 --no-symkey-cach $target_path
rm -f $target_path
