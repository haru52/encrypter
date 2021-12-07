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
  echo "Usage:"
  echo "       $ encrypt [file or directory path] [recipient]"
  echo "       $ encrypt pub [file or directory path] [recipient]"
  echo "       $ encrypt sym [file or directory path]"
  exit 1
}

encrypt_with_aes256 () {
  encrypt_target_path=$1
  gpg -c --cipher-algo AES256 --no-symkey-cach $encrypt_target_path
}

if [ $# -ne 2 ] || [ $# -ne 3 ]; then
  error_with_help "Incorrect number of arguments."
fi

if [ $1 != "pub" ] && [ $1 != "sym" ] ; then
  enc_type="pub"
else
  enc_type=$1
fi

case $enc_type in
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
    esac
    ;;
  "sym")
    target_path=$2
    ;;
  *)
    error_with_help "Invalid encryption type."
    ;;
esac

if [ ! -e $target_path ]; then
  error_with_help "Specified file or directory does not exist."
fi

case $enc_type in
  "pub")
    encrypted_target_path="$target_path.gpg"
    if [ -d $target_path ]; then
      gpgtar -e -r $recipient -o $encrypted_target_path $target_path
    else
      gpg -e -r $recipient -o $encrypted_target_path $target_path
    fi

    if [ $? -ne 0 ]; then
      error "Encryption failed."
    fi
    ;;
  "sym")
    # TODO: OpenSSLを用いて共通鍵暗号化
    error_with_help "Sorry, sym command is not supported yet."
    ;;
esac
