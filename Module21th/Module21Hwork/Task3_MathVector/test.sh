#!/bin/bash
# Tests for M21.5 Task 3 — Math Vector
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

BIN="$DIR/mv"
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

# add
ACT=$(printf "%s\n" "add" "1 2" "3 4" | timeout 5 "$BIN" 2>/dev/null)
run_test "add (1,2)+(3,4)" "4.0000 6.0000" "$ACT"

ACT=$(printf "%s\n" "add" "-1 2" "1 -2" | timeout 5 "$BIN" 2>/dev/null)
run_test "add (-1,2)+(1,-2)" "0.0000 0.0000" "$ACT"

# subtract
ACT=$(printf "%s\n" "subtract" "5 7" "2 3" | timeout 5 "$BIN" 2>/dev/null)
run_test "subtract (5,7)-(2,3)" "3.0000 4.0000" "$ACT"

ACT=$(printf "%s\n" "subtract" "1 1" "1 1" | timeout 5 "$BIN" 2>/dev/null)
run_test "subtract identical" "0.0000 0.0000" "$ACT"

# scale
ACT=$(printf "%s\n" "scale" "1 2" "3" | timeout 5 "$BIN" 2>/dev/null)
run_test "scale (1,2)*3" "3.0000 6.0000" "$ACT"

ACT=$(printf "%s\n" "scale" "5 5" "0" | timeout 5 "$BIN" 2>/dev/null)
run_test "scale by 0" "0.0000 0.0000" "$ACT"

ACT=$(printf "%s\n" "scale" "2 -2" "-1" | timeout 5 "$BIN" 2>/dev/null)
run_test "scale by -1 (flip)" "-2.0000 2.0000" "$ACT"

# length
ACT=$(printf "%s\n" "length" "3 4" | timeout 5 "$BIN" 2>/dev/null)
run_test "length (3,4)=5" "5.0000" "$ACT"

ACT=$(printf "%s\n" "length" "0 0" | timeout 5 "$BIN" 2>/dev/null)
run_test "length zero vector" "0.0000" "$ACT"

ACT=$(printf "%s\n" "length" "1 0" | timeout 5 "$BIN" 2>/dev/null)
run_test "length unit x" "1.0000" "$ACT"

ACT=$(printf "%s\n" "length" "0 1" | timeout 5 "$BIN" 2>/dev/null)
run_test "length unit y" "1.0000" "$ACT"

# normalize
ACT=$(printf "%s\n" "normalize" "3 4" | timeout 5 "$BIN" 2>/dev/null)
run_test "normalize (3,4)" "0.6000 0.8000" "$ACT"

ACT=$(printf "%s\n" "normalize" "0 5" | timeout 5 "$BIN" 2>/dev/null)
run_test "normalize (0,5)" "0.0000 1.0000" "$ACT"

ACT=$(printf "%s\n" "normalize" "-4 0" | timeout 5 "$BIN" 2>/dev/null)
run_test "normalize negative x" "-1.0000 0.0000" "$ACT"

ACT=$(printf "%s\n" "normalize" "0 0" | timeout 5 "$BIN" 2>/dev/null)
run_test "normalize zero vector" "0.0000 0.0000" "$ACT"

# normalize then check length is 1.0
ACT=$(printf "%s\n" "normalize" "7 11" | timeout 5 "$BIN" 2>/dev/null)
# sqrt(170)=13.0384, x/L=0.5369..., y/L=0.8437...
run_test "normalize (7,11)" "0.5369 0.8437" "$ACT"

echo ""
echo "Total: $TOTAL Passed: $PASS Failed: $FAIL"
[ $FAIL -eq 0 ]
