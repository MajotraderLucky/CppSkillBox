#!/bin/bash
# Tests for M24.5 Task 2 — Birthday
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

BIN="$DIR/bd"
g++ -std=c++17 -O0 -Wall -Wextra -o "$BIN" main.cpp || { echo "COMPILE FAIL"; exit 1; }

PASS=0; FAIL=0; TOTAL=0

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

# Test 1: empty input → no birthdays
ACT=$(echo "end" | timeout 5 "$BIN" --today=05:03 2>/dev/null)
run_test "empty list" "Нет ближайших дней рождения" "$ACT"

# Test 2: one upcoming birthday
ACT=$(printf "%s\n" "Anna 1990/06/15" "end" | timeout 5 "$BIN" --today=05:03 2>/dev/null)
run_test "one upcoming birthday" "Ближайший: Anna 06/15" "$ACT"

# Test 3: one past birthday (skipped → none)
ACT=$(printf "%s\n" "Anna 1990/01/15" "end" | timeout 5 "$BIN" --today=05:03 2>/dev/null)
run_test "past birthday skipped" "Нет ближайших дней рождения" "$ACT"

# Test 4: birthday today
ACT=$(printf "%s\n" "Anna 1990/05/03" "end" | timeout 5 "$BIN" --today=05:03 2>/dev/null)
run_test "birthday today" "Сегодня день рождения у Anna!" "$ACT"

# Test 5: multiple birthdays today
ACT=$(printf "%s\n" "Anna 1990/05/03" "Boris 1985/05/03" "end" | timeout 5 "$BIN" --today=05:03 2>/dev/null)
EXP=$'Сегодня день рождения у Anna!\nСегодня день рождения у Boris!'
run_test "multiple birthdays today" "$EXP" "$ACT"

# Test 6: choose nearest from many
# Anna: 06/15 (43 days), Boris: 05/10 (7 days), Carol: 12/25 (>200 days)
ACT=$(printf "%s\n" "Anna 1990/06/15" "Boris 1985/05/10" "Carol 1990/12/25" "end" | timeout 5 "$BIN" --today=05:03 2>/dev/null)
run_test "chooses nearest in future" "Ближайший: Boris 05/10" "$ACT"

# Test 7: today + future combined
ACT=$(printf "%s\n" "Today 1990/05/03" "Anna 1990/06/15" "end" | timeout 5 "$BIN" --today=05:03 2>/dev/null)
EXP=$'Сегодня день рождения у Today!\nБлижайший: Anna 06/15'
run_test "today + future combined" "$EXP" "$ACT"

# Test 8: same-month future birthday
ACT=$(printf "%s\n" "Anna 1990/05/15" "end" | timeout 5 "$BIN" --today=05:03 2>/dev/null)
run_test "same month, later day" "Ближайший: Anna 05/15" "$ACT"

# Test 9: same month, earlier day → skipped
ACT=$(printf "%s\n" "Anna 1990/05/01" "end" | timeout 5 "$BIN" --today=05:03 2>/dev/null)
run_test "same month earlier day skipped" "Нет ближайших дней рождения" "$ACT"

echo ""
echo "Total: $TOTAL Passed: $PASS Failed: $FAIL"
[ $FAIL -eq 0 ]
