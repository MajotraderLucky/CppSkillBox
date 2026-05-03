#!/bin/bash
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"
BIN="$DIR/elv"
g++ -std=c++17 -O0 -Wall -Wextra -o "$BIN" main.cpp || { echo "COMPILE FAIL"; exit 1; }

PASS=0; FAIL=0; TOTAL=0
run_test() {
    local desc="$1" expected="$2" actual="$3"
    TOTAL=$((TOTAL+1))
    if [ "$expected" = "$actual" ]; then echo "  [+] $desc"; PASS=$((PASS+1));
    else echo "  [X] $desc"; echo "    expected: $expected"; echo "    actual:   $actual"; FAIL=$((FAIL+1)); fi
}

# helper: 1000 None'ов как input для populate (избыток ОК — populate читает сколько надо)
all_none() {
    for i in $(seq 1 1000); do echo "None"; done
}

# Test 1: NOT FOUND — никого не заселили
ACT=$(all_none | timeout 5 "$BIN" --seed=42 --target=Solo 2>/dev/null)
run_test "NOT FOUND when nobody settled" "NOT FOUND" "$ACT"

# Test 2: Заселим первый дом → одиночка → 0 соседей
INP="Solo"
for i in $(seq 1 999); do INP="$INP None"; done
ACT=$(echo "$INP" | tr ' ' '\n' | timeout 5 "$BIN" --seed=42 --target=Solo 2>/dev/null)
run_test "single elf alone → 0" "NEIGHBOURS: 0" "$ACT"

# Test 3: Заселим первые два дома (одна большая ветвь + первая средняя)
INP="A B"
for i in $(seq 1 998); do INP="$INP None"; done
ACT=$(echo "$INP" | tr ' ' '\n' | timeout 5 "$BIN" --seed=42 --target=A 2>/dev/null)
run_test "two elves same big-branch → 1" "NEIGHBOURS: 1" "$ACT"

# Test 4: Поиск второго эльфа в той же ветви — тоже 1
ACT=$(echo "$INP" | tr ' ' '\n' | timeout 5 "$BIN" --seed=42 --target=B 2>/dev/null)
run_test "two elves search second → 1" "NEIGHBOURS: 1" "$ACT"

# Test 5: Заселим первые 5 домов
INP="A B C D E"
for i in $(seq 1 995); do INP="$INP None"; done
ACT=$(echo "$INP" | tr ' ' '\n' | timeout 5 "$BIN" --seed=42 --target=A 2>/dev/null)
case "$ACT" in
    "NEIGHBOURS: "*) run_test "5 elves, found A" "OK" "OK" ;;
    *) run_test "5 elves, found A" "OK" "BAD: $ACT" ;;
esac

# Test 6: NOT FOUND для несуществующего имени даже с заселёнными
ACT=$(echo "$INP" | tr ' ' '\n' | timeout 5 "$BIN" --seed=42 --target=Nobody 2>/dev/null)
run_test "settled but not found target" "NOT FOUND" "$ACT"

# Test 7: разный seed работает
ACT=$(all_none | timeout 5 "$BIN" --seed=7 --target=Anyone 2>/dev/null)
run_test "different seed NOT FOUND" "NOT FOUND" "$ACT"

# Test 8: одного эльфа на дереве находим
INP="X"
for i in $(seq 1 999); do INP="$INP None"; done
ACT=$(echo "$INP" | tr ' ' '\n' | timeout 5 "$BIN" --seed=1 --target=X 2>/dev/null)
run_test "find lone X (seed=1)" "NEIGHBOURS: 0" "$ACT"

echo ""
echo "Total: $TOTAL Passed: $PASS Failed: $FAIL"
[ $FAIL -eq 0 ]
