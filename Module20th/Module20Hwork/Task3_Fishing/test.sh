#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$DIR/fish"

if [ ! -x "$BIN" ] || [ "$DIR/main.cpp" -nt "$BIN" ]; then
    g++ -std=c++11 -Wall -Wextra "$DIR/main.cpp" -o "$BIN" || exit 1
fi

PASSED=0
FAILED=0
TOTAL=0

RIVER="$DIR/river.txt"
BASKET="$DIR/basket.txt"

# Spec example
cat > "$RIVER" <<'EOF'
sunfish
shad
carp
bass
bullhead
carp
walleye
catfish
carp
EOF

run() {
    rm -f "$BASKET"
    printf "%s\n" "$1" | timeout 5 "$BIN" "$RIVER" "$BASKET" 2>/dev/null
}

check_eq() {
    TOTAL=$((TOTAL + 1))
    local name="$1"
    local target="$2"
    local expected="$3"
    local out=$(run "$target" | tail -1)
    if [ "$out" = "$expected" ]; then
        echo "  PASS: $name"
        PASSED=$((PASSED + 1))
    else
        echo "  FAIL: $name (expected '$expected', got '$out')"
        FAILED=$((FAILED + 1))
    fi
}

check_basket() {
    TOTAL=$((TOTAL + 1))
    local name="$1"
    local expected_count="$2"
    local actual=$(wc -l < "$BASKET")
    if [ "$actual" = "$expected_count" ]; then
        echo "  PASS: $name (basket has $actual lines)"
        PASSED=$((PASSED + 1))
    else
        echo "  FAIL: $name (expected $expected_count lines, got $actual)"
        FAILED=$((FAILED + 1))
    fi
}

echo "=== Task 3 — Fishing tests ==="
check_eq "carp count = 3"      "carp"     "Caught 3 carp"
check_basket "basket has 3 carp"  3
check_eq "bass count = 1"      "bass"     "Caught 1 bass"
check_eq "tuna missing"        "tuna"     "Caught 0 tuna"
check_eq "sunfish = 1"         "sunfish"  "Caught 1 sunfish"

# Append semantics: 2 sessions
rm -f "$BASKET"
run "carp" > /dev/null
TOTAL=$((TOTAL + 1))
ALSO=$(printf "bass\n" | timeout 5 "$BIN" "$RIVER" "$BASKET" 2>/dev/null)
basket_count=$(wc -l < "$BASKET")
if [ "$basket_count" = "4" ]; then  # 3 carp + 1 bass
    echo "  PASS: append across sessions (4 in basket)"
    PASSED=$((PASSED + 1))
else
    echo "  FAIL: append across sessions (expected 4, got $basket_count)"
    FAILED=$((FAILED + 1))
fi

rm -f "$RIVER" "$BASKET"
echo ""
echo "Total: $TOTAL, Passed: $PASSED, Failed: $FAILED"
[ $FAILED -eq 0 ]
