#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$DIR/substr"

if [ ! -x "$BIN" ] || [ "$DIR/main.cpp" -nt "$BIN" ]; then
    g++ -std=c++11 -Wall -Wextra "$DIR/main.cpp" -o "$BIN" || exit 1
fi

PASSED=0
FAILED=0
TOTAL=0

check() {
    TOTAL=$((TOTAL + 1))
    local name="$1"
    local input="$2"
    local expected="$3"
    local output
    output=$(printf "%s\n" "$input" | timeout 5 "$BIN" 2>/dev/null | tail -1)
    if [ "$output" = "$expected" ]; then
        echo "  PASS: $name"
        PASSED=$((PASSED + 1))
    else
        echo "  FAIL: $name (expected '$expected', got '$output')"
        FAILED=$((FAILED + 1))
    fi
}

echo "=== Task 3 — Substr tests ==="

# Spec examples
check "spec true:  Hello world / wor"   "Hello world
wor"           "true"
check "spec false: Hello world / banana" "Hello world
banana"        "false"

# Edge: empty needle
check "empty needle"                     "Hello

"                                        "true"

# Match at beginning
check "match at start"                   "Hello world
Hello"         "true"

# Match at end
check "match at end"                     "Hello world
world"         "true"

# Single char match
check "single char match"                "Hello
o"             "true"

# Single char no match
check "single char no match"             "Hello
z"             "false"

# Whole string equal
check "whole equal"                      "abc
abc"           "true"

# Needle longer than haystack
check "needle too long"                  "abc
abcdef"        "false"

# Case sensitive
check "case sensitive"                   "Hello
hello"         "false"

# Repeating pattern (классический failure case naive search)
check "aaaab in aaab"                    "aaab
aaab"          "true"
check "aab in aaaab"                     "aaaab
aab"           "true"

# Multiple matches — first wins
check "multiple bana in banana"          "banana
ana"           "true"

# Whitespace in haystack
check "with spaces"                      "Hello big world
big w"  "true"

echo ""
echo "Total: $TOTAL, Passed: $PASSED, Failed: $FAILED"
[ $FAILED -eq 0 ]
