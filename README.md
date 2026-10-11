# Macbar

A Dynamic Island–style control center for the Mac menu bar. Free.

This repository holds **Macbar releases only**. Download the latest `.dmg` from
[Releases](https://github.com/rahulornob/macbar-releases/releases/latest).

## Install

**Easiest: one line, no security prompts.** Open **Terminal** (press ⌘ Space, type
Terminal, press Return), paste this and press Return:

```sh
curl -fsSL https://raw.githubusercontent.com/rahulornob/macbar-releases/main/install.sh | bash
```

It downloads the latest Macbar, checks it is signed by Macbar, installs it into
Applications and opens it. Run the same line again any time to reinstall.

**Or with the disk image:**

1. Open the `.dmg` and drag **Macbar** into **Applications**.
2. Open Macbar. macOS says it is from an unidentified developer, because Macbar
   is free and not notarized by Apple.
3. Open **System Settings → Privacy & Security**, scroll down and click
   **Open Anyway** next to Macbar. You only do this once.

On first launch Macbar shows a short setup that asks for every permission its
features use, all in one place. Right-click the island and choose
**Permissions…** to see it again.

## Updates

Macbar updates itself. It checks for new versions every hour and installs one
when you step away from your Mac for a couple of minutes, then reopens. To choose
when to update instead, right-click the island and turn off
**Install Updates Automatically**; **Check for Updates…** is in the same menu.

Every update is checked against Macbar's signing certificate before it installs,
so only genuine Macbar releases are ever installed.

## Requirements

macOS 14 Sonoma or later.

## License

Macbar includes software licensed under the GNU GPL v3.0, including code from
Vorssaint and [Mole](https://github.com/tw93/Mole). The complete source code is
available on request: open an issue in this repository.
