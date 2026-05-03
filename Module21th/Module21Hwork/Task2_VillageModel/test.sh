#!/bin/bash
# Tests for M21.5 Task 2 — Village Model
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

BIN="$DIR/vm"
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

# Test 1: empty village
ACT=$(echo "0" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'plots=0\ncoverage=0.00%'
run_test "empty village" "$EXP" "$ACT"

# Test 2: one plot, no buildings
INP=$(printf "%s\n" "1" "1 1000.0" "0")
ACT=$(echo "$INP" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'plots=1\nplot#1 area=1000 built=0\ncoverage=0.00%'
run_test "one plot, no buildings" "$EXP" "$ACT"

# Test 3: one plot with garage only
INP=$(printf "%s\n" "1" "1 1000.0" "1" "garage 30.0")
ACT=$(echo "$INP" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'plots=1\nplot#1 area=1000 built=30\ncoverage=3.00%'
run_test "one plot with garage" "$EXP" "$ACT"

# Test 4: one plot with house (1 floor, 2 rooms, no stove) + bath
# house: area=80, 1 floor (height=2.7), 2 rooms (kitchen=15, bedroom=20), no stove
# bath: area=20, no stove
INP=$(printf "%s\n" \
    "1" "1 1000.0" "2" \
    "house 80.0 1 2.7 2 2 15.0 4 20.0 0" \
    "bath 20.0 0")
ACT=$(echo "$INP" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'plots=1\nplot#1 area=1000 built=100 floors=1 rooms=2\ncoverage=10.00%'
run_test "house + bath, no stoves" "$EXP" "$ACT"

# Test 5: two plots aggregated
# plot1: area 500, built 50 (garage)
# plot2: area 500, built 100 (shed 100)
INP=$(printf "%s\n" \
    "2" \
    "1 500.0" "1" "garage 50.0" \
    "2 500.0" "1" "shed 100.0")
ACT=$(echo "$INP" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'plots=2\nplot#1 area=500 built=50\nplot#2 area=500 built=100\ncoverage=15.00%'
run_test "two plots, total coverage" "$EXP" "$ACT"

# Test 6: house with stove + 3 floors
# 3 floors: f1: 2.7m, 2 rooms; f2: 2.7m, 3 rooms; f3: 2.5m, 4 rooms => 9 rooms total
INP=$(printf "%s\n" \
    "1" "1 2000.0" "1" \
    "house 150.0 3 2.7 2 0 25.0 1 30.0 2.7 3 2 18.0 4 22.0 3 12.0 2.5 4 0 20.0 1 18.0 2 16.0 3 14.0 1 6.0")
ACT=$(echo "$INP" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'plots=1\nplot#1 area=2000 built=150 floors=3 rooms=9\ncoverage=7.50%'
run_test "house 3 floors with stove" "$EXP" "$ACT"

# Test 7: full plot — all four building types
# garage 25, shed 15, bath 20 (no stove), house 100 (1 floor, 2 rooms, with stove)
INP=$(printf "%s\n" \
    "1" "1 1000.0" "4" \
    "garage 25.0" \
    "shed 15.0" \
    "bath 20.0 0" \
    "house 100.0 1 2.7 2 2 15.0 4 20.0 1 5.0")
ACT=$(echo "$INP" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'plots=1\nplot#1 area=1000 built=160 floors=1 rooms=2\ncoverage=16.00%'
run_test "all four building types" "$EXP" "$ACT"

# Test 8: zero-area plot doesn't crash
INP=$(printf "%s\n" "1" "1 0.0" "0")
ACT=$(echo "$INP" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'plots=1\nplot#1 area=0 built=0\ncoverage=0.00%'
run_test "zero-area plot" "$EXP" "$ACT"

echo ""
echo "Total: $TOTAL Passed: $PASS Failed: $FAIL"
[ $FAIL -eq 0 ]
