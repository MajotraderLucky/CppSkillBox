#!/bin/bash
# Tests for M24.5 Task 3 — Timer
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

BIN="$DIR/tm"
g++ -std=c++17 -O0 -Wall -Wextra -pthread -o "$BIN" main.cpp || { echo "COMPILE FAIL"; exit 1; }

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

# Test 1: 0 seconds → immediately DING
ACT=$(echo "00:00" | timeout 5 "$BIN" --no-sleep 2>/dev/null)
run_test "00:00 → ding immediately" "DING! DING! DING!" "$ACT"

# Test 2: 3 seconds countdown
ACT=$(echo "00:03" | timeout 5 "$BIN" --no-sleep 2>/dev/null)
EXP=$'00:03\n00:02\n00:01\nDING! DING! DING!'
run_test "00:03 countdown" "$EXP" "$ACT"

# Test 3: 1 minute 30 seconds (90 sec) — first and last lines
OUT=$(echo "01:30" | timeout 5 "$BIN" --no-sleep 2>/dev/null)
ACT_FIRST=$(echo "$OUT" | head -1)
ACT_LAST=$(echo "$OUT" | tail -1)
ACT_COUNT=$(echo "$OUT" | wc -l)
run_test "01:30 first line" "01:30" "$ACT_FIRST"
run_test "01:30 last line" "DING! DING! DING!" "$ACT_LAST"
run_test "01:30 line count = 91" "91" "$ACT_COUNT"

# Test 4: 60-second mark transitions correctly
ACT=$(echo "01:00" | timeout 5 "$BIN" --no-sleep 2>/dev/null | head -3)
EXP=$'01:00\n00:59\n00:58'
run_test "01:00 → 00:59 transition" "$EXP" "$ACT"

# Test 5: format always 2 digits
ACT=$(echo "00:05" | timeout 5 "$BIN" --no-sleep 2>/dev/null | head -1)
run_test "leading zeros in MM:SS" "00:05" "$ACT"

echo ""
echo "Total: $TOTAL Passed: $PASS Failed: $FAIL"
[ $FAIL -eq 0 ]
