#!/bin/bash
# M35.6 Task 1 — print 1..5
set -u
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN="$SCRIPT_DIR/build/print_numbers"

if [ ! -x "$BIN" ]; then
    cmake -S "$SCRIPT_DIR" -B "$SCRIPT_DIR/build" -DCMAKE_BUILD_TYPE=Release > /dev/null
    cmake --build "$SCRIPT_DIR/build" > /dev/null
fi

PASS=0
FAIL=0

actual=$(timeout 5 "$BIN" 2>/dev/null)
expected=$'1\n2\n3\n4\n5'

if [ "$actual" = "$expected" ]; then
    echo "[+] print-1-to-5"; PASS=1
else
    echo "[X] print-1-to-5"
    echo "  expected:"; printf "%s\n" "$expected" | sed 's/^/    |/'
    echo "  actual:";   printf "%s\n" "$actual"   | sed 's/^/    |/'
    FAIL=1
fi

# Source content checks
check() {
    local name="$1"
    if eval "$2" > /dev/null 2>&1; then echo "[+] $name"; PASS=$((PASS+1))
    else echo "[X] $name"; FAIL=$((FAIL+1)); fi
}
check "uses-auto"             "grep -q 'auto' '$SCRIPT_DIR/src/main.cpp'"
check "uses-initializer-list" "grep -q '{1, 2, 3, 4, 5}' '$SCRIPT_DIR/src/main.cpp'"
check "uses-range-for"        "grep -q 'for *(.*: ' '$SCRIPT_DIR/src/main.cpp'"

echo
echo "Pass: $PASS, Fail: $FAIL"
[ $FAIL -eq 0 ]
