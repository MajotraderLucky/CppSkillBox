#!/bin/bash
# M34.5 Task 1 — verify Qt5 build + offscreen smoke test.
set -u
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default Qt5 path (sandbox aqt-install). Override via QT5_PREFIX env var.
export QT5_PREFIX="${QT5_PREFIX:-$HOME/.local/qt5/5.15.2/gcc_64}"
export QT5_GL_INCLUDE_DIR="${QT5_GL_INCLUDE_DIR:-$HOME/.local/include}"
export LD_LIBRARY_PATH="$QT5_PREFIX/lib:${LD_LIBRARY_PATH:-}"
export QT_QPA_PLATFORM=offscreen

if [ ! -d "$QT5_PREFIX" ]; then
    echo "[!] Qt5 not found at QT5_PREFIX=$QT5_PREFIX"
    echo "    Install via: aqt install-qt linux desktop 5.15.2 gcc_64 --outputdir ~/.local/qt5"
    exit 1
fi
if [ ! -f "$QT5_GL_INCLUDE_DIR/GL/gl.h" ]; then
    echo "[!] GL/gl.h stub not found at $QT5_GL_INCLUDE_DIR/GL/gl.h"
    echo "    Create via: mkdir -p $QT5_GL_INCLUDE_DIR/GL && touch $QT5_GL_INCLUDE_DIR/GL/gl.h"
    exit 1
fi

PASS=0
FAIL=0

check() {
    local name="$1"
    if eval "$2" > /dev/null 2>&1; then
        echo "[+] $name"; PASS=$((PASS+1))
    else
        echo "[X] $name"; FAIL=$((FAIL+1))
    fi
}

# Test 1: CMake configure works
check "cmake-configure" \
    "cmake -S '$SCRIPT_DIR' -B '$SCRIPT_DIR/build' -DCMAKE_BUILD_TYPE=Release"

# Test 2: Build succeeds
check "cmake-build" \
    "cmake --build '$SCRIPT_DIR/build'"

# Test 3: Binary exists
check "binary-exists" \
    "[ -x '$SCRIPT_DIR/build/qtsetup' ]"

# Test 4: AUTOMOC ran (generated files present)
check "automoc-ran" \
    "ls '$SCRIPT_DIR/build/qtsetup_autogen' >/dev/null"

# Test 5: Smoke test (--no-loop) succeeds
ACTUAL=$(timeout 5 "$SCRIPT_DIR/build/qtsetup" --no-loop 2>/dev/null)
if echo "$ACTUAL" | grep -q "Qt initialized OK"; then
    echo "[+] smoke-no-loop"; PASS=$((PASS+1))
else
    echo "[X] smoke-no-loop"; echo "    actual: $ACTUAL"; FAIL=$((FAIL+1))
fi

# Test 6: qVersion reports 5.15.2
if echo "$ACTUAL" | grep -q "qVersion=5.15.2"; then
    echo "[+] qversion-5.15.2"; PASS=$((PASS+1))
else
    echo "[X] qversion-5.15.2"; echo "    actual: $ACTUAL"; FAIL=$((FAIL+1))
fi

# Test 7: layout has 2 widgets (label + button)
if echo "$ACTUAL" | grep -q "layoutCount=2"; then
    echo "[+] layout-count-2"; PASS=$((PASS+1))
else
    echo "[X] layout-count-2"; echo "    actual: $ACTUAL"; FAIL=$((FAIL+1))
fi

# Test 8: CMakeLists has all 3 components
check "cmakelists-has-Core"    "grep -q 'Core'    '$SCRIPT_DIR/CMakeLists.txt'"
check "cmakelists-has-Gui"     "grep -q 'Gui'     '$SCRIPT_DIR/CMakeLists.txt'"
check "cmakelists-has-Widgets" "grep -q 'Widgets' '$SCRIPT_DIR/CMakeLists.txt'"

# Test 9: Source uses QApplication, QPushButton, QLabel
check "src-has-QApplication" "grep -q 'QApplication' '$SCRIPT_DIR/src/main.cpp'"
check "src-has-QPushButton"  "grep -q 'QPushButton'  '$SCRIPT_DIR/src/main.cpp'"
check "src-has-QLabel"       "grep -q 'QLabel'       '$SCRIPT_DIR/src/main.cpp'"

echo
echo "Pass: $PASS, Fail: $FAIL"
[ $FAIL -eq 0 ]
