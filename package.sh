#!/usr/bin/env bash
# Build the installable .plasmoid package (a zip of metadata.desktop + contents/).
set -euo pipefail

cd "$(dirname "$0")"

OUT="${1:-claude-usage-widget.plasmoid}"

rm -f "$OUT"
zip -r "$OUT" metadata.desktop contents/ -x '*.DS_Store' >/dev/null
echo "Built $OUT"
