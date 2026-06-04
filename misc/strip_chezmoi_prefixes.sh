#!/usr/bin/env bash
# strip_chezmoi_prefixes.sh
#
# Rename files (not directories) in a chezmoi source directory to their target
# names by removing all chezmoi-specific prefixes and suffixes.
#
# Usage:
#   ./strip_chezmoi_prefixes.sh [OPTIONS] [DIR]
#
# Arguments:
#   DIR   Directory to process (default: current directory)
#
# Options:
#   -n, --dry-run   Show what would be renamed without making changes
#   -r, --recursive Process subdirectories recursively
#   -h, --help      Show this help message
#
# Examples:
#   ./strip_chezmoi_prefixes.sh ~/.local/share/chezmoi
#   ./strip_chezmoi_prefixes.sh --dry-run --recursive ~/.local/share/chezmoi

set -euo pipefail

# ── Defaults ────────────────────────────────────────────────────────────────
DRY_RUN=false
RECURSIVE=false
TARGET_DIR="."

# ── Argument parsing ─────────────────────────────────────────────────────────
usage() {
  sed -n '3,22p' "$0" | sed 's/^# \{0,1\}//'
  exit 0
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--dry-run)   DRY_RUN=true;    shift ;;
    -r|--recursive) RECURSIVE=true;  shift ;;
    -h|--help)      usage ;;
    -*)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
    *)
      TARGET_DIR="$1"
      shift
      ;;
  esac
done

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "Error: '$TARGET_DIR' is not a directory." >&2
  exit 1
fi

# ── Prefix/suffix stripping ──────────────────────────────────────────────────
# All known chezmoi source-state prefixes, in the order chezmoi parses them.
# Reference: https://www.chezmoi.io/reference/source-state-attributes/
#
# File prefixes (order matters for correct stripping):
#   run_, once_, onchange_, before_, after_  → script modifiers (stripped entirely)
#   modify_, create_, symlink_, remove_      → target-type markers
#   literal_                                 → stops further attribute parsing
#   encrypted_                               → encryption marker
#   private_                                 → permissions (0600 / 0700)
#   readonly_                                → permissions (a-w)
#   executable_                              → permissions (+x)
#   empty_                                   → allow empty files
#   dot_                                     → leading dot (.)
#   template_                                → (rare) force template treatment
#
# Suffixes:
#   .tmpl    → template file
#   .literal → literal file (stops attribute parsing)

strip_chezmoi_name() {
  local name="$1"

  # ── Strip suffixes first ──────────────────────────────────────────────────
  # .literal suffix (stop further parsing — strip it and return early would
  # be semantically correct, but we still strip the suffix for a clean name)
  name="${name%.literal}"
  # .tmpl suffix
  name="${name%.tmpl}"

  # ── Strip known prefixes in documented order ──────────────────────────────
  # Script-type prefixes
  name="${name#run_}"
  name="${name#once_}"
  name="${name#onchange_}"
  name="${name#before_}"
  name="${name#after_}"

  # Target-type prefixes
  name="${name#modify_}"
  name="${name#create_}"
  name="${name#symlink_}"
  name="${name#remove_}"

  # Attribute prefixes
  name="${name#literal_}"
  name="${name#encrypted_}"
  name="${name#private_}"
  name="${name#readonly_}"
  name="${name#executable_}"
  name="${name#empty_}"
  name="${name#template_}"

  # dot_ → leading dot
  if [[ "$name" == dot_* ]]; then
    name=".${name#dot_}"
  fi

  echo "$name"
}

# ── Rename logic ─────────────────────────────────────────────────────────────
renamed=0
skipped=0
errors=0

do_rename() {
  local dir="$1"

  # Collect entries; process files before directories so parent renames
  # don't confuse child paths. We reverse-sort depth to handle nested dirs.
  local entries=()
  if $RECURSIVE; then
    # Process deepest entries first so renames don't break parent paths
    while IFS= read -r -d '' entry; do
      entries+=("$entry")
    done < <(find "$dir" -mindepth 1 -print0 | sort -rz)
  else
    while IFS= read -r -d '' entry; do
      entries+=("$entry")
    done < <(find "$dir" -mindepth 1 -maxdepth 1 -print0)
  fi

  for entry in "${entries[@]}"; do
    local parent
    parent="$(dirname "$entry")"
    local basename
    basename="$(basename "$entry")"

    # Skip directories — only rename files
    [[ -d "$entry" ]] && continue

    # Skip chezmoi special files
    case "$basename" in
      .chezmoi*|.git|.gitignore|.gitmodules)
        continue
        ;;
    esac

    local new_name
    new_name="$(strip_chezmoi_name "$basename")"

    if [[ "$new_name" == "$basename" ]]; then
      # No change needed
      continue
    fi

    local new_path="$parent/$new_name"

    if [[ -e "$new_path" && "$new_path" != "$entry" ]]; then
      echo "  SKIP  $entry → $new_path  (target already exists)" >&2
      (( skipped++ )) || true
      continue
    fi

    if $DRY_RUN; then
      echo "  WOULD RENAME  $entry → $new_path"
    else
      if mv -- "$entry" "$new_path" 2>/dev/null; then
        echo "  RENAMED  $entry → $new_path"
        (( renamed++ )) || true
      else
        echo "  ERROR    failed to rename $entry → $new_path" >&2
        (( errors++ )) || true
      fi
    fi
  done
}

# ── Main ──────────────────────────────────────────────────────────────────────
echo "Processing: $(realpath "$TARGET_DIR")"
$DRY_RUN  && echo "Mode: dry-run (no changes will be made)"
$RECURSIVE && echo "Mode: recursive"
echo ""

do_rename "$TARGET_DIR"

echo ""
if $DRY_RUN; then
  echo "Dry-run complete. No files were changed."
else
  echo "Done. Renamed: $renamed  |  Skipped: $skipped  |  Errors: $errors"
fi
