#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$DIR/vw"

if [ ! -x "$BIN" ] || [ "$DIR/main.cpp" -nt "$BIN" ]; then
    g++ -std=c++11 -Wall -Wextra "$DIR/main.cpp" -o "$BIN" || exit 1
fi

PASSED=0
FAILED=0
TOTAL=0

OUT="$DIR/test_vedomost.txt"
> "$OUT"  # clean

run() {
    local input="$1"
    printf "%s\n" "$input" | timeout 5 "$BIN" "$OUT" 2>/dev/null
}

check_file_contains() {
    TOTAL=$((TOTAL + 1))
    local name="$1"
    local pattern="$2"
    if grep -qF "$pattern" "$OUT"; then
        echo "  PASS: $name"
        PASSED=$((PASSED + 1))
    else
        echo "  FAIL: $name"
        FAILED=$((FAILED + 1))
    fi
}

check_eq() {
    TOTAL=$((TOTAL + 1))
    local name="$1"
    local input="$2"
    local expected="$3"
    local output=$(printf "%s\n" "$input" | timeout 5 "$BIN" "$OUT" 2>/dev/null)
    if [ "$output" = "$expected" ]; then
        echo "  PASS: $name"
        PASSED=$((PASSED + 1))
    else
        echo "  FAIL: $name (expected '$expected', got '$output')"
        FAILED=$((FAILED + 1))
    fi
}

echo "=== Task 1 — Vedomost Writer tests ==="

# Add valid entries
run "Tom
Hanks
10.11.2020
35500"
check_file_contains "first entry"  "Tom Hanks 10.11.2020 35500"

run "Alice
Smith
1.1.2021
12500"
check_file_contains "second entry append"  "Alice Smith 1.1.2021 12500"

# First entry must still be present (append semantics)
check_file_contains "first entry preserved"  "Tom Hanks 10.11.2020 35500"

# Invalid date
check_eq "invalid date format"  "John
Doe
2020-01-01
1000"  "Invalid date"

# Invalid amount
check_eq "invalid amount"   "Bob
Penny
1.1.2020
-100"   "Invalid amount"

# Bad month
check_eq "invalid month"   "Bob
Penny
1.13.2020
500"   "Invalid date"

rm -f "$OUT"
echo ""
echo "Total: $TOTAL, Passed: $PASSED, Failed: $FAILED"
[ $FAILED -eq 0 ]
