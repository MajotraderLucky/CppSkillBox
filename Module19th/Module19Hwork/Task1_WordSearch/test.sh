#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$DIR/wordsearch"

if [ ! -x "$BIN" ] || [ "$DIR/main.cpp" -nt "$BIN" ]; then
    g++ -std=c++11 -Wall -Wextra "$DIR/main.cpp" -o "$BIN" || exit 1
fi

PASSED=0
FAILED=0
TOTAL=0

# Create test fixture
FIXTURE="$DIR/words.txt"
cat > "$FIXTURE" <<'EOF'
apple banana cherry
apple orange grape apple
banana melon apple
EOF

check() {
    TOTAL=$((TOTAL + 1))
    local name="$1"
    local target="$2"
    local expected="$3"
    local output
    output=$(echo "$target" | timeout 5 "$BIN" "$FIXTURE" 2>/dev/null | tail -1)
    if [ "$output" = "$expected" ]; then
        echo "  PASS: $name"
        PASSED=$((PASSED + 1))
    else
        echo "  FAIL: $name (expected '$expected', got '$output')"
        FAILED=$((FAILED + 1))
    fi
}

echo "=== Task 1 — Word Search tests ==="
check "apple count = 4"     "apple"   "4"
check "banana count = 2"    "banana"  "2"
check "orange count = 1"    "orange"  "1"
check "missing word = 0"    "pear"    "0"
check "case-sensitive"      "Apple"   "0"

# Test missing file
TOTAL=$((TOTAL + 1))
output=$(echo "test" | timeout 5 "$BIN" "/nonexistent/file.txt" 2>&1)
if echo "$output" | grep -qF "Error: cannot open"; then
    echo "  PASS: missing file → error"
    PASSED=$((PASSED + 1))
else
    echo "  FAIL: missing file detection"
    FAILED=$((FAILED + 1))
fi

rm -f "$FIXTURE"

echo ""
echo "Total: $TOTAL, Passed: $PASSED, Failed: $FAILED"
[ $FAILED -eq 0 ]
