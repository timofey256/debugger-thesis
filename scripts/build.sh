#!/usr/bin/env bash
# Build the thesis PDF(s) from the src/ directory.
# Usage:
#   ./scripts/build.sh          # build thesis + abstracts
#   ./scripts/build.sh --clean  # remove all generated files
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
SRC_DIR="$REPO_ROOT/src"
OUT_DIR="$REPO_ROOT/out"

CLEAN=false
for arg in "$@"; do
  [[ "$arg" == "--clean" ]] && CLEAN=true
done

cd "$SRC_DIR"

if $CLEAN; then
  echo "Cleaning build artifacts..."
  latexmk -C
  exit 0
fi

mkdir -p "$OUT_DIR"

echo "==> Building thesis (main.tex)..."
latexmk -pdflua main

echo "==> Building Czech abstract..."
latexmk -pdflua abstract-cz

echo "==> Building English abstract..."
latexmk -pdflua abstract-en

echo ""
echo "Done! PDFs written to out/"
ls -lh "$OUT_DIR"/*.pdf 2>/dev/null || true
