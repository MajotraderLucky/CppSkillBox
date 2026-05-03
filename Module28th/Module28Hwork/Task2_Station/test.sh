#!/bin/bash
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"
BIN="$DIR/st"
g++ -std=c++17 -O0 -Wall -Wextra -pthread -o "$BIN" main.cpp || { echo "COMPILE FAIL"; exit 1; }

PASS=0; FAIL=0; TOTAL=0
run_test() {
    local desc="$1" expected="$2" actual="$3"
    TOTAL=$((TOTAL+1))
    if [ "$expected" = "$actual" ]; then echo "  [+] $desc"; PASS=$((PASS+1));
    else echo "  [X] $desc"; echo "    expected: $expected"; echo "    actual:   $actual"; FAIL=$((FAIL+1)); fi
}

# Test 1: 3 поезда → 3 EN ROUTE
ACT=$( (echo "1 2 3"; sleep 0.5; echo "depart A"; sleep 0.5; echo "depart B"; sleep 0.5; echo "depart C") \
       | timeout 10 "$BIN" --travel-ms=300 2>/dev/null | grep -c "EN ROUTE")
run_test "3 trains EN ROUTE" "3" "$ACT"

# Test 2: ALL DONE присутствует
ACT=$( (echo "1 2 3"; sleep 0.5; echo "depart A"; sleep 0.5; echo "depart B"; sleep 0.5; echo "depart C") \
       | timeout 10 "$BIN" --travel-ms=300 2>/dev/null | tail -1)
run_test "ends with ALL DONE" "ALL DONE" "$ACT"

# Test 3: каждый поезд DEPARTED
ACT=$( (echo "1 2 3"; sleep 0.5; echo "depart A"; sleep 0.5; echo "depart B"; sleep 0.5; echo "depart C") \
       | timeout 10 "$BIN" --travel-ms=300 2>/dev/null | grep -c "DEPARTED")
run_test "3 DEPARTED messages" "3" "$ACT"

# Test 4: каждый поезд AT STATION хотя бы раз
ACT=$( (echo "1 2 3"; sleep 0.5; echo "depart A"; sleep 0.5; echo "depart B"; sleep 0.5; echo "depart C") \
       | timeout 10 "$BIN" --travel-ms=300 2>/dev/null | grep -c "AT STATION")
run_test "3 AT STATION messages" "3" "$ACT"

# Test 5: A прибывает первым (travel=1)
ACT=$( (echo "1 2 3"; sleep 0.5; echo "depart A"; sleep 0.5; echo "depart B"; sleep 0.5; echo "depart C") \
       | timeout 10 "$BIN" --travel-ms=300 2>/dev/null | grep "AT STATION" | head -1)
run_test "A first to station" "A AT STATION" "$ACT"

# Test 6: A departed раньше всех (приоритет очереди)
ACT=$( (echo "1 2 3"; sleep 0.5; echo "depart A"; sleep 0.5; echo "depart B"; sleep 0.5; echo "depart C") \
       | timeout 10 "$BIN" --travel-ms=300 2>/dev/null | grep "DEPARTED" | head -1)
run_test "A departs first" "A DEPARTED" "$ACT"

echo ""
echo "Total: $TOTAL Passed: $PASS Failed: $FAIL"
[ $FAIL -eq 0 ]
