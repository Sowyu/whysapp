---
title: Release packaging
description: Shared packaging automation and application-specific release definitions.
nav_order: 20
---

ZapFast ships for macOS only. It keeps release asset definitions and the
Homebrew cask template in `native-packages.yaml` and `packaging/`. Common automation comes from the pinned
[native-packages](https://github.com/crmne/native-packages) gem, installed with `gem install native-packages --version 0.5.1`.

Stable releases build the universal macOS DMG first. The shared packaging
workflow then verifies published checksums and updates the Homebrew cask.

Native bundle contents, signing and installer settings remain application-specific.
See the repository's [maintainer packaging guide](https://github.com/crmne/zapfast/blob/main/PACKAGING.md)
for commands and the shared tool's [platform coverage](https://github.com/crmne/native-packages/blob/main/docs/platforms.md)
for the boundaries.

macOS release builds use `native-packages.macos.yaml`. Complete Apple CI secrets
enable shared signing, notarization and ticket validation automatically before
checksums are written. Earlier downloads retain their original signing status.
