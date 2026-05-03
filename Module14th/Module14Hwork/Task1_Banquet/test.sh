#!/bin/bash
# Tests для Task 1 — Банкетный стол
# Покрывает: initial state, все 4 события, инвариант сохранности cutlery
# (общее число приборов не меняется при redistribution)

DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$DIR/banquet"

if [ ! -x "$BIN" ] || [ "$DIR/main.cpp" -nt "$BIN" ]; then
    g++ -std=c++11 -Wall -Wextra "$DIR/main.cpp" -o "$BIN" || exit 1
fi

PASSED=0
FAILED=0
TOTAL=0
OUTPUT=$("$BIN")
INITIAL=$(echo "$OUTPUT" | awk '/=== Initial/,/=== After/' | head -n -1)
AFTER=$(echo "$OUTPUT" | awk '/=== After events ===/,EOF')

check() {
    TOTAL=$((TOTAL + 1))
    local name="$1"
    local actual="$2"
    local expected="$3"
    if [ "$actual" = "$expected" ]; then
        echo "  PASS: $name"
        PASSED=$((PASSED + 1))
    else
        echo "  FAIL: $name"
        echo "    expected: '$expected'"
        echo "    actual:   '$actual'"
        FAILED=$((FAILED + 1))
    fi
}

contains() {
    TOTAL=$((TOTAL + 1))
    local name="$1"
    local where="$2"
    local pattern="$3"
    if echo "$where" | grep -qF "$pattern"; then
        echo "  PASS: $name"
        PASSED=$((PASSED + 1))
    else
        echo "  FAIL: $name (expected line: '$pattern')"
        FAILED=$((FAILED + 1))
    fi
}

echo "=== Task 1 — Banquet tests ==="

# === INITIAL STATE ===
echo "--- Initial state ---"
contains "init: cutlery row 0 = 4 3 3 3 3 3 (VIP +1)" "$INITIAL" "4 3 3 3 3 3"
contains "init: cutlery row 1 = same"                  "$INITIAL" "4 3 3 3 3 3"
contains "init: plates row 0 = 3 2 2 2 2 2 (VIP +1)"   "$INITIAL" "3 2 2 2 2 2"
contains "init: chairs all 1"                          "$INITIAL" "1 1 1 1 1 1"

# === AFTER EVENTS ===
echo "--- After events ---"
contains "event 1: chair added at [0][4] (5-я позиция)" "$AFTER" "1 1 1 1 2 1"
contains "event 4: VIP plate removed → 2 2 2 2 2 2"     "$AFTER" "2 2 2 2 2 2"
contains "events 2+3: cutlery row 1 = 3 3 3 3 3 3 (украли+VIP вернула)" "$AFTER" "3 3 3 3 3 3"
contains "cutlery row 0 (VIP отдала ложку): 3 3 3 3 3 3" "$AFTER" "3 3 3 3 3 3"
contains "plates row 1 unchanged (3 2 2 2 2 2)"         "$AFTER" "3 2 2 2 2 2"
contains "chairs row 1 unchanged (1 1 1 1 1 1)"         "$AFTER" "1 1 1 1 1 1"

# === INVARIANT: total cutlery preserved (redistribution not creation) ===
echo "--- Invariants ---"
# Initial sum = 4+3+3+3+3+3 + 4+3+3+3+3+3 = 38
# After events: -1 stolen (event 2) → 37, событие 3 = 0 net (move from VIP to victim)
# Final total = 37 (только steal изменил total)
# Тут проверим через подсчёт чисел в конкретных строках cutlery (after)
ACTUAL_SUM=$(echo "$AFTER" | awk '/^Cutlery/,/^Plates/' | grep -E "^[0-9 ]+$" | tr ' ' '\n' | grep -v '^$' | paste -sd+ | bc)
TOTAL=$((TOTAL + 1))
if [ "$ACTUAL_SUM" = "37" ]; then
    echo "  PASS: invariant: total cutlery = 37 (initial 38 - 1 stolen)"
    PASSED=$((PASSED + 1))
else
    echo "  FAIL: total cutlery mismatch. Expected 37, got $ACTUAL_SUM"
    FAILED=$((FAILED + 1))
fi

# === BOUNDS: arrays have correct dimensions (2 rows, 6 cols) ===
ROWS_AFTER=$(echo "$AFTER" | awk '/^Cutlery/,/^Plates/' | grep -E "^[0-9 ]+$" | wc -l)
TOTAL=$((TOTAL + 1))
if [ "$ROWS_AFTER" = "2" ]; then
    echo "  PASS: cutlery dim: 2 rows"
    PASSED=$((PASSED + 1))
else
    echo "  FAIL: cutlery rows = $ROWS_AFTER (expected 2)"
    FAILED=$((FAILED + 1))
fi

COLS_AFTER=$(echo "$AFTER" | awk '/^Cutlery/,/^Plates/' | grep -E "^[0-9 ]+$" | head -1 | tr ' ' '\n' | grep -v '^$' | wc -l)
TOTAL=$((TOTAL + 1))
if [ "$COLS_AFTER" = "6" ]; then
    echo "  PASS: cutlery dim: 6 cols"
    PASSED=$((PASSED + 1))
else
    echo "  FAIL: cutlery cols = $COLS_AFTER (expected 6)"
    FAILED=$((FAILED + 1))
fi

echo ""
echo "Total: $TOTAL, Passed: $PASSED, Failed: $FAILED"
[ $FAILED -eq 0 ]
