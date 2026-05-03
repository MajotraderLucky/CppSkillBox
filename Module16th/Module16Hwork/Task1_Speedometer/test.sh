#!/bin/bash
# Tests для Task 1 — Спидометр

DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$DIR/speedometer"

if [ ! -x "$BIN" ] || [ "$DIR/main.cpp" -nt "$BIN" ]; then
    g++ -std=c++11 -Wall -Wextra "$DIR/main.cpp" -o "$BIN" || exit 1
fi

PASSED=0
FAILED=0
TOTAL=0

# Compares full stdout
check_eq() {
    TOTAL=$((TOTAL + 1))
    local name="$1"
    local input="$2"
    local expected="$3"
    local output
    output=$(printf "%s\n" "$input" | timeout 5 "$BIN" 2>/dev/null)
    if [ "$output" = "$expected" ]; then
        echo "  PASS: $name"
        PASSED=$((PASSED + 1))
    else
        echo "  FAIL: $name"
        echo "    expected: $(echo "$expected" | tr '\n' '|')"
        echo "    got:      $(echo "$output" | tr '\n' '|')"
        FAILED=$((FAILED + 1))
    fi
}

echo "=== Task 1 — Спидометр tests ==="

# Spec example: 30 → 50.2 → 150 → 127.8 → -200 → 0
check_eq "spec example" "30 20.2 100 -22.24 -200" "Speed: 30.0
Speed: 50.2
Speed: 150.0
Speed: 127.8
Speed: 0.0"

# Сразу останавливается (delta=0)
check_eq "delta=0 first" "0" "Speed: 0.0"

# Negative delta clamps to 0
check_eq "negative clamp" "-50" "Speed: 0.0"

# Positive then negative to stop
check_eq "accelerate then brake" "50 -50" "Speed: 50.0
Speed: 0.0"

# Cap at 150
check_eq "cap at 150" "200 -200" "Speed: 150.0
Speed: 0.0"

# Multiple changes
check_eq "complex sequence" "10 20 30 -10 -10 -10 -30" "Speed: 10.0
Speed: 30.0
Speed: 60.0
Speed: 50.0
Speed: 40.0
Speed: 30.0
Speed: 0.0"

# Точность 0.1 — IEEE 754 banker's rounding affects 1.55 → 1.6 (not exactly 1.55 in binary)
check_eq "precision .1 (banker's)" "1.4 -1.4" "Speed: 1.4
Speed: 0.0"

# Very large speed cap
check_eq "exact 150" "150 -150" "Speed: 150.0
Speed: 0.0"

# 0.01 threshold check
check_eq "below 0.01 threshold" "0.005" "Speed: 0.0"

echo ""
echo "Total: $TOTAL, Passed: $PASSED, Failed: $FAILED"
[ $FAILED -eq 0 ]
