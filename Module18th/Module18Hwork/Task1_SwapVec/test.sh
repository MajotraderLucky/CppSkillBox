#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$DIR/swapvec"

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
    output=$(printf "%s\n" "$input" | timeout 5 "$BIN" 2>/dev/null)
    if [ "$output" = "$expected" ]; then
        echo "  PASS: $name"
        PASSED=$((PASSED + 1))
    else
        echo "  FAIL: $name (expected '$expected', got '$output')"
        FAILED=$((FAILED + 1))
    fi
}

echo "=== Task 1 — SwapVec tests ==="
check_eq "spec example"      "4 1 2 3 4 2 4 6 8"   "2 4 6 8
1 2 3 4"
check_eq "single element"    "1 5 7"               "7
5"
check_eq "negatives"         "3 -1 -2 -3 1 2 3"    "1 2 3
-1 -2 -3"
check_eq "all zero"          "3 0 0 0 0 0 0"       "0 0 0
0 0 0"
check_eq "same arrays"       "3 5 5 5 5 5 5"       "5 5 5
5 5 5"

echo ""
echo "Total: $TOTAL, Passed: $PASSED, Failed: $FAILED"
[ $FAILED -eq 0 ]
