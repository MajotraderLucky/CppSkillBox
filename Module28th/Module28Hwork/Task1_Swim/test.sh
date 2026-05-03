#!/bin/bash
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"
BIN="$DIR/sw"
g++ -std=c++17 -O0 -Wall -Wextra -pthread -o "$BIN" main.cpp || { echo "COMPILE FAIL"; exit 1; }

PASS=0; FAIL=0; TOTAL=0
run_test() {
    local desc="$1" expected="$2" actual="$3"
    TOTAL=$((TOTAL+1))
    if [ "$expected" = "$actual" ]; then echo "  [+] $desc"; PASS=$((PASS+1));
    else echo "  [X] $desc"; echo "    expected: $expected"; echo "    actual:   $actual"; FAIL=$((FAIL+1)); fi
}

# Names + speeds (skipping real time delays via --tick-ms=1)
INP="A B C D E F  10 20 25 5 50 100"   # speeds 100/50/25/20/10/5 → A, B, C, D, E, F
INP=$(echo "$INP" | tr ' ' '\n')

# Test 1: RESULTS line is present
ACT=$(echo "$INP" | timeout 10 "$BIN" --tick-ms=1 2>/dev/null | grep -c "RESULTS")
run_test "RESULTS line present" "1" "$ACT"

# Test 2: всего 6 результатов
ACT=$(echo "$INP" | timeout 10 "$BIN" --tick-ms=1 2>/dev/null | grep -E "^[A-F] [0-9]+s$" | wc -l)
run_test "6 finishers" "6" "$ACT"

# Test 3: F самый быстрый (speed=100 м/с → 1 сек)
ACT=$(echo "$INP" | timeout 10 "$BIN" --tick-ms=1 2>/dev/null | grep -A 6 "RESULTS" | tail -6 | head -1 | awk '{print $1}')
run_test "F fastest (speed 100)" "F" "$ACT"

# Test 4: A самый медленный из этих чисел? Нет — A=10, F=100, F быстрейший, A=10 не самый медленный.
# Speeds: A=10, B=20, C=25, D=5, E=50, F=100 — самый медленный D (5 м/с → 20 сек)
ACT=$(echo "$INP" | timeout 10 "$BIN" --tick-ms=1 2>/dev/null | tail -1 | awk '{print $1}')
run_test "D slowest (speed 5)" "D" "$ACT"

# Test 5: F время = 1 сек (100/100)
ACT=$(echo "$INP" | timeout 10 "$BIN" --tick-ms=1 2>/dev/null | grep -A 6 "RESULTS" | tail -6 | head -1 | awk '{print $2}')
run_test "F time = 1s" "1s" "$ACT"

# Test 6: D время = 20 сек (100/5)
ACT=$(echo "$INP" | timeout 10 "$BIN" --tick-ms=1 2>/dev/null | tail -1 | awk '{print $2}')
run_test "D time = 20s" "20s" "$ACT"

# Test 7: results sorted ascending
ACT=$(echo "$INP" | timeout 10 "$BIN" --tick-ms=1 2>/dev/null | grep -A 6 "RESULTS" | tail -6 | awk '{print $2}' | sed 's/s$//' | xargs)
SORTED=$(echo "$ACT" | tr ' ' '\n' | sort -n | xargs)
run_test "results sorted ascending" "$ACT" "$SORTED"

echo ""
echo "Total: $TOTAL Passed: $PASS Failed: $FAIL"
[ $FAIL -eq 0 ]
