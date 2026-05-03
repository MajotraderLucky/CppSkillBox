#!/bin/bash
# Tests for M21.5 Task 4 — Turn-Based RPG
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

BIN="$DIR/rpg"
g++ -std=c++17 -O0 -Wall -Wextra -o "$BIN" main.cpp || { echo "COMPILE FAIL"; exit 1; }

PASS=0; FAIL=0; TOTAL=0
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

run_test() {
    local desc="$1" expected="$2" actual="$3"
    TOTAL=$((TOTAL+1))
    if [ "$expected" = "$actual" ]; then
        echo "  [+] $desc"
        PASS=$((PASS+1))
    else
        echo "  [X] $desc"
        echo "    expected: $expected"
        echo "    actual:   $actual"
        FAIL=$((FAIL+1))
    fi
}

# Test 1: initial map renders 20×20 grid with chars
# We use --once to do single command then exit, --seed for determinism.
cd "$TMPDIR"
ACT=$(printf "%s\n" "Hero" "100" "20" "30" "q" | timeout 5 "$BIN" --once --seed=42 2>/dev/null | wc -l)
# initial render 20 lines + "Выход" = 21 lines
run_test "initial map renders 20 rows + exit" "21" "$ACT"

# Test 2: count P and E on map
cd "$TMPDIR"
OUT=$(printf "%s\n" "Hero" "100" "20" "30" "q" | timeout 5 "$BIN" --once --seed=42 2>/dev/null | head -20)
P_COUNT=$(echo "$OUT" | tr -d -c 'P' | wc -c)
E_COUNT=$(echo "$OUT" | tr -d -c 'E' | wc -c)
run_test "exactly 1 player on map" "1" "$P_COUNT"
run_test "exactly 5 enemies on map" "5" "$E_COUNT"

# Test 3: row width is 20
ACT=$(echo "$OUT" | head -1 | wc -c)
# 20 chars + newline = 21
run_test "row width is 20 chars" "21" "$ACT"

# Test 4: save creates file
cd "$TMPDIR"
rm -f save.bin
printf "%s\n" "Hero" "100" "20" "30" "save" | timeout 5 "$BIN" --once --seed=42 2>/dev/null > /dev/null
if [ -f save.bin ]; then
    run_test "save creates save.bin" "OK" "OK"
else
    run_test "save creates save.bin" "OK" "MISSING"
fi

# Test 5: save reports success
cd "$TMPDIR"
rm -f save.bin
ACT=$(printf "%s\n" "Hero" "100" "20" "30" "save" | timeout 5 "$BIN" --once --seed=42 2>/dev/null | tail -1)
run_test "save prints Сохранено" "Сохранено" "$ACT"

# Test 6: load without file reports missing
cd "$TMPDIR"
rm -f save.bin
ACT=$(printf "%s\n" "Hero" "100" "20" "30" "load" | timeout 5 "$BIN" --once --seed=42 2>/dev/null | tail -1)
run_test "load missing file" "Файл не найден" "$ACT"

# Test 7: save then load round-trip
cd "$TMPDIR"
rm -f save.bin
printf "%s\n" "Hero" "100" "20" "30" "save" | timeout 5 "$BIN" --once --seed=42 2>/dev/null > /dev/null
ACT=$(printf "%s\n" "Other" "50" "10" "5" "load" | timeout 5 "$BIN" --once --seed=99 2>/dev/null | tail -1)
run_test "load after save returns Загружено" "Загружено" "$ACT"

# Test 8: deterministic seeds give identical maps
cd "$TMPDIR"
M1=$(printf "%s\n" "Hero" "100" "20" "30" "q" | timeout 5 "$BIN" --once --seed=7 2>/dev/null | head -20)
M2=$(printf "%s\n" "Hero" "100" "20" "30" "q" | timeout 5 "$BIN" --once --seed=7 2>/dev/null | head -20)
if [ "$M1" = "$M2" ]; then
    run_test "same seed = same map" "OK" "OK"
else
    run_test "same seed = same map" "OK" "DIFFER"
fi

# Test 9: different seeds give different maps (probabilistic but very high prob)
cd "$TMPDIR"
M1=$(printf "%s\n" "Hero" "100" "20" "30" "q" | timeout 5 "$BIN" --once --seed=1 2>/dev/null | head -20)
M2=$(printf "%s\n" "Hero" "100" "20" "30" "q" | timeout 5 "$BIN" --once --seed=2 2>/dev/null | head -20)
if [ "$M1" != "$M2" ]; then
    run_test "different seeds = different maps" "OK" "OK"
else
    run_test "different seeds = different maps" "OK" "SAME"
fi

# Test 10: quit prints Выход
cd "$TMPDIR"
ACT=$(printf "%s\n" "Hero" "100" "20" "30" "q" | timeout 5 "$BIN" --once --seed=42 2>/dev/null | tail -1)
run_test "q prints Выход" "Выход" "$ACT"

echo ""
echo "Total: $TOTAL Passed: $PASS Failed: $FAIL"
[ $FAIL -eq 0 ]
