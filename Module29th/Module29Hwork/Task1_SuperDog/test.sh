#!/bin/bash
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"
BIN="$DIR/sd"
g++ -std=c++17 -O0 -Wall -Wextra -o "$BIN" main.cpp || { echo "COMPILE FAIL"; exit 1; }

PASS=0; FAIL=0; TOTAL=0
run_test() {
    local desc="$1" expected="$2" actual="$3"
    TOTAL=$((TOTAL+1))
    if [ "$expected" = "$actual" ]; then echo "  [+] $desc"; PASS=$((PASS+1));
    else echo "  [X] $desc"; echo "    expected: $expected"; echo "    actual:   $actual"; FAIL=$((FAIL+1)); fi
}

# Test 1: spec example — Steve, dance + swim
ACT=$(printf "%s\n" "Steve" "dance" "swim" "show" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'This is Steve and it has some talents:\n   It can "Dance"\n   It can "Swim"'
run_test "spec example Steve dance+swim" "$EXP" "$ACT"

# Test 2: empty talents
ACT=$(printf "%s\n" "Rex" "show" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP="This is Rex and it has some talents:"
run_test "no talents shown" "$EXP" "$ACT"

# Test 3: all 3 talents
ACT=$(printf "%s\n" "Bobik" "dance" "swim" "count" "show" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'This is Bobik and it has some talents:\n   It can "Dance"\n   It can "Swim"\n   It can "Count"'
run_test "all 3 talents" "$EXP" "$ACT"

# Test 4: same talent twice
ACT=$(printf "%s\n" "Doggy" "swim" "swim" "show" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'This is Doggy and it has some talents:\n   It can "Swim"\n   It can "Swim"'
run_test "duplicate talent allowed" "$EXP" "$ACT"

# Test 5: order preserved
ACT=$(printf "%s\n" "Jack" "count" "dance" "swim" "show" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'This is Jack and it has some talents:\n   It can "Count"\n   It can "Dance"\n   It can "Swim"'
run_test "order preserved" "$EXP" "$ACT"

# Test 6: multiple show
ACT=$(printf "%s\n" "Rex" "swim" "show" "dance" "show" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'This is Rex and it has some talents:\n   It can "Swim"\nThis is Rex and it has some talents:\n   It can "Swim"\n   It can "Dance"'
run_test "show twice with growth" "$EXP" "$ACT"

echo ""
echo "Total: $TOTAL Passed: $PASS Failed: $FAIL"
[ $FAIL -eq 0 ]
