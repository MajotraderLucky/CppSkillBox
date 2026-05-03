#!/bin/bash
# Tests for M23.4 Task 3 — Train
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

BIN="$DIR/tr"
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

# Test 1: all cars exactly 20 → no over/under, total 200
ACT=$(printf "20\n20\n20\n20\n20\n20\n20\n20\n20\n20\n" | timeout 5 "$BIN" 2>/dev/null)
run_test "all optimal → only TOTAL" "TOTAL: 200" "$ACT"

# Test 2: all cars 25 (overfull)
INP=$(printf "25\n%.0s" {1..10})
ACT=$(printf "%s" "$INP" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'OVER car 1: 25\nOVER car 2: 25\nOVER car 3: 25\nOVER car 4: 25\nOVER car 5: 25\nOVER car 6: 25\nOVER car 7: 25\nOVER car 8: 25\nOVER car 9: 25\nOVER car 10: 25\nTOTAL: 250'
run_test "all over → 10 OVER lines" "$EXP" "$ACT"

# Test 3: all cars 10 (underfull)
INP=$(printf "10\n%.0s" {1..10})
ACT=$(printf "%s" "$INP" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'UNDER car 1: 10\nUNDER car 2: 10\nUNDER car 3: 10\nUNDER car 4: 10\nUNDER car 5: 10\nUNDER car 6: 10\nUNDER car 7: 10\nUNDER car 8: 10\nUNDER car 9: 10\nUNDER car 10: 10\nTOTAL: 100'
run_test "all under → 10 UNDER lines" "$EXP" "$ACT"

# Test 4: mixed (over+under+optimal)
ACT=$(printf "25\n20\n10\n30\n20\n15\n20\n20\n20\n20\n" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'OVER car 1: 25\nOVER car 4: 30\nUNDER car 3: 10\nUNDER car 6: 15\nTOTAL: 200'
run_test "mixed (over first, then under)" "$EXP" "$ACT"

# Test 5: empty cars
INP=$(printf "0\n%.0s" {1..10})
ACT=$(printf "%s" "$INP" | timeout 5 "$BIN" 2>/dev/null)
ACT_LAST=$(echo "$ACT" | tail -1)
run_test "empty cars TOTAL=0" "TOTAL: 0" "$ACT_LAST"

# Test 6: ordering — OVER before UNDER (per spec)
ACT=$(printf "5\n25\n5\n25\n20\n20\n20\n20\n20\n20\n" | timeout 5 "$BIN" 2>/dev/null | head -4)
EXP=$'OVER car 2: 25\nOVER car 4: 25\nUNDER car 1: 5\nUNDER car 3: 5'
run_test "OVER section comes before UNDER" "$EXP" "$ACT"

echo ""
echo "Total: $TOTAL Passed: $PASS Failed: $FAIL"
[ $FAIL -eq 0 ]
