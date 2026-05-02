#!/bin/bash
# Tests для Task 1 — Удалить значение X из вектора (in-place + pop_back)

DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$DIR/remove_x"

# Compile if needed
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
    local actual
    actual=$(printf "%s\n" "$input" | "$BIN" 2>&1 | grep -o "Result:.*" || echo "Result: <NONE>")
    if [ "$actual" = "Result: $expected" ]; then
        echo "  PASS: $name"
        PASSED=$((PASSED + 1))
    else
        echo "  FAIL: $name"
        echo "    expected: 'Result: $expected'"
        echo "    actual:   '$actual'"
        FAILED=$((FAILED + 1))
    fi
}

echo "=== Task 1 — RemoveX tests ==="

# Spec example: n=5, [1,3,3,5,1], X=3 → "1 5 1"
check "spec example: remove all 3s from [1,3,3,5,1]" $'5\n1 3 3 5 1\n3' "1 5 1 "

# Empty vector
check "empty vector" $'0\n\n99' ""

# All elements match (full clear)
check "all match: [5,5,5] remove 5" $'3\n5 5 5\n5' ""

# No matches (no-op)
check "no match: [1,2,3] remove 99" $'3\n1 2 3\n99' "1 2 3 "

# Single element matches
check "single element match: [7] remove 7" $'1\n7\n7' ""

# Single element no match
check "single element no match: [7] remove 99" $'1\n7\n99' "7 "

# Mostly matches
check "mostly match: [1,1,2,1] remove 1" $'4\n1 1 2 1\n1' "2 "

# Order preservation
check "order preserved: [3,1,3,2,3,4] remove 3" $'6\n3 1 3 2 3 4\n3' "1 2 4 "

# Only first
check "remove only first: [9,1,2,3] remove 9" $'4\n9 1 2 3\n9' "1 2 3 "

# Only last
check "remove only last: [1,2,3,9] remove 9" $'4\n1 2 3 9\n9' "1 2 3 "

# Negative numbers
check "negative numbers: [-1,-2,-1,3] remove -1" $'4\n-1 -2 -1 3\n-1' "-2 3 "

echo ""
echo "Total: $TOTAL, Passed: $PASSED, Failed: $FAILED"
[ $FAILED -eq 0 ]
