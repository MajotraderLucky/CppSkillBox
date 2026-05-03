#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$DIR/evendigits"

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

echo "=== Task 3 — EvenDigits tests ==="
# Spec: 9223372036854775806 → 10 even digits
check "spec MAX_LL-1"        "9223372036854775806"  "10"
# Single digit even
check "single digit 4"       "4"                   "1"
# Single digit odd
check "single digit 7"       "7"                   "0"
# Single digit 0
check "single digit 0"       "0"                   "1"
# 2468 — all even
check "2468"                 "2468"                "4"
# 1357 — no even
check "1357"                 "1357"                "0"
# Mixed 1234567890
check "1234567890"           "1234567890"          "5"
# Negative — should count abs digits
check "negative -2468"       "-2468"               "4"
# Round number 100 — digits {1,0,0}, evens = 2
check "100"                  "100"                 "2"
# 10 — digits {1,0}, evens = 1
check "10"                   "10"                  "1"
# Edge: very large 8888888888 — all 8s = 10 even
check "8888888888"           "8888888888"          "10"

echo ""
echo "Total: $TOTAL, Passed: $PASSED, Failed: $FAILED"
[ $FAILED -eq 0 ]
