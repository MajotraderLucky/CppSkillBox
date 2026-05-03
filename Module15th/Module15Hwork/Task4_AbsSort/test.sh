#!/bin/bash
# Tests для Task 4 — Sort by absolute value (two-pointer на pre-sorted)

DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$DIR/abssort"

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

echo "=== Task 4 — Sort by absolute value tests ==="

# Spec example
check_eq "spec example {-100,-50,-5,1,10,15}" "6 -100 -50 -5 1 10 15" "1 -5 10 15 -50 -100"

# Только positive
check_eq "all positive {1,2,3,4,5}"          "5 1 2 3 4 5"             "1 2 3 4 5"

# Только negative
check_eq "all negative {-5,-4,-3,-2,-1}"     "5 -5 -4 -3 -2 -1"        "-1 -2 -3 -4 -5"

# Симметричный
check_eq "symmetric {-3,-2,-1,1,2,3}"        "6 -3 -2 -1 1 2 3"        "1 -1 2 -2 3 -3"

# Пограничный с нулём
check_eq "with zero {-2,-1,0,1,2}"           "5 -2 -1 0 1 2"           "0 1 -1 2 -2"
check_eq "zero only {0}"                     "1 0"                     "0"

# Один элемент
check_eq "single positive"                   "1 5"                     "5"
check_eq "single negative"                   "1 -5"                    "-5"

# Граничный nbsp с одинаковыми abs (negative первым в input)
check_eq "ties {-3,-1,1,3}"                  "4 -3 -1 1 3"             "1 -1 3 -3"

# Edge: пустой
check_eq "empty array"                       "0"                       "Empty array"

# Edge: дубликаты
check_eq "duplicates {-2,-2,1,1}"            "4 -2 -2 1 1"             "1 1 -2 -2"

# Большой array, только negative + positive
check_eq "long array"                        "8 -10 -7 -3 -1 2 4 6 8"  "-1 2 -3 4 6 -7 8 -10"

# Validation: input не отсортирован
check_eq "unsorted input rejected"           "3 5 1 3"                 "Input not sorted ascending"

echo ""
echo "Total: $TOTAL, Passed: $PASSED, Failed: $FAILED"
[ $FAILED -eq 0 ]
