#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$DIR/textviewer"

if [ ! -x "$BIN" ] || [ "$DIR/main.cpp" -nt "$BIN" ]; then
    g++ -std=c++11 -Wall -Wextra "$DIR/main.cpp" -o "$BIN" || exit 1
fi

PASSED=0
FAILED=0
TOTAL=0

# Create test fixtures
SHORT="$DIR/short.txt"
LONG="$DIR/long.txt"
EMPTY="$DIR/empty.txt"
echo "Hello, World!" > "$SHORT"
> "$EMPTY"
# Long file (~10KB)
python3 -c "print('A'*10000)" > "$LONG"

check() {
    TOTAL=$((TOTAL + 1))
    local name="$1"
    local file="$2"
    local expected_contains="$3"
    local output
    output=$(timeout 5 "$BIN" "$file" 2>/dev/null)
    if echo "$output" | grep -qF "$expected_contains"; then
        echo "  PASS: $name"
        PASSED=$((PASSED + 1))
    else
        echo "  FAIL: $name"
        FAILED=$((FAILED + 1))
    fi
}

check_size() {
    TOTAL=$((TOTAL + 1))
    local name="$1"
    local file="$2"
    local expected_size="$3"
    local actual
    actual=$(timeout 5 "$BIN" "$file" 2>/dev/null | wc -c)
    if [ "$actual" = "$expected_size" ]; then
        echo "  PASS: $name (size $actual)"
        PASSED=$((PASSED + 1))
    else
        echo "  FAIL: $name (expected $expected_size bytes, got $actual)"
        FAILED=$((FAILED + 1))
    fi
}

echo "=== Task 2 — Text Viewer tests ==="
check "short file content"        "$SHORT"   "Hello, World!"
check_size "short file size = 14" "$SHORT"   "14"   # 13 + newline
check_size "long file size = 10001" "$LONG"  "10001"
check_size "empty file = 0"       "$EMPTY"   "0"

# Missing file
TOTAL=$((TOTAL + 1))
output=$(timeout 5 "$BIN" "/nonexistent" 2>&1)
if echo "$output" | grep -qF "Error:"; then
    echo "  PASS: missing file → error"
    PASSED=$((PASSED + 1))
else
    echo "  FAIL: missing file detection"
    FAILED=$((FAILED + 1))
fi

rm -f "$SHORT" "$LONG" "$EMPTY"

echo ""
echo "Total: $TOTAL, Passed: $PASSED, Failed: $FAILED"
[ $FAILED -eq 0 ]
