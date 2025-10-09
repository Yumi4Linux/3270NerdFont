#!/usr/bin/env bash
# install.sh — quick installer that downloads NerdFont files and installs them to ~/.fonts/NerdFont
set -euo pipefail

# Default installation directory
ROOT_DIR="$HOME/.fonts/NerdFont"

# Default base URL to download fonts from (as requested)
BASE_URL="https://raw.githubusercontent.com/yumi4game/NerdFont/refs/heads/main/fonts"

show_help(){
  cat <<EOF
Usage: install.sh [options] [font-file ...]

Downloads font files from the repository raw URL and installs them into ${ROOT_DIR} by default.

If no font filenames are provided, the script will use files present in the local "fonts/" directory
next to this script and download those same filenames from the remote BASE_URL.

Options:
  -b URL   Use a different base URL for downloads (default: ${BASE_URL})
  -t DIR   Install into DIR instead of ${ROOT_DIR}
  -f       Force overwrite existing files
  -n       Dry-run (show actions without performing downloads)
  -h       Show this help

Examples:
  # Download specific files (by basename) from the repo and install them
  install.sh 3270NerdFont-Condensed.ttf 3270NerdFont-Regular.ttf

  # Use a custom install directory
  install.sh -t ~/.local/share/fonts 3270NerdFont-*.ttf

  # Dry-run using all filenames found in local ./fonts/ directory
  install.sh -n
EOF
}

DRY_RUN=0
FORCE=0

while getopts ":b:t:fnh" opt; do
  case ${opt} in
    b) BASE_URL="$OPTARG" ;;
    t) ROOT_DIR="$OPTARG" ;;
    f) FORCE=1 ;;
    n) DRY_RUN=1 ;;
    h) show_help; exit 0 ;;
    \?) echo "Unknown option: -$OPTARG" >&2; show_help; exit 2 ;;
  esac
done
shift $((OPTIND-1))

# Determine script directory to find local fonts/ if needed
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_FONTS_DIR="$SCRIPT_DIR/fonts"

# If no filenames provided, try to use local fonts/ directory names
if [ "$#" -eq 0 ]; then
  if [ -d "$LOCAL_FONTS_DIR" ]; then
    # collect ttf/otf files from local fonts dir safely (avoid literal globs)
    pushd "$LOCAL_FONTS_DIR" >/dev/null
    # enable nullglob so unmatched globs expand to nothing
    shopt -s nullglob
    local_files=( *.ttf *.otf )
    shopt -u nullglob
    popd >/dev/null

    if [ "${#local_files[@]}" -eq 0 ]; then
      echo "No local font files found in $LOCAL_FONTS_DIR and no filenames provided." >&2
      exit 2
    fi
    # copy basenames
    FILENAMES=("${local_files[@]}")
  else
    echo "No filenames provided and local fonts directory not found: $LOCAL_FONTS_DIR" >&2
    exit 2
  fi
else
  FILENAMES=("$@")
fi

mkdir -p "$ROOT_DIR"

download_cmds=()
for name in "${FILENAMES[@]}"; do
  # skip empty names
  [ -z "$name" ] && continue
  # construct remote url and destination
  remote_url="$BASE_URL/$name"
  dest="$ROOT_DIR/$name"

  if [ -e "$dest" ] && [ "$FORCE" -ne 1 ]; then
    echo "Skipping existing file: $dest (use -f to overwrite)" >&2
    continue
  fi

  # choose downloader
  if command -v curl >/dev/null 2>&1; then
    dl_cmd=(curl -fSL -o "$dest" "$remote_url")
  elif command -v wget >/dev/null 2>&1; then
    dl_cmd=(wget -O "$dest" "$remote_url")
  else
    echo "Neither curl nor wget is available; cannot download files." >&2
    exit 3
  fi

  if [ "$DRY_RUN" -eq 1 ]; then
    download_cmds+=("${dl_cmd[*]}")
  else
    echo "Downloading $remote_url -> $dest"
    # attempt download, continue on failure
    if ! "${dl_cmd[@]}"; then
      echo "Failed to download: $remote_url" >&2
      # remove partial file if any
      rm -f "$dest" || true
      continue
    fi
  fi
done

if [ "$DRY_RUN" -eq 1 ]; then
  echo "Dry-run: the following commands would be executed:"
  for c in "${download_cmds[@]}"; do
    echo "  $c"
  done
  exit 0
fi

echo "Updating font cache for $ROOT_DIR ..."
if command -v fc-cache >/dev/null 2>&1; then
  fc-cache -f -v "$ROOT_DIR" || true
else
  echo "fc-cache not found; skipping font cache update." >&2
fi

echo "Done. Fonts installed to: $ROOT_DIR"
