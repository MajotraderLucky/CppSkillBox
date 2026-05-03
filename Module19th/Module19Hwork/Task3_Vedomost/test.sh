#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$DIR/vedomost"

if [ ! -x "$BIN" ] || [ "$DIR/main.cpp" -nt "$BIN" ]; then
    g++ -std=c++11 -Wall -Wextra "$DIR/main.cpp" -o "$BIN" || exit 1
fi

PASSED=0
FAILED=0
TOTAL=0

# Spec example fixture
SPEC="$DIR/spec.txt"
cat > "$SPEC" <<'EOF'
Tom Hanks 35500 10.11.2020
Rebecca Williams 85000 1.1.2021
Sally Field 15600 15.8.2021
Michael Humphreys 29400 23.5.2020
Harold Herthum 74300 9.6.2019
George Kelly 45000 12.3.2018
Bob Penny 12500 13.5.2020
John Randall 23400 2.10.2020
Sam Anderson 6500 15.7.2020
Margo Moorer 12350 24.2.2019
EOF

# Total = 35500+85000+15600+29400+74300+45000+12500+23400+6500+12350 = 339550
# Max: Rebecca Williams 85000

check_contains() {
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
        echo "  FAIL: $name (pattern: '$pattern')"
        echo "    output: $output"
        FAILED=$((FAILED + 1))
    fi
}

echo "=== Task 3 — Vedomost tests ==="
check_contains "spec total = 339550"          "$SPEC"  "Total: 339550"
check_contains "spec max = Rebecca Williams"  "$SPEC"  "Max recipient: Rebecca Williams"
check_contains "spec max amount = 85000"      "$SPEC"  "85000"

# Edge: single entry
SINGLE="$DIR/single.txt"
echo "Alice Smith 1000 1.1.2020" > "$SINGLE"
check_contains "single entry total"  "$SINGLE"  "Total: 1000"
check_contains "single entry name"   "$SINGLE"  "Alice Smith"

# Empty file
EMPTY="$DIR/empty.txt"
> "$EMPTY"
check_contains "empty total = 0"     "$EMPTY"   "Total: 0"

rm -f "$SPEC" "$SINGLE" "$EMPTY"

echo ""
echo "Total: $TOTAL, Passed: $PASSED, Failed: $FAILED"
[ $FAILED -eq 0 ]
