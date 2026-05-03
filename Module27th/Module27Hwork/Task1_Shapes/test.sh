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

# Circle radius=5, π·25 = 78.54
ACT=$(printf "%s\n" "circle 0 0 Red 5" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'CIRCLE color=Red area=78.54 bbox=10.00x10.00\nEXIT'
run_test "circle r=5" "$EXP" "$ACT"

# Square side=4, area=16
ACT=$(printf "%s\n" "square 1 2 Green 4" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'SQUARE color=Green area=16.00 bbox=4.00x4.00\nEXIT'
run_test "square s=4" "$EXP" "$ACT"

# Triangle side=2, area = 4·√3/4 = √3 ≈ 1.73, bbox 2 × √3 ≈ 1.73
ACT=$(printf "%s\n" "triangle 0 0 Blue 2" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'TRIANGLE color=Blue area=1.73 bbox=2.00x1.73\nEXIT'
run_test "triangle s=2" "$EXP" "$ACT"

# Rectangle 3x4 = 12
ACT=$(printf "%s\n" "rectangle 0 0 None 3 4" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'RECTANGLE color=None area=12.00 bbox=3.00x4.00\nEXIT'
run_test "rectangle 3x4" "$EXP" "$ACT"

# Multiple commands
ACT=$(printf "%s\n" "circle 0 0 Red 1" "square 0 0 Blue 2" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'CIRCLE color=Red area=3.14 bbox=2.00x2.00\nSQUARE color=Blue area=4.00 bbox=2.00x2.00\nEXIT'
run_test "multiple shapes" "$EXP" "$ACT"

# None color
ACT=$(printf "%s\n" "square 0 0 Yellow 5" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'SQUARE color=None area=25.00 bbox=5.00x5.00\nEXIT'
run_test "unknown color → None" "$EXP" "$ACT"

echo ""
echo "Total: $TOTAL Passed: $PASS Failed: $FAIL"
[ $FAIL -eq 0 ]
