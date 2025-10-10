# Quick installer for 3270NerdFont fonts

<img width="300" height="120" alt="image" src="https://github.com/user-attachments/assets/f9cf19ac-e35c-4510-ab67-023bb5f304b6" /> <img width="300" height="120" alt="image" src="https://github.com/user-attachments/assets/2710c436-5495-42a9-a580-ec8396b496a2" />


Quick install (download and run the installer script).

Safer method — download the installer first, verify if you want, then run it:

## Using curl
```bash
curl -fsSL https://raw.githubusercontent.com/yumi4game/3270NerdFont/main/install.sh | bash -s --
```

## Or using wget
```bash
wget -qO- https://raw.githubusercontent.com/yumi4game/3270NerdFont/main/install.sh | bash -s --
```

## Install for all users
```bash
sudo cp -R ~/.fonts/3270NerdFont /usr/share/fonts && fc-cache -v
```

If you have cloned this repository, run the local script instead to avoid that issue:

```bash
git clone https://github.com/yumi4game/3270NerdFont.git
cd ./3270NerdFont
./install.sh -n
./install.sh
```

This script downloads specified font files from the repository raw URL and installs them into a user font directory.

File: `install.sh` (also available at https://raw.githubusercontent.com/yumi4game/3270NerdFont/main/install.sh)

Features:
- Downloads font files from GitHub repository.
- Installs them into `~/.fonts/3270NerdFont/` by default (changeable with -t).
- Updates the font cache using `fc-cache`.
- Supports dry-run (`-n`) and force overwrite (`-f`).

If you run `install.sh` without arguments, the script will look into the local `fonts/` directory
next to the script and download the same filenames from the remote repository automatically.

