#!/bin/bash
# Tests для Task 5 — Пупырка
# Покрывает: full pop, partial regions, single cell, invalid coords,
# already popped (no double Pop!), reversed coords, edge cells

DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$DIR/bubble"

if [ ! -x "$BIN" ] || [ "$DIR/main.cpp" -nt "$BIN" ]; then
    g++ -std=c++11 -Wall -Wextra "$DIR/main.cpp" -o "$BIN" || exit 1
fi

PASSED=0
FAILED=0
TOTAL=0

# Counts "Pop!" вхождений в выводе (без anchors — 'Region:' может быть на той же строке)
count_pops() {
    local input="$1"
    printf "%s\n" "$input" | timeout 3 "$BIN" 2>&1 | grep -c "Pop!"
}

# Counts "Error:" в выводе
count_errors() {
    local input="$1"
    printf "%s\n" "$input" | timeout 3 "$BIN" 2>&1 | grep -c "Error:"
}

# Check finishes (game over message)
check_finished() {
    TOTAL=$((TOTAL + 1))
    local name="$1"
    local input="$2"
    local output
    output=$(printf "%s\n" "$input" | timeout 3 "$BIN" 2>&1)
    if echo "$output" | grep -q "All bubbles popped"; then
        echo "  PASS: $name"
        PASSED=$((PASSED + 1))
    else
        echo "  FAIL: $name (no 'All bubbles popped' in output)"
        FAILED=$((FAILED + 1))
    fi
}

check_pop_count() {
    TOTAL=$((TOTAL + 1))
    local name="$1"
    local input="$2"
    local expected="$3"
    local actual
    actual=$(count_pops "$input")
    if [ "$actual" = "$expected" ]; then
        echo "  PASS: $name (Pop count = $expected)"
        PASSED=$((PASSED + 1))
    else
        echo "  FAIL: $name (expected $expected pops, got $actual)"
        FAILED=$((FAILED + 1))
    fi
}

check_error_count() {
    TOTAL=$((TOTAL + 1))
    local name="$1"
    local input="$2"
    local expected="$3"
    local actual
    actual=$(count_errors "$input")
    if [ "$actual" = "$expected" ]; then
        echo "  PASS: $name (Error count = $expected)"
        PASSED=$((PASSED + 1))
    else
        echo "  FAIL: $name (expected $expected errors, got $actual)"
        FAILED=$((FAILED + 1))
    fi
}

echo "=== Task 5 — Bubble Wrap tests ==="

# === FULL POP ===
echo "--- Full pop (entire 12x12) ---"
check_finished  "full 0 0 11 11"   "0 0 11 11"
check_pop_count "full = 144 pops"  "0 0 11 11"   "144"

# === SINGLE CELL ===
echo "--- Single cell pop ---"
# Pop 1 cell (3,5), потом ещё 143 на полную область чтобы game over
check_pop_count "single (3,5,3,5) = 1 pop"   $'3 5 3 5\n0 0 11 11' "144"
check_finished  "single → game over"          $'3 5 3 5\n0 0 11 11'

# === PARTIAL REGION ===
echo "--- Partial region ---"
# Pop 3×3 region = 9 pops + остаток 135 = 144 total
check_pop_count "3x3 region = 9 pops"        $'1 1 3 3\n0 0 11 11' "144"

# Pop 4×5 region = 20
check_pop_count "4x5 region = 20 pops"       $'0 0 3 4\n0 0 11 11' "144"

# === IDEMPOTENT (re-pop тех же клеток не считается) ===
echo "--- Idempotent ---"
# Pop (0,0,3,3) дважды = 16 pops total (не 32!) + потом остальное 128 = 144
check_pop_count "double pop same region = 16 (not 32)" \
    $'0 0 3 3\n0 0 3 3\n0 0 11 11' "144"

# Pop one cell, потом region включающий это — счётчик правильный
check_pop_count "cell pop, then region (no double-count)" \
    $'5 5 5 5\n0 0 11 11' "144"

# === REVERSED COORDS (нормализация x1>x2 / y1>y2) ===
echo "--- Reversed coordinates ---"
# (3,3,1,1) должно работать как (1,1,3,3) = 9 pops
check_pop_count "reversed x: (3,3,1,1) = 9 pops"   $'3 3 1 1\n0 0 11 11' "144"

# === ИНВАЛИДНЫЕ КООРДИНАТЫ ===
echo "--- Invalid coordinates ---"
# Out of bounds: 12 (max valid = 11)
check_error_count "x out of bounds (12)"      $'0 0 12 0\n0 0 11 11' "1"
check_error_count "y out of bounds (12)"      $'0 12 0 0\n0 0 11 11' "1"
# Negative
check_error_count "negative x"                $'-1 0 0 0\n0 0 11 11' "1"
check_error_count "negative y"                $'0 -1 0 0\n0 0 11 11' "1"

# Invalid НЕ должен лопать — счётчик pops остаётся как от валидного 0,0,11,11 = 144
check_pop_count "invalid + valid full = 144 (invalid не лопает)" \
    $'15 0 0 0\n0 0 11 11' "144"

# === EDGE CELLS (границы массива) ===
echo "--- Edge cells ---"
check_pop_count "corner (0,0)"                 $'0 0 0 0\n0 0 11 11' "144"
check_pop_count "corner (11,11)"               $'11 11 11 11\n0 0 11 11' "144"
check_pop_count "edge row 0 entire"            $'0 0 0 11\n0 0 11 11' "144"
check_pop_count "edge col 0 entire"            $'0 0 11 0\n0 0 11 11' "144"

echo ""
echo "Total: $TOTAL, Passed: $PASSED, Failed: $FAILED"
[ $FAILED -eq 0 ]
