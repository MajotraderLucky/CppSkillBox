#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$DIR/reverse10"

if [ ! -x "$BIN" ] || [ "$DIR/main.cpp" -nt "$BIN" ]; then
    g++ -std=c++11 -Wall -Wextra "$DIR/main.cpp" -o "$BIN" || exit 1
fi

PASSED=0
FAILED=0
TOTAL=0

check() {
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
        echo "  FAIL: $name (expected '$expected', got '$output')"
        FAILED=$((FAILED + 1))
    fi
}

echo "=== Task 2 — Reverse 10 tests ==="
check "1..10"           "1 2 3 4 5 6 7 8 9 10"          "10 9 8 7 6 5 4 3 2 1"
check "all same"        "5 5 5 5 5 5 5 5 5 5"           "5 5 5 5 5 5 5 5 5 5"
check "palindrome"      "1 2 3 4 5 5 4 3 2 1"           "1 2 3 4 5 5 4 3 2 1"
check "negative"        "-1 -2 -3 -4 -5 -6 -7 -8 -9 -10" "-10 -9 -8 -7 -6 -5 -4 -3 -2 -1"
check "mixed"           "1 -2 3 -4 5 -6 7 -8 9 -10"     "-10 9 -8 7 -6 5 -4 3 -2 1"
check "zeros"           "0 0 0 0 0 0 0 0 0 0"           "0 0 0 0 0 0 0 0 0 0"
check "reverse already" "10 9 8 7 6 5 4 3 2 1"          "1 2 3 4 5 6 7 8 9 10"

echo ""
echo "Total: $TOTAL, Passed: $PASSED, Failed: $FAILED"
[ $FAILED -eq 0 ]
