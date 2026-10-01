#!/bin/bash
# Installs a prepare-commit-msg hook that prefixes commit messages with the DT key from the branch name.
# Usage: install-commit-prefix-hook.sh [repo-path]   (defaults to the current directory)
set -euo pipefail

repo=${1:-$PWD}
git -C "$repo" rev-parse --git-dir >/dev/null 2>&1 || { echo "Not a git repo: $repo" >&2; exit 1; }

hooks_dir=$(cd "$repo" && git rev-parse --path-format=absolute --git-path hooks)
target="$hooks_dir/prepare-commit-msg"
mkdir -p "$hooks_dir"

if [ -e "$target" ]; then
  backup="$target.bak.$(date +%Y%m%d%H%M%S)"
  mv "$target" "$backup"
  echo "Existing hook moved to $backup"
fi

cat > "$target" <<'HOOK'
#!/bin/bash
# Prefix the commit message with the DT key from the branch name, unless a DT key is already in it.
msg_file=$1
case "${2:-}" in merge|squash|commit) exit 0 ;; esac
key=$(git rev-parse --abbrev-ref HEAD 2>/dev/null | grep -oE 'DT-[0-9]+' | head -1)
[ -z "$key" ] && exit 0
grep -qE 'DT-[0-9]+' "$msg_file" && exit 0
first=$(head -1 "$msg_file")
[ -z "$first" ] && exit 0
{ printf '%s %s\n' "$key" "$first"; tail -n +2 "$msg_file"; } > "$msg_file.tmp" && mv "$msg_file.tmp" "$msg_file"
HOOK
chmod +x "$target"
echo "Installed $target"

# Self-test against throwaway message files; nothing is committed.
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
key=$(git -C "$repo" rev-parse --abbrev-ref HEAD | grep -oE 'DT-[0-9]+' | head -1 || true)
if [ -z "$key" ]; then
  echo "Current branch has no DT key; skipping self-test."
  exit 0
fi
check() {
  printf '%s\n' "$2" > "$tmp/msg"
  (cd "$repo" && "$target" "$tmp/msg" "$1")
  got=$(head -1 "$tmp/msg")
  if [ "$got" = "$3" ]; then echo "  ok    [$1] '$2' -> '$got'"; else echo "  FAIL  [$1] '$2' -> '$got' (expected '$3')"; fi
}
echo "Self-test on branch key $key:"
check message "fix channel dedup"    "$key fix channel dedup"
check message "DT-1234 already tagged" "DT-1234 already tagged"
check message "Hotfix DT-9620 - x"   "Hotfix DT-9620 - x"
check merge   "Merge branch x"       "Merge branch x"
