#!/bin/bash
# Tests для Task 2 — Крестики-нолики
# Покрывает: win по строкам (3), win по колонкам (3), ничья,
# invalid input (out of bounds, занятая клетка), переключение игроков

DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$DIR/tictactoe"

if [ ! -x "$BIN" ] || [ "$DIR/main.cpp" -nt "$BIN" ]; then
    g++ -std=c++11 -Wall -Wextra "$DIR/main.cpp" -o "$BIN" || exit 1
fi

PASSED=0
FAILED=0
TOTAL=0

check_outcome() {
    TOTAL=$((TOTAL + 1))
    local name="$1"
    local input="$2"
    local expected="$3"
    local actual
    actual=$(printf "%s\n" "$input" | timeout 3 "$BIN" 2>&1 | grep -oE "(Player [XO] wins!|Draw!)" | tail -1)
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

check_contains() {
    TOTAL=$((TOTAL + 1))
    local name="$1"
    local input="$2"
    local pattern="$3"
    local output
    output=$(printf "%s\n" "$input" | timeout 3 "$BIN" 2>&1)
    if echo "$output" | grep -qE "$pattern"; then
        echo "  PASS: $name"
        PASSED=$((PASSED + 1))
    else
        echo "  FAIL: $name (expected match: '$pattern')"
        FAILED=$((FAILED + 1))
    fi
}

echo "=== Task 2 — Tic-Tac-Toe tests ==="

# === HORIZONTAL WINS (3 строки) ===
echo "--- Horizontal wins ---"
# X wins row 0: X(0,0), O(1,0), X(0,1), O(1,1), X(0,2)
check_outcome "X wins row 0"  $'0 0\n1 0\n0 1\n1 1\n0 2' "Player X wins!"
# X wins row 1
check_outcome "X wins row 1"  $'1 0\n0 0\n1 1\n0 1\n1 2' "Player X wins!"
# X wins row 2
check_outcome "X wins row 2"  $'2 0\n0 0\n2 1\n0 1\n2 2' "Player X wins!"

# === VERTICAL WINS (3 колонки) ===
echo "--- Vertical wins ---"
# X wins col 0: X(0,0), O(0,1), X(1,0), O(1,1), X(2,0)
check_outcome "X wins col 0"  $'0 0\n0 1\n1 0\n1 1\n2 0' "Player X wins!"
# X wins col 1
check_outcome "X wins col 1"  $'0 1\n0 0\n1 1\n1 0\n2 1' "Player X wins!"
# X wins col 2
check_outcome "X wins col 2"  $'0 2\n0 0\n1 2\n1 0\n2 2' "Player X wins!"

# === O WINS ===
echo "--- O wins ---"
# O wins row 1 (X идёт первым, потом O): X(0,0), O(1,0), X(0,1), O(1,1), X(2,2), O(1,2)
check_outcome "O wins row 1"  $'0 0\n1 0\n0 1\n1 1\n2 2\n1 2' "Player O wins!"

# === DRAW ===
# X(0,0), O(0,1), X(0,2), O(1,1), X(1,0), O(1,2), X(2,1), O(2,0), X(2,2)
# Финал: X O X / X O O / O X X — нет 3 в ряд → ничья
echo "--- Draw ---"
check_outcome "draw (full board no winner)" $'0 0\n0 1\n0 2\n1 1\n1 0\n1 2\n2 1\n2 0\n2 2' "Draw!"

# === INVALID INPUT — OUT OF BOUNDS ===
echo "--- Invalid input ---"
# Сначала пробуем out-of-bounds, потом валидный ход
check_contains "out-of-bounds error message"   $'5 5\n0 0' "Out of bounds"
check_contains "negative row error"            $'-1 0\n0 0' "Out of bounds"
check_contains "col >= 3 error"                $'0 3\n0 0' "Out of bounds"

# === ZANYATAYA CELL ===
# X играет (0,0), O пробует (0,0) — должна быть ошибка
check_contains "cell already taken error"      $'0 0\n0 0\n1 0' "Cell already taken"

# === ИГРА ПРОДОЛЖАЕТСЯ после ошибки ===
# Out-of-bounds НЕ съедает ход — X всё равно ходит
check_outcome "errors don't consume move (X still wins)"  $'5 5\n0 0\n1 0\n0 1\n1 1\n0 2' "Player X wins!"

echo ""
echo "Total: $TOTAL, Passed: $PASSED, Failed: $FAILED"
[ $FAILED -eq 0 ]
