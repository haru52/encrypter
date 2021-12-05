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

### Encryption

```console
encrypt [file or directory path]
# Enter password.
```

### Decryption

```console
decrypt [file or directory path]
# Enter password.
```

## Algorithm

| Type | Algorithm |
|-|-|
| encryption/decryption | AES256 |
| archive/extraction | tar |
| compression/decompression | gzip |

## License

[MIT License](LICENSE)

## Author

[haru](https://haru52.com/)
