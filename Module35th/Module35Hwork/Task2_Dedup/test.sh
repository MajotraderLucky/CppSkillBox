#!/bin/bash
# M35.6 Task 2 — dedup via lambda + unordered_set + unique_ptr
set -u
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN="$SCRIPT_DIR/build/dedup"

if [ ! -x "$BIN" ]; then
    cmake -S "$SCRIPT_DIR" -B "$SCRIPT_DIR/build" -DCMAKE_BUILD_TYPE=Release > /dev/null
    cmake --build "$SCRIPT_DIR/build" > /dev/null
fi

PASS=0
FAIL=0

run_test() {
    local name="$1" input="$2" expected="$3"
    local actual
    actual=$(timeout 5 "$BIN" --input="$input" 2>/dev/null)
    if [ "$actual" = "$expected" ]; then
        echo "[+] $name"; PASS=$((PASS+1))
    else
        echo "[X] $name"; echo "  expected: $expected"; echo "  actual:   $actual"
        FAIL=$((FAIL+1))
    fi
}

# Test 1: simple dups
run_test "simple-dups"     "1 2 1 3 2 4"        "1 2 3 4"

# Test 2: no dups
run_test "no-dups"         "1 2 3 4 5"          "1 2 3 4 5"

# Test 3: all same
run_test "all-same"        "7 7 7 7 7"          "7"

# Test 4: empty input — handled gracefully (just newline)
actual=$(echo -n "" | timeout 5 "$BIN" 2>/dev/null)
if [ "$actual" = "" ]; then
    echo "[+] empty-input"; PASS=$((PASS+1))
else
    echo "[X] empty-input (got: '$actual')"; FAIL=$((FAIL+1))
fi

# Test 5: preserves first-occurrence order
run_test "preserves-order" "5 1 5 1 3 2 5"      "5 1 3 2"

# Test 6: negative numbers
run_test "negative-numbers" "-1 -2 -1 -3 -2"    "-1 -2 -3"

# Source checks
check() {
    local name="$1"
    if eval "$2" > /dev/null 2>&1; then echo "[+] $name"; PASS=$((PASS+1))
    else echo "[X] $name"; FAIL=$((FAIL+1)); fi
}
check "uses-unordered_set" "grep -q 'unordered_set' '$SCRIPT_DIR/src/main.cpp'"
check "uses-unique_ptr"    "grep -q 'unique_ptr' '$SCRIPT_DIR/src/main.cpp'"
check "uses-lambda"        "grep -qE '\[\].*\(' '$SCRIPT_DIR/src/main.cpp'"
check "uses-range-for"     "grep -qE 'for *\(auto.*: ' '$SCRIPT_DIR/src/main.cpp'"

echo
echo "Pass: $PASS, Fail: $FAIL"
[ $FAIL -eq 0 ]
