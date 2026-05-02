#!/bin/bash
# Tests для Task 3 — Ring buffer (capacity 20)

DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$DIR/ring_buffer"

if [ ! -x "$BIN" ] || [ "$DIR/main.cpp" -nt "$BIN" ]; then
    g++ -std=c++11 -Wall -Wextra "$DIR/main.cpp" -o "$BIN" || exit 1
fi

PASSED=0
FAILED=0
TOTAL=0

# Extract все output: lines (может быть несколько при multiple -1)
check() {
    TOTAL=$((TOTAL + 1))
    local name="$1"
    local input="$2"
    local expected="$3"
    local actual
    actual=$(printf "%s\n" "$input" | timeout 3 "$BIN" 2>&1 | grep -oE "output:.*" | head -1)
    if [ -z "$actual" ]; then actual="output: <NONE>"; fi
    if [ "$actual" = "output: $expected" ]; then
        echo "  PASS: $name"
        PASSED=$((PASSED + 1))
    else
        echo "  FAIL: $name"
        echo "    expected: 'output: $expected'"
        echo "    actual:   '$actual'"
        FAILED=$((FAILED + 1))
    fi
}

echo "=== Task 3 — RingBuffer tests ==="

# 1. Empty (no inputs before -1)
check "empty -1" "-1" ""

# 2. Single element
check "single element" $'42\n-1' "42 "

# 3. Three elements (smoke)
check "three elements" $'1\n2\n3\n-1' "1 2 3 "

# 4. Spec example: ровно 20 элементов
check "exact 20 (no overflow)" \
    $'1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n12\n13\n14\n15\n16\n17\n18\n19\n20\n-1' \
    "1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 "

# 5. Spec example: 23 элемента (overflow на 3)
check "overflow +3 (1..23)" \
    $'1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n12\n13\n14\n15\n16\n17\n18\n19\n20\n21\n22\n23\n-1' \
    "4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 "

# 6. Single overflow
check "21 elements (overflow +1)" \
    $'1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n12\n13\n14\n15\n16\n17\n18\n19\n20\n21\n-1' \
    "2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 "

# 7. Big overflow (40 elements — full wrap)
check "40 elements (full wrap, last 20 = 21..40)" \
    "$(for i in {1..40}; do echo $i; done; echo -1)" \
    "21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 "

# 8. 19 elements (just under capacity)
check "19 elements (no overflow)" \
    "$(for i in {1..19}; do echo $i; done; echo -1)" \
    "1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 "

# 9. Negative numbers
check "negative numbers" $'-5\n-10\n-15\n-1' "-5 -10 -15 "

echo ""
echo "Total: $TOTAL, Passed: $PASSED, Failed: $FAILED"
[ $FAILED -eq 0 ]
