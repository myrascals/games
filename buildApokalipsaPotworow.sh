#!/bin/sh
set -e

# Folder zrodlowy gry (wymagany, np. ../igor-hood)
SOURCE_DIR="$1"

if [ -z "$SOURCE_DIR" ]; then
    echo "Uzycie: $0 <folder-zrodlowy-gry>" >&2
    exit 1
fi

# Katalog, w ktorym lezy ten skrypt (tutaj jest tez index.html kolekcji)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Bezwzgladna sciezka do katalogu zrodlowego gry
SOURCE_DIR_ABS="$(cd "$SOURCE_DIR" && pwd)"

cd "$SOURCE_DIR_ABS"

INDEX_HTML="$SCRIPT_DIR/ApokalipsaPotworow/index.html"
GAMES_INDEX="$SCRIPT_DIR/index.html"

# Eksport gry (Web)
godot --headless --path . --export-release "Web" "$INDEX_HTML"

# Data budowy w polskiej strefie czasowej (moment wywolania eksportu)
BUILD_DATE=$(TZ='Europe/Warsaw' date '+%d.%m.%Y %H:%M %Z')

# Wpis daty do index.html
sed -i "s|<p id=\"build\">.*</p>|<p id=\"build\">Wersja: <strong>$BUILD_DATE</strong></p>|" "$GAMES_INDEX"

echo "Zbudowano: $BUILD_DATE"
