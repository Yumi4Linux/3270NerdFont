# Quick installer for NerdFont files

Quick install (download and run the installer script).

Safer method — download the installer first, verify if you want, then run it:

## Using curl
```bash
curl -fsSL -o install.sh https://raw.githubusercontent.com/yumi4game/NerdFont/main/install.sh
bash install.sh -n
```

## Or using wget
```bash
wget -O install.sh https://raw.githubusercontent.com/yumi4game/NerdFont/main/install.sh
bash install.sh -n
```

Note: piping a remote script directly into `bash` (e.g. `curl ... | bash`) can fail or be unsafe
in some environments. In particular, some older versions of the installer relied on
`BASH_SOURCE[0]`, which is undefined when the script is executed from a pipe and causes an error
like: `BASH_SOURCE[0]: unbound variable`.

If you have cloned this repository, run the local script instead to avoid that issue:

```bash
cd ~/Documents/NerdFont
./install.sh -n
```

This script downloads specified font files from the repository raw URL and installs them into a user font directory.

File: `install.sh` (also available at https://raw.githubusercontent.com/yumi4game/NerdFont/main/install.sh)

Features:
- Downloads font files from the project's `fonts/` directory on GitHub.
- Installs them into `~/.fonts/NerdFont/` by default (changeable with -t).
- Updates the font cache using `fc-cache`.
- Supports dry-run (`-n`) and force overwrite (`-f`).

Example: download specific fonts from the repo and install

```
install.sh 3270NerdFont-Condensed.ttf 3270NerdFont-Regular.ttf
```

If you run `install.sh` without arguments, the script will look into the local `fonts/` directory
next to the script and download the same filenames from the remote repository automatically.

