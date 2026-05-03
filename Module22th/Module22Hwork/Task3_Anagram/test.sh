#!/bin/bash
# Tests for M22.6 Task 3 — Anagram
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

BIN="$DIR/an"
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

# Test 1: classic anagram (английский эквивалент)
ACT=$(printf "%s\n" "listen" "silent" | timeout 5 "$BIN" 2>/dev/null)
run_test "listen / silent → true" "true" "$ACT"

# Test 2: not anagram
ACT=$(printf "%s\n" "hello" "world" | timeout 5 "$BIN" 2>/dev/null)
run_test "hello / world → false" "false" "$ACT"

# Test 3: identical strings (technically anagrams)
ACT=$(printf "%s\n" "abc" "abc" | timeout 5 "$BIN" 2>/dev/null)
run_test "identical strings → true" "true" "$ACT"

# Test 4: different lengths
ACT=$(printf "%s\n" "abc" "abcd" | timeout 5 "$BIN" 2>/dev/null)
run_test "different lengths → false" "false" "$ACT"

# Test 5: same letters but different counts
ACT=$(printf "%s\n" "aab" "abb" | timeout 5 "$BIN" 2>/dev/null)
run_test "same letters different count → false" "false" "$ACT"

# Test 6: reversed string
ACT=$(printf "%s\n" "abcdef" "fedcba" | timeout 5 "$BIN" 2>/dev/null)
run_test "reversed string → true" "true" "$ACT"

# Test 7: case-sensitive (Apple != apple)
ACT=$(printf "%s\n" "Apple" "apple" | timeout 5 "$BIN" 2>/dev/null)
run_test "case-sensitive → false" "false" "$ACT"

# Test 8: with digits/symbols
ACT=$(printf "%s\n" "a1b2" "b2a1" | timeout 5 "$BIN" 2>/dev/null)
run_test "alphanumeric anagram → true" "true" "$ACT"

# Test 9: dormitory / dirtyroom (классический английский анаграмм)
ACT=$(printf "%s\n" "dormitory" "dirtyroom" | timeout 5 "$BIN" 2>/dev/null)
run_test "dormitory / dirtyroom → true" "true" "$ACT"

# Test 10: triangle / integral
ACT=$(printf "%s\n" "triangle" "integral" | timeout 5 "$BIN" 2>/dev/null)
run_test "triangle / integral → true" "true" "$ACT"

# Test 11: single char
ACT=$(printf "%s\n" "a" "a" | timeout 5 "$BIN" 2>/dev/null)
run_test "single char same → true" "true" "$ACT"

ACT=$(printf "%s\n" "a" "b" | timeout 5 "$BIN" 2>/dev/null)
run_test "single char different → false" "false" "$ACT"

echo ""
echo "Total: $TOTAL Passed: $PASS Failed: $FAIL"
[ $FAIL -eq 0 ]
