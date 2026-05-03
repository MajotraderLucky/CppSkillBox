#!/bin/bash
# Tests для Task 2 — Сшиватель дробных чисел

DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$DIR/stitcher"

if [ ! -x "$BIN" ] || [ "$DIR/main.cpp" -nt "$BIN" ]; then
    g++ -std=c++11 -Wall -Wextra "$DIR/main.cpp" -o "$BIN" || exit 1
fi

PASSED=0
FAILED=0
TOTAL=0

check_eq() {
    TOTAL=$((TOTAL + 1))
    local name="$1"
    local input="$2"
    local expected="$3"
    local output
    output=$(printf "%s\n" "$input" | timeout 5 "$BIN" 2>/dev/null | tail -1)
    if [ "$output" = "$expected" ]; then
        echo "  PASS: $name"
        PASSED=$((PASSED + 1))
    else
        echo "  FAIL: $name"
        echo "    expected: '$expected'"
        echo "    got:      '$output'"
        FAILED=$((FAILED + 1))
    fi
}

echo "=== Task 2 — Сшиватель дробных tests ==="

check_eq "3.14"            "3 14"              "3.14"
check_eq "0.5"             "0 5"               "0.5"
check_eq "100.001"         "100 001"           "100.001"
check_eq "negative"        "-1 5"              "-1.5"
check_eq "large int part"  "12345 6789"        "12345.7"   # default cout precision = 6 sig figs
check_eq "single digit each" "1 1"             "1.1"

echo ""
echo "Total: $TOTAL, Passed: $PASSED, Failed: $FAILED"
[ $FAILED -eq 0 ]
