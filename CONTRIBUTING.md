# Contributing Guideline

## Requirements

|                            Tool                             | Version |
| ----------------------------------------------------------- | ------- |
| [gibo](https://github.com/simonwhitaker/gibo#readme)        | ^3.0.14 |
| [ShellCheck](https://github.com/koalaman/shellcheck#readme) | ^0.11.0 |

## Rules

|        Category        |                                                                    Rule                                                                    |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Git commit             | [Conventional Commits v1.0.0](https://www.conventionalcommits.org/en/v1.0.0/)                                                              |
|                        | [@commitlint/config-conventional](https://github.com/conventional-changelog/commitlint/tree/master/@commitlint/config-conventional#readme) |
| Git branching strategy | [GitHub flow](https://docs.github.com/en/get-started/quickstart/github-flow)                                                               |
| Versioning             | [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html)                                                                           |
| GitHub PR title        | Same as the commit message rule                                                                                                            |

## Development flow

1. Fork this repo
2. Develop and create a Pull Request (PR) according to [the preceding rules](#rules)
3. This repo maintainers will review the PR
4. The maintainers will merge the PR branch if they approved it, otherwise they will close it without merging

## Shell script coding standards

<!-- vale Microsoft.Foreign = NO -->

- Naming conventions
  - File names: kebab-case.sh
  - Variable names, etc.: snake_case
- Language for comments, etc.: English
- Max characters per line (half-width): 100
- Indentation: 2 spaces
- ShellCheck compliant (no errors or warnings should appear when running the `shellcheck` command)
- shebang
  - Use `#!/bin/sh` as a general rule
  - If specific shell features become absolutely necessary, use `#!/usr/bin/env bash` or similar (e.g., when depending on bash)

<!-- vale Microsoft.Foreign = YES -->
