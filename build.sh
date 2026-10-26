#!/usr/bin/env bash
# Build from any working directory; keep TeX intermediates out of the sources.
set -euo pipefail

project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd -- "$project_dir"

case "${1:-}" in
    -h|--help)
        echo 'Usage: ./build.sh [--check | --clean]'
        echo 'Default: build with XeLaTeX/Biber and write main.pdf.'
        echo '--check: check required commands without compiling.'
        echo '--clean: remove intermediate build files; keep the published main.pdf.'
        exit 0
        ;;
    ''|--check|--clean) ;;
    *) echo "Unknown argument: $1" >&2; exit 2 ;;
esac
if (( $# > 1 )); then
    echo 'Only one option is accepted. See ./build.sh --help.' >&2
    exit 2
fi

missing=()
for tool in latexmk xelatex biber; do
    command -v "$tool" >/dev/null 2>&1 || missing+=("$tool")
done
if (( ${#missing[@]} )); then
    printf 'Missing tools: %s\n' "${missing[*]}" >&2
    cat >&2 <<'INSTALL'
Install the report dependencies on Ubuntu:
  sudo apt update
  sudo apt install latexmk biber texlive-xetex texlive-latex-extra texlive-science texlive-lang-other texlive-bibtex-extra texlive-fonts-recommended lmodern
Then run ./build.sh again. See README.md for details.
INSTALL
    exit 1
fi
if [[ "${1:-}" == --check ]]; then
    echo 'Found latexmk, xelatex and biber. Ready to compile.'
    exit 0
fi

build_dir='.build/ubuntu'
mkdir -p -- "$build_dir"
if [[ "${1:-}" == --clean ]]; then
    latexmk -r latexmkrc -C -outdir="$build_dir" main.tex
    exit 0
fi

latexmk -xelatex -interaction=nonstopmode -halt-on-error \
    -file-line-error -outdir="$build_dir" main.tex
if [[ ! -s "$build_dir/main.pdf" ]]; then
    echo 'Build did not produce a PDF. See .build/ubuntu/main.log.' >&2
    exit 1
fi
cp -- "$build_dir/main.pdf" main.pdf
printf 'PDF: %s/main.pdf\n' "$project_dir"
