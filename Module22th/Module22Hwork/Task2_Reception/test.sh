#!/bin/bash
# Tests for M22.6 Task 2 — Reception
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

BIN="$DIR/rc"
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

# Test 1: spec example
ACT=$(printf "%s\n" "Sidorov" "Ivanov" "Ivanov" "Petrov" "Next" "Next" "Next" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'Ivanov\nIvanov\nPetrov'
run_test "spec example" "$EXP" "$ACT"

# Test 2: full queue empty
ACT=$(printf "%s\n" "Sidorov" "Ivanov" "Petrov" "Next" "Next" "Next" "Next" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'Ivanov\nPetrov\nSidorov'
run_test "drain queue (extra Next ignored)" "$EXP" "$ACT"

# Test 3: same name many times
ACT=$(printf "%s\n" "Aaa" "Aaa" "Aaa" "Next" "Next" "Next" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'Aaa\nAaa\nAaa'
run_test "same name three times" "$EXP" "$ACT"

# Test 4: lex order with mixed surnames
ACT=$(printf "%s\n" "Zebrov" "Aaron" "Mendel" "Next" "Next" "Next" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'Aaron\nMendel\nZebrov'
run_test "lex sorted output" "$EXP" "$ACT"

# Test 5: interleaved add/Next
ACT=$(printf "%s\n" "Zaa" "Next" "Aaa" "Next" "Bbb" "Yyy" "Next" "Next" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'Zaa\nAaa\nBbb\nYyy'
run_test "interleaved add and Next" "$EXP" "$ACT"

# Test 6: Next on empty queue → no output
ACT=$(printf "%s\n" "Next" "Next" | timeout 5 "$BIN" 2>/dev/null)
run_test "Next on empty queue" "" "$ACT"

# Test 7: add then Next then add same name again
ACT=$(printf "%s\n" "Anna" "Next" "Anna" "Next" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'Anna\nAnna'
run_test "add-Next-add-Next same name" "$EXP" "$ACT"

# Test 8: case-sensitive lex order (uppercase < lowercase in ASCII)
ACT=$(printf "%s\n" "alice" "Bob" "Next" "Next" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'Bob\nalice'
run_test "case-sensitive lex order" "$EXP" "$ACT"

echo ""
echo "Total: $TOTAL Passed: $PASS Failed: $FAIL"
[ $FAIL -eq 0 ]
