#!/bin/bash
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"
BIN="$DIR/ph"
g++ -std=c++17 -O0 -Wall -Wextra -o "$BIN" main.cpp || { echo "COMPILE FAIL"; exit 1; }

PASS=0; FAIL=0; TOTAL=0
run_test() {
    local desc="$1" expected="$2" actual="$3"
    TOTAL=$((TOTAL+1))
    if [ "$expected" = "$actual" ]; then echo "  [+] $desc"; PASS=$((PASS+1));
    else echo "  [X] $desc"; echo "    expected: $expected"; echo "    actual:   $actual"; FAIL=$((FAIL+1)); fi
}

# Test 1: add + call by name
ACT=$(printf "%s\n" "add Anna +71234567890" "call Anna" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'ADDED: Anna +71234567890\nCALL +71234567890\nEXIT'
run_test "add + call by name" "$EXP" "$ACT"

# Test 2: call by direct number
ACT=$(printf "%s\n" "call +79991112233" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'CALL +79991112233\nEXIT'
run_test "call by direct number" "$EXP" "$ACT"

# Test 3: sms by name
ACT=$(printf "%s\n" "add Boris +71112223344" "sms Boris Hello world" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'ADDED: Boris +71112223344\nSMS +71112223344: Hello world\nEXIT'
run_test "sms by name" "$EXP" "$ACT"

# Test 4: invalid phone format
ACT=$(printf "%s\n" "add Bad 12345" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'INVALID PHONE: 12345\nEXIT'
run_test "invalid phone rejected" "$EXP" "$ACT"

# Test 5: call unknown name
ACT=$(printf "%s\n" "call NoOne" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'NOT FOUND: NoOne\nEXIT'
run_test "call unknown name" "$EXP" "$ACT"

# Test 6: invalid phone format wrong country
ACT=$(printf "%s\n" "add Bad +12345678901" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'INVALID PHONE: +12345678901\nEXIT'
run_test "non +7 number rejected" "$EXP" "$ACT"

# Test 7: multiple contacts
ACT=$(printf "%s\n" "add Anna +71111111111" "add Boris +72222222222" "call Boris" "call Anna" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'ADDED: Anna +71111111111\nADDED: Boris +72222222222\nCALL +72222222222\nCALL +71111111111\nEXIT'
run_test "multiple contacts" "$EXP" "$ACT"

# Test 8: sms by direct number
ACT=$(printf "%s\n" "sms +79998887766 Hi" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'SMS +79998887766: Hi\nEXIT'
run_test "sms by number" "$EXP" "$ACT"

echo ""
echo "Total: $TOTAL Passed: $PASS Failed: $FAIL"
[ $FAIL -eq 0 ]
