---
title: Download
description: Get ZapFast for macOS.
nav_order: 1
---

{% assign v = site.zapfast_version %}
{% assign name = site.release_asset_prefix %}
{% assign app = site.release_app_name %}
{% assign base = "https://github.com/crmne/zapfast/releases/download/v" | append: v %}

ZapFast was previously called FastsApp. Version 0.13.0 introduces the new
package and executable names. Your existing session and local data move
automatically when you first start ZapFast; quit FastsApp before upgrading.

The current version is **v{{ v }}**. SHA-256 checksums are in
[checksums.txt]({{ base }}/checksums.txt). Older versions are on the
[releases page](https://github.com/crmne/zapfast/releases).

ZapFast is a Mac app. One download for both Apple Silicon and Intel:

- [{{ name }}-v{{ v }}-macos-universal.dmg]({{ base }}/{{ name }}-v{{ v }}-macos-universal.dmg)

Open it and drag **{{ app }}** to Applications.

If you use [Homebrew](https://brew.sh), you can install it with:

```sh
brew install --cask crmne/tap/zapfast
```

The app is signed with Developer ID and notarized by Apple. The DMG includes
a validated notarization ticket.

When upgrading from FastsApp, remove the old FastsApp application bundle
after installing ZapFast.
