#!/bin/bash
# Everest macOS launcher script
# Locates the bundled JAR and launches it with the system Java.

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JAR="$DIR/../Java/Everest-@project.version@.jar"

# ── Check for Java ────────────────────────────────────────────────────────────
if ! command -v java &>/dev/null; then
    osascript -e 'display dialog "Java is required to run Everest.\n\nPlease install Java 17 or later from https://adoptium.net and try again." buttons {"OK"} default button "OK" with icon stop with title "Java Not Found"'
    exit 1
fi

# ── Locate JavaFX ─────────────────────────────────────────────────────────────
# Search order:
#   1. JavaFX bundled inside this .app (Contents/Java/javafx/lib)
#   2. JAVAFX_HOME environment variable
#   3. Homebrew (Apple Silicon)
#   4. Homebrew (Intel)
BUNDLED_FX="$DIR/../Java/javafx/lib"
BREW_ARM="/opt/homebrew/opt/openjfx/libexec/lib"
BREW_INTEL="/usr/local/opt/openjfx/libexec/lib"

if [ -d "$BUNDLED_FX" ]; then
    JAVAFX_LIB="$BUNDLED_FX"
elif [ -n "$JAVAFX_HOME" ] && [ -d "$JAVAFX_HOME/lib" ]; then
    JAVAFX_LIB="$JAVAFX_HOME/lib"
elif [ -d "$BREW_ARM" ]; then
    JAVAFX_LIB="$BREW_ARM"
elif [ -d "$BREW_INTEL" ]; then
    JAVAFX_LIB="$BREW_INTEL"
else
    osascript -e 'display dialog "JavaFX is required but could not be found.\n\nTo install it, run this command in Terminal:\n\n  brew install openjfx\n\nAlternatively, download the JavaFX SDK from https://gluonhq.com/products/javafx/ and set the JAVAFX_HOME environment variable to point to it." buttons {"OK"} default button "OK" with icon stop with title "JavaFX Not Found"'
    exit 1
fi

# ── Launch Everest ─────────────────────────────────────────────────────────────
exec java \
    --module-path "$JAVAFX_LIB" \
    --add-modules javafx.controls,javafx.fxml \
    --add-opens javafx.graphics/com.sun.javafx.css=ALL-UNNAMED \
    --add-opens javafx.controls/com.sun.javafx.scene.control.behavior=ALL-UNNAMED \
    --add-opens javafx.controls/com.sun.javafx.scene.control=ALL-UNNAMED \
    --add-opens javafx.base/com.sun.javafx.binding=ALL-UNNAMED \
    --add-opens javafx.graphics/com.sun.javafx.scene=ALL-UNNAMED \
    --add-opens javafx.graphics/com.sun.javafx.scene.traversal=ALL-UNNAMED \
    -jar "$JAR"
