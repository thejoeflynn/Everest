#!/bin/bash
# Build a native ARM64 macOS DMG for Everest.
# Requires:
#   - Temurin 21 JDK (arm64): /Library/Java/JavaVirtualMachines/temurin-21.jdk
#   - JavaFX 21 jmods (aarch64): ~/Documents/javafx-jmods-21.0.11
#   - Maven build already run: mvn package

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
JPACKAGE=/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home/bin/jpackage
JMODS=~/Documents/javafx-jmods-21.0.11
OUTPUT="$PROJECT_DIR/output"

mkdir -p "$OUTPUT"

cd "$PROJECT_DIR"

"$JPACKAGE" \
  --verbose \
  --type dmg \
  --name Everest \
  --app-version 1.4 \
  --input target \
  --main-jar Everest-Alpha-1.4.jar \
  --main-class rocks.zipcode.everest.Launcher \
  --icon packaging/macos/everest.icns \
  --module-path "$JMODS" \
  --add-modules javafx.controls,javafx.fxml,javafx.base,javafx.graphics,java.sql,java.naming,java.xml \
  --java-options "--add-opens=javafx.graphics/com.sun.javafx.css=ALL-UNNAMED" \
  --java-options "--add-opens=javafx.controls/com.sun.javafx.scene.control.behavior=ALL-UNNAMED" \
  --java-options "--add-opens=javafx.controls/com.sun.javafx.scene.control=ALL-UNNAMED" \
  --java-options "--add-opens=javafx.base/com.sun.javafx.binding=ALL-UNNAMED" \
  --java-options "--add-opens=javafx.graphics/com.sun.javafx.scene=ALL-UNNAMED" \
  --java-options "--add-opens=javafx.graphics/com.sun.javafx.scene.traversal=ALL-UNNAMED" \
  --dest "$OUTPUT"

echo "Done! DMG is at $OUTPUT/Everest-1.4.dmg"
