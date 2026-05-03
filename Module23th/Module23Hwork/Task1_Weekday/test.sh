#!/bin/bash
# Tests for M23.4 Task 1 — Weekday
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

BIN="$DIR/wd"
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

ACT=$(echo "1" | timeout 5 "$BIN" 2>/dev/null); run_test "1 → Monday"    "Monday"    "$ACT"
ACT=$(echo "2" | timeout 5 "$BIN" 2>/dev/null); run_test "2 → Tuesday"   "Tuesday"   "$ACT"
ACT=$(echo "3" | timeout 5 "$BIN" 2>/dev/null); run_test "3 → Wednesday" "Wednesday" "$ACT"
ACT=$(echo "4" | timeout 5 "$BIN" 2>/dev/null); run_test "4 → Thursday"  "Thursday"  "$ACT"
ACT=$(echo "5" | timeout 5 "$BIN" 2>/dev/null); run_test "5 → Friday"    "Friday"    "$ACT"
ACT=$(echo "6" | timeout 5 "$BIN" 2>/dev/null); run_test "6 → Saturday"  "Saturday"  "$ACT"
ACT=$(echo "7" | timeout 5 "$BIN" 2>/dev/null); run_test "7 → Sunday"    "Sunday"    "$ACT"

ACT=$(echo "0" | timeout 5 "$BIN" 2>/dev/null); run_test "0 → Неверный"  "Неверный номер" "$ACT"
ACT=$(echo "8" | timeout 5 "$BIN" 2>/dev/null); run_test "8 → Неверный"  "Неверный номер" "$ACT"

echo ""
echo "Total: $TOTAL Passed: $PASS Failed: $FAIL"
[ $FAIL -eq 0 ]
