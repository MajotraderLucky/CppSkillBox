#!/bin/bash
# Tests для Task 8 — Морской бой
# Покрывает: placement validation (OOB, square, wrong size, collision),
# successful game where Player 1 wins after 20 hits

DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$DIR/battleship"

if [ ! -x "$BIN" ] || [ "$DIR/main.cpp" -nt "$BIN" ]; then
    g++ -std=c++11 -Wall -Wextra "$DIR/main.cpp" -o "$BIN" || exit 1
fi

PASSED=0
FAILED=0
TOTAL=0

# Helper: standard ship placement layout (32 numbers per player).
# Layout (compact, no collisions):
#   1-cell: (0,0) (0,2) (0,4) (0,6)
#   2-cell: (2,0-2,1) (2,3-2,4) (2,6-2,7)
#   3-cell: (4,0-4,2) (4,4-4,6)
#   4-cell: (6,0-6,3)
PLAYER_LAYOUT=$'0 0\n0 2\n0 4\n0 6\n2 0 2 1\n2 3 2 4\n2 6 2 7\n4 0 4 2\n4 4 4 6\n6 0 6 3'

# 20 attack coords для full hit set (cells of opponent)
# Must hit all 20 deck cells: same layout positions
ATTACK_HITS=$'0 0\n0 2\n0 4\n0 6\n2 0\n2 1\n2 3\n2 4\n2 6\n2 7\n4 0\n4 1\n4 2\n4 4\n4 5\n4 6\n6 0\n6 1\n6 2\n6 3'

# Player 2 attacks invalid coords (miss every time): just send 9 9 multiple times
P2_MISSES=$'9 9\n9 9\n9 9\n9 9\n9 9\n9 9\n9 9\n9 9\n9 9\n9 9\n9 9\n9 9\n9 9\n9 9\n9 9\n9 9\n9 9\n9 9\n9 9'

check_contains() {
    TOTAL=$((TOTAL + 1))
    local name="$1"
    local input="$2"
    local pattern="$3"
    local output
    output=$(printf "%s\n" "$input" | timeout 10 "$BIN" 2>&1)
    if echo "$output" | grep -qF "$pattern"; then
        echo "  PASS: $name"
        PASSED=$((PASSED + 1))
    else
        echo "  FAIL: $name"
        echo "    expected text: '$pattern'"
        echo "    last output line:"
        echo "$output" | tail -3 | sed 's/^/      /'
        FAILED=$((FAILED + 1))
    fi
}

count_pattern() {
    local input="$1"
    local pattern="$2"
    printf "%s\n" "$input" | timeout 10 "$BIN" 2>&1 | grep -cF "$pattern"
}

echo "=== Task 8 — Battleship tests ==="

# === FULL GAME — Player 1 wins ===
echo "--- Full game ---"
# Both players place ships, then P1 hits 20 valid cells with P2 missing every time.
# Game order: P1, P2, P1, P2, ... но с break когда decks_2 == 0.
# So 20 P1 attacks + 19 P2 attacks (after last P1 hit, loop breaks).
# Build sequence P1_hit_1, P2_miss_1, P1_hit_2, P2_miss_2, ..., P1_hit_20.

# Constructing interleaved attacks
P1_ATTACKS_ARR=("0 0" "0 2" "0 4" "0 6" "2 0" "2 1" "2 3" "2 4" "2 6" "2 7" "4 0" "4 1" "4 2" "4 4" "4 5" "4 6" "6 0" "6 1" "6 2" "6 3")
P2_MISS="9 9"

INTERLEAVED=""
for i in {0..19}; do
    INTERLEAVED+="${P1_ATTACKS_ARR[$i]}"$'\n'
    if [ "$i" -lt 19 ]; then
        INTERLEAVED+="$P2_MISS"$'\n'
    fi
done

FULL_INPUT="${PLAYER_LAYOUT}"$'\n'"${PLAYER_LAYOUT}"$'\n'"${INTERLEAVED}"

check_contains "Player 1 wins after 20 hits" "$FULL_INPUT" "Player 1 wins!"

