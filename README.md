# static-cutechess-cli
[![linux](https://github.com/ppigazzini/static-cutechess-cli/actions/workflows/linux.yml/badge.svg)](https://github.com/ppigazzini/static-cutechess-cli/actions/workflows/linux.yml)
[![arm](https://github.com/ppigazzini/static-cutechess-cli/actions/workflows/arm.yml/badge.svg)](https://github.com/ppigazzini/static-cutechess-cli/actions/workflows/arm.yml)
[![macos](https://github.com/ppigazzini/static-cutechess-cli/actions/workflows/macos.yml/badge.svg)](https://github.com/ppigazzini/static-cutechess-cli/actions/workflows/macos.yml)
[![windows](https://github.com/ppigazzini/static-cutechess-cli/actions/workflows/windows.yml/badge.svg)](https://github.com/ppigazzini/static-cutechess-cli/actions/workflows/windows.yml)

Scripts and GitHub workflows to build the static version of [cutechess-cli](https://github.com/cutechess/cutechess)

## Supported Platforms
| Operating System | CPU | Workflow |
| --- | --- | --- |
| Linux | x86_64, x86_32 | linux |
| Linux | aarch64, armv7 | arm |
| macOS | x86_64, arm64 | macos |
| Windows: WSL | x86_64 | linux |
| Windows: MSYS2, Cygwin | x86_64, x86_32 | windows |
| Windows | x86_64, x86_32 | windows |

## License

This repository is dual-licensed on a per-file basis:

- Files originating from the Cutechess project are licensed under **GPL-3.0** (see `COPYING`), per the upstream project's license.
- All other files in this repository are licensed under the **Blue Oak Model License 1.0.0** (see `LICENSE`).
