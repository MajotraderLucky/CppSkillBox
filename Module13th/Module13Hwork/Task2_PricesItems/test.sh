#!/bin/bash
# Tests для Task 2 — Sum prices[items[i]]

DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$DIR/prices_items"

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
    local expected="$2"
    local actual
    actual=$("$BIN" 2>&1 | grep -o "Total:.*" || echo "Total: <NONE>")
    if [ "$actual" = "Total: $expected" ]; then
        echo "  PASS: $name"
        PASSED=$((PASSED + 1))
    else
        echo "  FAIL: $name"
        echo "    expected: 'Total: $expected'"
        echo "    actual:   '$actual'"
        FAILED=$((FAILED + 1))
    fi
}

echo "=== Task 2 — PricesItems tests ==="

# Spec example — values hardcoded в main.cpp:
# prices {2.5, 4.25, 3.0, 10.0}
# items  {1, 1, 0, 3}
# Expected: 4.25 + 4.25 + 2.5 + 10.0 = 21.0 → "21.00" с setprecision(2)
check "spec example: prices×items" "21.00"

echo ""
echo "Total: $TOTAL, Passed: $PASSED, Failed: $FAILED"
[ $FAILED -eq 0 ]
