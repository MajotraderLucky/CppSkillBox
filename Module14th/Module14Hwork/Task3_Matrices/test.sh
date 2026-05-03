#!/bin/bash
# Tests для Task 3 — Сравнение матриц + диагонализация
# Покрывает: equal/not equal, mismatch на разных позициях, identity, zeros,
# negatives, diagonal preservation

DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$DIR/matrices"

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
    actual=$(printf "%s\n" "$input" | timeout 3 "$BIN" 2>&1 | grep -E "(Matrices are|Diagonalized)" | head -1)
    if echo "$actual" | grep -qF "$expected"; then
        echo "  PASS: $name"
        PASSED=$((PASSED + 1))
    else
        echo "  FAIL: $name"
        echo "    expected: '$expected'"
        echo "    actual:   '$actual'"
        FAILED=$((FAILED + 1))
    fi
}

check_diag_line() {
    TOTAL=$((TOTAL + 1))
    local name="$1"
    local input="$2"
    local expected="$3"
    local actual
    actual=$(printf "%s\n" "$input" | timeout 3 "$BIN" 2>&1 | awk '/Diagonalized/,EOF' | grep -E "^-?[0-9]+ ")
    if echo "$actual" | grep -qF "$expected"; then
        echo "  PASS: $name"
        PASSED=$((PASSED + 1))
    else
        echo "  FAIL: $name (expected line: '$expected')"
        FAILED=$((FAILED + 1))
    fi
}

# Two matrices = 32 числа input (2 × 16 elements). 16 на матрицу = 4 строки × 4 col
M_1234="1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16"
M_ZEROS="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0"
M_NEG="-1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12 -13 -14 -15 -16"
M_IDENTITY="1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1"

echo "=== Task 3 — Matrices tests ==="

# === EQUAL ===
echo "--- Equal matrices ---"
check_outcome "equal: M1234 == M1234"          "$M_1234 $M_1234" "EQUAL"
check_outcome "equal: zeros == zeros"          "$M_ZEROS $M_ZEROS" "EQUAL"
check_outcome "equal: identity == identity"    "$M_IDENTITY $M_IDENTITY" "EQUAL"
check_outcome "equal: negatives == negatives"  "$M_NEG $M_NEG" "EQUAL"

# === NOT EQUAL — mismatch на разных позициях ===
echo "--- Not equal (mismatch positions) ---"
# Mismatch [0][0]: 1 vs 999
check_outcome "not equal: mismatch [0][0]"     "999 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 $M_1234" "NOT equal"
# Mismatch [3][3]: last element
check_outcome "not equal: mismatch [3][3]"     "1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 999 $M_1234" "NOT equal"
# Mismatch [1][2]: middle
check_outcome "not equal: mismatch [1][2]"     "1 2 3 4 5 6 999 8 9 10 11 12 13 14 15 16 $M_1234" "NOT equal"

# === DIAGONAL PRESERVATION ===
echo "--- Diagonal preservation ---"
# После diagonalize M1234 → main diagonal = 1, 6, 11, 16, остальные = 0
check_diag_line "row 0: diagonal element 1"   "$M_1234 $M_1234" "1 0 0 0"
check_diag_line "row 1: diagonal element 6"   "$M_1234 $M_1234" "0 6 0 0"
check_diag_line "row 2: diagonal element 11"  "$M_1234 $M_1234" "0 0 11 0"
check_diag_line "row 3: diagonal element 16"  "$M_1234 $M_1234" "0 0 0 16"

# === DIAGONALIZE ZEROS ===
echo "--- Diagonalize zeros ---"
check_diag_line "zeros remain zeros (row 0)"  "$M_ZEROS $M_ZEROS" "0 0 0 0"

# === DIAGONALIZE IDENTITY (already diagonal) ===
echo "--- Identity already diagonal ---"
check_diag_line "identity row 0"              "$M_IDENTITY $M_IDENTITY" "1 0 0 0"
check_diag_line "identity row 3"              "$M_IDENTITY $M_IDENTITY" "0 0 0 1"

# === NOT EQUAL → NO DIAG OUTPUT ===
echo "--- Not equal → no diagonal output ---"
TOTAL=$((TOTAL + 1))
output=$(printf "999 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 $M_1234\n" | timeout 3 "$BIN" 2>&1)
if echo "$output" | grep -q "Diagonalized"; then
    echo "  FAIL: should NOT print Diagonalized when matrices unequal"
    FAILED=$((FAILED + 1))
else
    echo "  PASS: no diag output when unequal"
    PASSED=$((PASSED + 1))
fi

echo ""
echo "Total: $TOTAL, Passed: $PASSED, Failed: $FAILED"
[ $FAILED -eq 0 ]
