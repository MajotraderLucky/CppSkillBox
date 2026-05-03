#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$DIR/picgen"

if [ ! -x "$BIN" ] || [ "$DIR/main.cpp" -nt "$BIN" ]; then
    g++ -std=c++11 -Wall -Wextra "$DIR/main.cpp" -o "$BIN" || exit 1
fi

PASSED=0
FAILED=0
TOTAL=0

OUT="$DIR/test_pic.txt"

run() {
    rm -f "$OUT"
    printf "%s\n" "$1" | timeout 5 "$BIN" "$OUT" "$2" 2>/dev/null > /dev/null
}

check_size() {
    TOTAL=$((TOTAL + 1))
    local name="$1"
    local input="$2"
    local seed="$3"
    local expected_lines="$4"
    local expected_chars_per_line="$5"
    run "$input" "$seed"
    local lines=$(wc -l < "$OUT")
    local first_line_len=$(head -1 "$OUT" | wc -c)
    # wc -c includes newline so subtract 1
    first_line_len=$((first_line_len - 1))
    if [ "$lines" = "$expected_lines" ] && [ "$first_line_len" = "$expected_chars_per_line" ]; then
        echo "  PASS: $name ($lines lines × $first_line_len chars)"
        PASSED=$((PASSED + 1))
    else
        echo "  FAIL: $name (expected $expected_lines × $expected_chars_per_line, got $lines × $first_line_len)"
        FAILED=$((FAILED + 1))
    fi
}

check_only_01() {
    TOTAL=$((TOTAL + 1))
    local name="$1"
    if grep -qv '^[01]*$' "$OUT"; then
        echo "  FAIL: $name — non-01 chars found"
        FAILED=$((FAILED + 1))
    else
        echo "  PASS: $name"
        PASSED=$((PASSED + 1))
    fi
}

check_deterministic() {
    TOTAL=$((TOTAL + 1))
    local name="$1"
    local input="$2"
    local seed="$3"
    run "$input" "$seed"
    local out1=$(cat "$OUT")
    run "$input" "$seed"
    local out2=$(cat "$OUT")
    if [ "$out1" = "$out2" ]; then
        echo "  PASS: $name"
        PASSED=$((PASSED + 1))
    else
        echo "  FAIL: $name (results differ for same seed)"
        FAILED=$((FAILED + 1))
    fi
}

echo "=== Task 2 — Random Picture tests ==="
check_size "5×3 picture"      "5
3"   42  3  5
check_size "10×10 picture"    "10
10" 42  10  10
check_only_01 "only 0/1"
check_deterministic "same seed → same output"  "8
8"  123

rm -f "$OUT"
echo ""
echo "Total: $TOTAL, Passed: $PASSED, Failed: $FAILED"
[ $FAILED -eq 0 ]
