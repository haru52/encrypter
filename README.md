# Encrypter

## Overview

Encrypter is the encryption UNIX/Linux CLI command. Encrypter can encrypt a file or a directory. Of course Encrypter can also decrypt a file or a directory that encrypted by Encrypter!

## Requirement

- UNIX/Linux (includes WSL and macOS)
- tar
- [GnuPG (GPG)](https://gnupg.org/)

## Installation

```console
git clone git@github.com:haru52/encrypter.git
cd encrypter
make install
```

## Usage

  echo "       $ encrypt [file or directory path] [recipient]"
  echo "       $ encrypt pub [file or directory path] [recipient]"
  echo "       $ encrypt sym [file or directory path]"

### Public key encryption

```console
encrypt [file or directory path] [recipient]
```

Alternatively, you can also specify the cryptographic mode command explicitly.

```console
encrypt pub [file or directory path] [recipient]
```

For example, you can use either the recipient's email address or the GPG key ID as the value of `[recipient]`. Please see [GPG documents](https://www.gnupg.org/documentation/index.html) for details.

### Public key decryption

```console
decrypt [file or directory path]
# Enter your private key passphrase.
```

Of course, you can use the following command!

```console
decrypt pub [file or directory path]
# Enter your private key passphrase.
```

### Symmetric key encryption

```console
encrypt sym [file or directory path]
# Enter password.
```

### Symmetric key decryption

```console
decrypt sym [file or directory path]
# Enter password.
```

## Algorithm

| Type | Algorithm |
|-|-|
| public key cryptosystem | depends on the recipient's GPG key |
| symmetric key cryptosystem | AES256 |
| archive/extraction | tar |
| compression/decompression | gzip |

## License

[MIT License](LICENSE)

## Author

[haru](https://haru52.com/)
