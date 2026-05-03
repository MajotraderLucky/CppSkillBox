#!/bin/bash
# Tests for M25.4 Task 2 — Computer (multi-module)
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

# Build
rm -rf build
mkdir build
(cd build && cmake .. > /dev/null && cmake --build . > /dev/null) || {
    echo "BUILD FAIL"; exit 1;
}
BIN="$DIR/build/src/computer"

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

WORKDIR=$(mktemp -d)
trap 'rm -rf "$WORKDIR"' EXIT

# Test 1: input + display
ACT=$(cd "$WORKDIR" && printf "%s\n" "input 1 2 3 4 5 6 7 8" "display" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'INPUT OK\nGPU: 1 2 3 4 5 6 7 8\nEXIT'
run_test "input + display" "$EXP" "$ACT"

# Test 2: input + sum
ACT=$(cd "$WORKDIR" && printf "%s\n" "input 10 20 30 40 50 60 70 80" "sum" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'INPUT OK\nSUM: 360\nEXIT'
run_test "input + sum" "$EXP" "$ACT"

# Test 3: zero RAM sum
ACT=$(cd "$WORKDIR" && printf "%s\n" "sum" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'SUM: 0\nEXIT'
run_test "fresh RAM sum=0" "$EXP" "$ACT"

# Test 4: save + load cycle
W2=$(mktemp -d); trap 'rm -rf "$WORKDIR" "$W2"' EXIT
cd "$W2"
ACT1=$(printf "%s\n" "input 1 2 3 4 5 6 7 8" "save" "exit" | timeout 5 "$BIN" 2>/dev/null)
ACT2=$(printf "%s\n" "load" "display" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP1=$'INPUT OK\nSAVE OK\nEXIT'
EXP2=$'LOAD OK\nGPU: 1 2 3 4 5 6 7 8\nEXIT'
run_test "save phase" "$EXP1" "$ACT1"
run_test "load+display phase" "$EXP2" "$ACT2"

# Test 5: load without save → fail (no data.txt)
W3=$(mktemp -d); trap 'rm -rf "$WORKDIR" "$W2" "$W3"' EXIT
cd "$W3"
ACT=$(printf "%s\n" "load" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'LOAD FAIL\nEXIT'
run_test "load without data.txt → FAIL" "$EXP" "$ACT"

# Test 6: input ovewrite + sum
W4=$(mktemp -d); trap 'rm -rf "$WORKDIR" "$W2" "$W3" "$W4"' EXIT
cd "$W4"
ACT=$(printf "%s\n" "input 1 1 1 1 1 1 1 1" "sum" "input 2 2 2 2 2 2 2 2" "sum" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'INPUT OK\nSUM: 8\nINPUT OK\nSUM: 16\nEXIT'
run_test "second input overwrites" "$EXP" "$ACT"

echo ""
echo "Total: $TOTAL Passed: $PASS Failed: $FAIL"
[ $FAIL -eq 0 ]
