#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$DIR/piano"

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

echo "=== Task 4 — Пианино tests ==="

# Spec examples
check_eq "spec example 1234" "1234"   "DO RE MI FA"
check_eq "spec example 63"   "63"     "MI LA"

# Single notes
check_eq "single DO"          "1"     "DO"
check_eq "single SI"          "7"     "SI"

# All 7 notes
check_eq "all 7"              "1234567" "DO RE MI FA SOL LA SI"

# Order of input doesn't matter — output always sorted by enum
check_eq "reverse order"      "7654321" "DO RE MI FA SOL LA SI"

# Duplicates ignored
check_eq "duplicates 111"     "111"   "DO"
check_eq "duplicates 1212"    "1212"  "DO RE"
check_eq "all same 7"         "77777" "SI"

# Invalid: 0 outside range
check_eq "invalid 0"          "0"     "Invalid note: 0"
check_eq "invalid 8"          "8"     "Invalid note: 8"
check_eq "invalid letter"     "a"     "Invalid note: a"

echo ""
echo "Total: $TOTAL, Passed: $PASSED, Failed: $FAILED"
[ $FAILED -eq 0 ]
