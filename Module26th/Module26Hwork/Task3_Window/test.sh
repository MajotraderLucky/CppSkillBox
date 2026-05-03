#!/bin/bash
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"
BIN="$DIR/wn"
g++ -std=c++17 -O0 -Wall -Wextra -o "$BIN" main.cpp || { echo "COMPILE FAIL"; exit 1; }

PASS=0; FAIL=0; TOTAL=0
run_test() {
    local desc="$1" expected="$2" actual="$3"
    TOTAL=$((TOTAL+1))
    if [ "$expected" = "$actual" ]; then echo "  [+] $desc"; PASS=$((PASS+1));
    else echo "  [X] $desc"; echo "    expected: $expected"; echo "    actual:   $actual"; FAIL=$((FAIL+1)); fi
}

# Test 1: close immediately
ACT=$(printf "%s\n" "close" | timeout 5 "$BIN" 2>/dev/null)
run_test "close immediately" "CLOSED" "$ACT"

# Test 2: move within bounds
ACT=$(printf "%s\n" "move 5 3" "close" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'MOVED to (5,3)\nCLOSED'
run_test "move within bounds" "$EXP" "$ACT"

# Test 3: move negative — clamped to 0
ACT=$(printf "%s\n" "move -10 -10" "close" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'MOVED to (0,0)\nCLOSED'
run_test "move negative clamped" "$EXP" "$ACT"

# Test 4: move beyond screen — clamped to edge
ACT=$(printf "%s\n" "move 100 100" "close" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'MOVED to (79,49)\nCLOSED'
run_test "move beyond clamped" "$EXP" "$ACT"

# Test 5: resize
ACT=$(printf "%s\n" "resize 20 10" "close" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'RESIZED to 20x10\nCLOSED'
run_test "basic resize" "$EXP" "$ACT"

# Test 6: resize negative → 0
ACT=$(printf "%s\n" "resize -5 -5" "close" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'RESIZED to 0x0\nCLOSED'
run_test "negative resize → 0x0" "$EXP" "$ACT"

# Test 7: display dimensions
ACT=$(printf "%s\n" "display" "close" | timeout 5 "$BIN" 2>/dev/null | wc -l)
# 50 строк экрана + 1 CLOSED = 51
run_test "display = 50 rows + close" "51" "$ACT"

# Test 8: display row width
ACT=$(printf "%s\n" "display" "close" | timeout 5 "$BIN" 2>/dev/null | head -1 | wc -c)
# 80 символов + перевод строки = 81
run_test "display row width = 80" "81" "$ACT"

# Test 9: window content (default 10x5 at 0,0 → first row contains 1's at cols 0-9)
ACT=$(printf "%s\n" "display" "close" | timeout 5 "$BIN" 2>/dev/null | head -1 | head -c 10)
run_test "first row content (default win)" "1111111111" "$ACT"

# Test 10: row 6 should be all zeros (window only height 5)
ACT=$(printf "%s\n" "display" "close" | timeout 5 "$BIN" 2>/dev/null | sed -n '6p' | head -c 15)
run_test "row 6 outside window" "000000000000000" "$ACT"

echo ""
echo "Total: $TOTAL Passed: $PASS Failed: $FAIL"
[ $FAIL -eq 0 ]
