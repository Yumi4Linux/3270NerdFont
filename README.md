# Quick installer for NerdFont files

Quick install (download and run the installer script):

```bash
# Using curl
curl -fsSL https://raw.githubusercontent.com/yumi4game/NerdFont/main/install.sh | bash -s -- -n

# Or using wget
wget -qO- https://raw.githubusercontent.com/yumi4game/NerdFont/main/install.sh | bash -s -- -n
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

