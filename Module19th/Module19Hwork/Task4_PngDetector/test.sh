#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$DIR/pngdet"

if [ ! -x "$BIN" ] || [ "$DIR/main.cpp" -nt "$BIN" ]; then
    g++ -std=c++11 -Wall -Wextra "$DIR/main.cpp" -o "$BIN" || exit 1
fi

PASSED=0
FAILED=0
TOTAL=0

# Create fixtures
VALID_PNG="$DIR/valid.png"
WRONG_EXT="$DIR/valid_magic.txt"
WRONG_MAGIC="$DIR/wrong.png"
EMPTY_PNG="$DIR/empty.png"

# Valid PNG (8-byte header: 89 50 4E 47 0D 0A 1A 0A then random data)
printf '\x89PNG\r\n\x1a\n\x00\x01\x02\x03' > "$VALID_PNG"
# Same magic but wrong extension
printf '\x89PNG\r\n\x1a\n\x00\x01\x02\x03' > "$WRONG_EXT"
# Wrong magic but right extension
printf 'NOTAPNG\x00' > "$WRONG_MAGIC"
# Empty file with .png extension
> "$EMPTY_PNG"

check() {
    TOTAL=$((TOTAL + 1))
    local name="$1"
    local file="$2"
    local pattern="$3"
    local output
    output=$(timeout 5 "$BIN" "$file" 2>/dev/null)
    if echo "$output" | grep -qF "$pattern"; then
        echo "  PASS: $name"
        PASSED=$((PASSED + 1))
    else
        echo "  FAIL: $name (expected '$pattern', got '$output')"
        FAILED=$((FAILED + 1))
    fi
}

echo "=== Task 4 — PNG Detector tests ==="
check "valid PNG"             "$VALID_PNG"   "Valid PNG"
check "wrong extension"       "$WRONG_EXT"   "wrong extension"
check "wrong magic"           "$WRONG_MAGIC" "wrong magic"
check "empty file w/ .png"    "$EMPTY_PNG"   "wrong magic"
check "non-existent .png"     "/nonexistent.png" "wrong magic"

# Case-insensitive ext
PNG_UPPER="$DIR/upper.PNG"
printf '\x89PNG\r\n\x1a\n' > "$PNG_UPPER"
check "uppercase .PNG"        "$PNG_UPPER"   "Valid PNG"

rm -f "$VALID_PNG" "$WRONG_EXT" "$WRONG_MAGIC" "$EMPTY_PNG" "$PNG_UPPER"

echo ""
echo "Total: $TOTAL, Passed: $PASSED, Failed: $FAILED"
[ $FAILED -eq 0 ]
