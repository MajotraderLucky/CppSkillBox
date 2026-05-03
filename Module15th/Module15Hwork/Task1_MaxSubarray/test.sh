#!/bin/bash
# Tests для Task 1 — Maximum Subarray (Kadane's algorithm)

DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$DIR/maxsubarray"

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
        echo "  FAIL: $name"
        echo "    expected: '$expected'"
        echo "    got:      '$output'"
        FAILED=$((FAILED + 1))
    fi
}

echo "=== Task 1 — Maximum Subarray tests ==="

# Пример из условия задачи
check "spec example {-2,1,-3,4,-1,2,1,-5,4}" "9 -2 1 -3 4 -1 2 1 -5 4" "3 6"

# Простые случаи
check "all positive {1,2,3,4,5}"             "5 1 2 3 4 5"             "0 4"
check "all negative {-1,-2,-3}"              "3 -1 -2 -3"              "0 0"
check "single element positive"              "1 42"                    "0 0"
check "single element negative"              "1 -5"                    "0 0"
check "single zero"                          "1 0"                     "0 0"

# Граничные ситуации Kadane
check "max в начале {5,-1,-2,-3}"            "4 5 -1 -2 -3"            "0 0"
check "max в конце {-3,-2,-1,5}"             "4 -3 -2 -1 5"            "3 3"
check "max посередине {-1,-2,10,-3,-4}"      "5 -1 -2 10 -3 -4"        "2 2"
check "two equal max — first wins {3,-1,3}"  "3 3 -1 3"                "0 2"

# Все нули
check "all zeros {0,0,0}"                    "3 0 0 0"                 "0 0"

# Чередование
check "alternating — algo returns first {1,-1,1,-1,1}" "5 1 -1 1 -1 1"  "0 0"

# Большой массив с явным max сегментом
check "long с peak в середине"               "10 -10 -10 1 2 3 4 5 -10 -10 -10" "2 6"

# Edge: n=0
check "empty array"                          "0"                       "Empty array"

echo ""
echo "Total: $TOTAL, Passed: $PASSED, Failed: $FAILED"
[ $FAILED -eq 0 ]
