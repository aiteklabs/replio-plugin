#!/usr/bin/env bash
# Raise the plugin version in every manifest at once.
# Usage: scripts/bump-version.sh 1.1.0
set -euo pipefail

version="${1:-}"
if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "usage: $0 <major.minor.patch>" >&2
  exit 1
fi

cd "$(dirname "$0")/.."

manifests=(
  .claude-plugin/plugin.json
  plugin.json
  .codex-plugin/plugin.json
  .cursor-plugin/plugin.json
  server.json
)

for file in "${manifests[@]}"; do
  tmp="$(mktemp)"
  jq --arg v "$version" '.version = $v' "$file" > "$tmp"
  mv "$tmp" "$file"
  echo "$file -> $version"
done
