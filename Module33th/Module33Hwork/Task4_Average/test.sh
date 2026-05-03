#!/bin/bash
# M33.5 Task 4 — tests for templated average<T>
set -u
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN="$SCRIPT_DIR/build/average"

if [ ! -x "$BIN" ]; then
    cmake -S "$SCRIPT_DIR" -B "$SCRIPT_DIR/build" -DCMAKE_BUILD_TYPE=Release > /dev/null
    cmake --build "$SCRIPT_DIR/build" > /dev/null
fi

PASS=0
FAIL=0

run_test() {
    local name="$1" type="$2" input="$3" expected="$4"
    local actual
    # tail -1: skip "Fill the array (8):" prompt
    actual=$(printf "%s" "$input" | timeout 5 "$BIN" --type="$type" 2>/dev/null | tail -1)
    if [ "$actual" = "$expected" ]; then
        echo "[+] $name"; PASS=$((PASS+1))
    else
        echo "[X] $name"; echo "  expected: $expected"; echo "  actual:   $actual"
        FAIL=$((FAIL+1))
    fi
}

# Test 1: int 1..8 → average = (1+2+...+8)/8 = 36/8 = 4.5
run_test "int-1-to-8"  "int"    "1 2 3 4 5 6 7 8" "4.5"

# Test 2: all zeros
run_test "all-zeros"   "int"    "0 0 0 0 0 0 0 0" "0"

# Test 3: all same
run_test "all-tens"    "int"    "10 10 10 10 10 10 10 10" "10"

# Test 4: double values
run_test "doubles"     "double" "1.5 2.5 3.5 4.5 5.5 6.5 7.5 8.5" "5"

# Test 5: float values
run_test "floats"      "float"  "0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5" "0.5"

# Test 6: long values
run_test "longs"       "long"   "100 200 300 400 500 600 700 800" "450"

# Test 7: negative ints
run_test "neg-ints"    "int"    "-1 -2 -3 -4 -5 -6 -7 -8" "-4.5"

# Test 8: mixed pos/neg → 0
run_test "balanced"    "int"    "-4 -3 -2 -1 1 2 3 4" "0"

echo
echo "Pass: $PASS, Fail: $FAIL"
[ $FAIL -eq 0 ]
