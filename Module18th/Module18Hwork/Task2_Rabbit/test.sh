#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$DIR/rabbit"

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

echo "=== Task 2 — Rabbit tests ==="
# Spec: rabbit(3, 2) = 3 (1+2, 2+1, 1+1+1)
check "spec example n=3, k=2"     "3 2"     "3"
# rabbit(0, k) = 1 (already at goal)
check "n=0"                        "0 3"    "1"
# rabbit(1, k) = 1 (one jump of 1)
check "n=1"                        "1 3"    "1"
# rabbit(2, 2) = 2: (1,1), (2)
check "n=2, k=2"                   "2 2"    "2"
# rabbit(2, 1) = 1: (1,1) only
check "n=2, k=1"                   "2 1"    "1"
# rabbit(4, 2): Fibonacci! = 5: (1,1,1,1)(1,1,2)(1,2,1)(2,1,1)(2,2)
check "n=4, k=2 (fib)"             "4 2"    "5"
# rabbit(3, 3) = 4: (1,1,1)(1,2)(2,1)(3)
check "n=3, k=3"                   "3 3"    "4"
# Default k=3 → use -1
check "default k via -1"           "3 -1"   "4"
# rabbit(5, 3) = 13
check "n=5, k=3"                   "5 3"    "13"

echo ""
echo "Total: $TOTAL, Passed: $PASSED, Failed: $FAILED"
[ $FAILED -eq 0 ]