# Также проверить что все 20 hits зарегистрированы
TOTAL=$((TOTAL + 1))
hit_count=$(count_pattern "$FULL_INPUT" "Hit!")
if [ "$hit_count" = "20" ]; then
    echo "  PASS: exactly 20 hits registered"
    PASSED=$((PASSED + 1))
else
    echo "  FAIL: expected 20 hits, got $hit_count"
    FAILED=$((FAILED + 1))
fi

# === SHIP PLACEMENT VALIDATION ===
# Each invalid placement triggers "Try again." и user retries.
# We test через retries: первая попытка fails, вторая works.
echo "--- Ship placement validation ---"

# Pattern: invalid attempt + valid retry as first ship for P1.
# Then continue с standard layout.

# Test: out of bounds первая попытка (10 0 для size 1) → error → retry с (0,0)
INVALID_OOB_LAYOUT=$'10 0\n0 0\n0 2\n0 4\n0 6\n2 0 2 1\n2 3 2 4\n2 6 2 7\n4 0 4 2\n4 4 4 6\n6 0 6 3'
INPUT_OOB="${INVALID_OOB_LAYOUT}"$'\n'"${PLAYER_LAYOUT}"$'\n'"${INTERLEAVED}"
check_contains "OOB → error message"        "$INPUT_OOB" "out of bounds"
check_contains "OOB → game continues"        "$INPUT_OOB" "Player 1 wins!"

# Test: square ship (2 0 0 2 для size 2) → diagonal/square error
INVALID_SQUARE=$'0 0\n0 2\n0 4\n0 6\n2 0 0 2\n2 0 2 1\n2 3 2 4\n2 6 2 7\n4 0 4 2\n4 4 4 6\n6 0 6 3'
INPUT_SQUARE="${INVALID_SQUARE}"$'\n'"${PLAYER_LAYOUT}"$'\n'"${INTERLEAVED}"
check_contains "square ship → error"         "$INPUT_SQUARE" "diagonal/square"

# Test: wrong size (claim size 2 но coords describe size 3: 2 0 2 2)
INVALID_SIZE=$'0 0\n0 2\n0 4\n0 6\n2 0 2 2\n2 0 2 1\n2 3 2 4\n2 6 2 7\n4 0 4 2\n4 4 4 6\n6 0 6 3'
INPUT_SIZE="${INVALID_SIZE}"$'\n'"${PLAYER_LAYOUT}"$'\n'"${INTERLEAVED}"
check_contains "wrong size → error"          "$INPUT_SIZE" "expected"

# Test: collision (place ship на (0,0), then try (0,0) again same size)
# Actually: try (0,0)(0,1) когда (0,0) уже occupied — для size=2 как первого 2-cell
INVALID_COLLISION=$'0 0\n0 2\n0 4\n0 6\n0 0 0 1\n2 0 2 1\n2 3 2 4\n2 6 2 7\n4 0 4 2\n4 4 4 6\n6 0 6 3'
INPUT_COLLISION="${INVALID_COLLISION}"$'\n'"${PLAYER_LAYOUT}"$'\n'"${INTERLEAVED}"
check_contains "collision → error"           "$INPUT_COLLISION" "collision"

# Test: reversed coords swap (3 0 2 0 для size 2 = swap to 2 0 3 0)
# Wait — это would be vertical 2-cell. Let me use horizontal: 0 1 0 0 → swap to 0 0 0 1
# But 0 0 already taken. Use other: 2 1 2 0 → swap to 2 0 2 1 → success
REVERSED_LAYOUT=$'0 0\n0 2\n0 4\n0 6\n2 1 2 0\n2 3 2 4\n2 6 2 7\n4 0 4 2\n4 4 4 6\n6 0 6 3'
INPUT_REVERSED="${REVERSED_LAYOUT}"$'\n'"${PLAYER_LAYOUT}"$'\n'"${INTERLEAVED}"
check_contains "reversed coords → still wins" "$INPUT_REVERSED" "Player 1 wins!"

echo ""
echo "Total: $TOTAL, Passed: $PASSED, Failed: $FAILED"
[ $FAILED -eq 0 ]
