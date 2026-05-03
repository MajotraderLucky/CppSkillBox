#!/bin/bash
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"
BIN="$DIR/sh"
g++ -std=c++17 -O0 -Wall -Wextra -o "$BIN" main.cpp || { echo "COMPILE FAIL"; exit 1; }

PASS=0; FAIL=0; TOTAL=0
run_test() {
    local desc="$1" expected="$2" actual="$3"
    TOTAL=$((TOTAL+1))
    if [ "$expected" = "$actual" ]; then echo "  [+] $desc"; PASS=$((PASS+1));
    else echo "  [X] $desc"; echo "    expected: $expected"; echo "    actual:   $actual"; FAIL=$((FAIL+1)); fi
}

# Test 1: spec triangle 3,4,5
ACT=$(printf "%s\n" "triangle 3 4 5" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'Type: Triangle\nSquare: 6.00\nWidth: 5.00\nHeight: 5.00\nEXIT'
run_test "triangle 3,4,5 (Heron + bbox)" "$EXP" "$ACT"

# Test 2: circle r=5 → π·25 = 78.54, bbox 10x10
ACT=$(printf "%s\n" "circle 5" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'Type: Circle\nSquare: 78.54\nWidth: 10.00\nHeight: 10.00\nEXIT'
run_test "circle r=5" "$EXP" "$ACT"

# Test 3: rectangle 3x4 = 12
ACT=$(printf "%s\n" "rectangle 3 4" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'Type: Rectangle\nSquare: 12.00\nWidth: 3.00\nHeight: 4.00\nEXIT'
run_test "rectangle 3x4" "$EXP" "$ACT"

# Test 4: equilateral triangle 6,6,6 → s²·√3/4 = 36·√3/4 ≈ 15.59
ACT=$(printf "%s\n" "triangle 6 6 6" "exit" | timeout 5 "$BIN" 2>/dev/null | head -2 | tail -1)
run_test "equilateral 6,6,6 area ~ 15.59" "Square: 15.59" "$ACT"

# Test 5: multiple shapes in one run
ACT=$(printf "%s\n" "circle 1" "rectangle 2 3" "exit" | timeout 5 "$BIN" 2>/dev/null | grep -c "^Type:")
run_test "2 Type: lines" "2" "$ACT"

# Test 6: square 5x5 (специальный случай)
ACT=$(printf "%s\n" "rectangle 5 5" "exit" | timeout 5 "$BIN" 2>/dev/null | head -2 | tail -1)
run_test "rectangle 5x5 area = 25" "Square: 25.00" "$ACT"

echo ""
echo "Total: $TOTAL Passed: $PASS Failed: $FAIL"
[ $FAIL -eq 0 ]
