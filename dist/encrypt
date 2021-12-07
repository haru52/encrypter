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
  raw_target_path=$1
  gpg -c --cipher-algo AES256 --no-symkey-cach $raw_target_path

  # # encrypt with OpenSSL
  # raw_target_path=$1
  # encrypted_target_path="$raw_target_path.enc"
  # openssl aes-256-cbc -e -in $raw_target_path -out $encrypted_target_path
}

if [ $# -ne 2 ] && [ $# -ne 3 ]; then
  error_with_help "Incorrect number of arguments."
fi

if [ $1 != "pub" ] && [ $1 != "sym" ] ; then
  crypto_type="pub"
else
  crypto_type=$1
fi

case $crypto_type in
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
    error_with_help "Invalid cryptographic mode command."
    ;;
esac

if [ ! -e $target_path ]; then
  error_with_help "Specified file or directory does not exist."
fi

case $crypto_type in
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
    if [ -d $target_path ]; then
      archived_target_path=$target_path.tar.gz
      tar -zcf $archived_target_path $target_path

      if [ $? -ne 0 ]; then
        error "Archive failed."
      fi

      encrypt_with_aes256 $archived_target_path

      if [ $? -ne 0 ]; then
        rm -f $archived_target_path
        error "Encryption failed."
      fi

      rm -f $archived_target_path
    else
      encrypt_with_aes256 $target_path

      if [ $? -ne 0 ]; then
        error "Encryption failed."
      fi
    fi
    ;;
esac
