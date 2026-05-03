#!/bin/bash
# Tests for M22.6 Task 1 — Phone Book
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

BIN="$DIR/pb"
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

# Test 1: add and lookup by phone
ACT=$(printf "%s\n" "69-70-30 Ivanov" "69-70-30" | timeout 5 "$BIN" 2>/dev/null)
run_test "add + lookup by phone" "Ivanov" "$ACT"

# Test 2: lookup by name
ACT=$(printf "%s\n" "69-70-30 Ivanov" "Ivanov" | timeout 5 "$BIN" 2>/dev/null)
run_test "add + lookup by name" "69-70-30" "$ACT"

# Test 3: same name, multiple phones
ACT=$(printf "%s\n" "111-11-11 Ivanov" "222-22-22 Ivanov" "Ivanov" | timeout 5 "$BIN" 2>/dev/null)
run_test "two phones for same name" "111-11-11 222-22-22" "$ACT"

# Test 4: phone not found
ACT=$(printf "%s\n" "999-99-99" | timeout 5 "$BIN" 2>/dev/null)
run_test "phone not found" "not found" "$ACT"

# Test 5: name not found
ACT=$(printf "%s\n" "Ivanov" | timeout 5 "$BIN" 2>/dev/null)
run_test "name not found" "not found" "$ACT"

# Test 6: phone reassign (overwrite name)
ACT=$(printf "%s\n" "111-11-11 Ivanov" "111-11-11 Petrov" "111-11-11" | timeout 5 "$BIN" 2>/dev/null)
run_test "reassign phone replaces name" "Petrov" "$ACT"

# Test 7: after reassign, old name reverse-index updated
ACT=$(printf "%s\n" "111-11-11 Ivanov" "111-11-11 Petrov" "Ivanov" | timeout 5 "$BIN" 2>/dev/null)
run_test "old name has no phone after reassign" "not found" "$ACT"

# Test 8: complex scenario with mixed lookups
ACT=$(printf "%s\n" \
    "100-00-00 Anna" \
    "200-00-00 Boris" \
    "300-00-00 Anna" \
    "Anna" \
    "200-00-00" \
    "Boris" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'100-00-00 300-00-00\nBoris\n200-00-00'
run_test "mixed lookups" "$EXP" "$ACT"

# Test 9: multiple distinct names, each unique phone
ACT=$(printf "%s\n" \
    "11-11-11 Aaa" \
    "22-22-22 Bbb" \
    "33-33-33 Ccc" \
    "Aaa" \
    "Bbb" \
    "Ccc" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'11-11-11\n22-22-22\n33-33-33'
run_test "three distinct names" "$EXP" "$ACT"

# Test 10: empty input → no output
ACT=$(printf "" | timeout 5 "$BIN" 2>/dev/null)
run_test "empty input" "" "$ACT"

echo ""
echo "Total: $TOTAL Passed: $PASS Failed: $FAIL"
[ $FAIL -eq 0 ]
