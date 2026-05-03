#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$DIR/calc"

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

echo "=== Task 3 — Калькулятор tests ==="

check_eq "addition"          "3+2"              "5"
check_eq "subtraction"       "10-7"             "3"
check_eq "multiplication"    "4*5"              "20"
check_eq "division"          "10/2"             "5"
check_eq "decimal add"       "3.5+2.5"          "6"
check_eq "decimal mul"       "1.5*2"            "3"
check_eq "negative result"   "5-10"             "-5"
check_eq "div by zero"       "10/0"             "Division by zero"
check_eq "unknown op"        "5%2"              "Unknown operator: %"
check_eq "fractional div"    "1/3"              "0.333333"   # default precision 6
check_eq "negative numbers"  "-3+5"             "2"
check_eq "double precision"  "2.5*3.0"          "7.5"

echo ""
echo "Total: $TOTAL, Passed: $PASSED, Failed: $FAILED"
[ $FAILED -eq 0 ]
