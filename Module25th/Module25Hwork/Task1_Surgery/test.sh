#!/bin/bash
# Tests for M25.4 Task 1 — Surgery
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

# Build with CMake
rm -rf build
mkdir build
(cd build && cmake .. > /dev/null && cmake --build . > /dev/null) || {
    echo "BUILD FAIL"; exit 1;
}
BIN="$DIR/build/surgery"

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

# Test 1: full operation
ACT=$(printf "%s\n" "scalpel 1 2 3 4" "hemostat 5 5" "tweezers 6 6" "suture 7 7 7 7" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'SCALPEL: cut from (1,2) to (3,4)\nHEMOSTAT: clamp at (5,5)\nTWEEZERS: pick at (6,6)\nSUTURE: stitch from (7,7) to (7,7)\nOPERATION COMPLETE'
run_test "full operation" "$EXP" "$ACT"

# Test 2: continues if suture points differ
ACT=$(printf "%s\n" "scalpel 0 0 1 1" "suture 2 2 3 3" "suture 4 4 4 4" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'SCALPEL: cut from (0,0) to (1,1)\nSUTURE: stitch from (2,2) to (3,3)\nSUTURE: stitch from (4,4) to (4,4)\nOPERATION COMPLETE'
run_test "suture matches → exit" "$EXP" "$ACT"

# Test 3: hemostat without scalpel ignored
ACT=$(printf "%s\n" "hemostat 1 1" "scalpel 0 0 1 1" "suture 2 2 2 2" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'SCALPEL: cut from (0,0) to (1,1)\nSUTURE: stitch from (2,2) to (2,2)\nOPERATION COMPLETE'
run_test "hemostat-before-scalpel ignored" "$EXP" "$ACT"

# Test 4: explicit exit
ACT=$(printf "%s\n" "scalpel 0 0 1 1" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'SCALPEL: cut from (0,0) to (1,1)\nEXIT'
run_test "explicit exit" "$EXP" "$ACT"

# Test 5: floating-point coords
ACT=$(printf "%s\n" "scalpel 1.5 2.5 3.5 4.5" "suture 0.0 0.0 0.0 0.0" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'SCALPEL: cut from (1.5,2.5) to (3.5,4.5)\nSUTURE: stitch from (0,0) to (0,0)\nOPERATION COMPLETE'
run_test "floating-point coordinates" "$EXP" "$ACT"

# Test 6: tweezers + hemostat sequence
ACT=$(printf "%s\n" "scalpel 0 0 0 0" "hemostat 1 1" "tweezers 2 2" "hemostat 3 3" "suture 0 0 0 0" | timeout 5 "$BIN" 2>/dev/null | wc -l)
run_test "5 actions = 5 output lines + complete" "6" "$ACT"

echo ""
echo "Total: $TOTAL Passed: $PASS Failed: $FAIL"
[ $FAIL -eq 0 ]
