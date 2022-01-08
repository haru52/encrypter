# Encrypter

## Overview

Encrypter is the encryption UNIX/Linux CLI command. Encrypter can encrypt a file or a directory. Of course Encrypter can also decrypt a file or a directory that encrypted by Encrypter!

Encrypter depends on [GnuPG (GPG)](https://gnupg.org/). If you are not familiar with GPG, I recommend to read the followig GitHub Docs: [Managing commit signature verification - GitHub Docs](https://docs.github.com/en/authentication/managing-commit-signature-verification).

## Requirement

- UNIX/Linux (includes WSL and macOS)
- tar
- GPG

## Installation

```console
git clone git@github.com:haru52/encrypter.git
cd encrypter
make install
```

## Usage

### Public key encryption

```console
encrypt [file or directory path] [recipient]
```

Alternatively, you can specify the cryptographic mode explicitly. The following command outputs the same result as the previous command.

```console
encrypt pub [file or directory path] [recipient]
```

For example, you can use either the recipient's email address or the GPG key ID as the value of `[recipient]`. Please see [GPG documents](https://www.gnupg.org/documentation/index.html) for details.

### Symmetric key encryption

```console
encrypt sym [file or directory path]
# Enter password.
```

### Public key decryption

```console
decrypt [file or directory path]
# Enter your private key passphrase.
```

### Symmetric key decryption

```console
decrypt [file or directory path]
# Enter password.
```

### Caution

DON'T change the extension of the encrypted file name! (`.gpg` or `.tar.gpg`)

## Update

```console
# Move to the encrypter local repository directory.
git pull
```

## Algorithm

| Type | Algorithm |
|-|-|
| public key cryptosystem | depends on the recipient's GPG key (e.g., RSA) |
| symmetric key cryptosystem | AES256 |
| archive/extraction | tar |

## License

[MIT License](LICENSE)

## Author

[haru](https://haru52.com/)
