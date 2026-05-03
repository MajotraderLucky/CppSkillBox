#!/bin/bash
# M31.5 Task 1 — tests for Dog with std::shared_ptr<Toy>
# NOTE: "Toy <name> was dropped " has a trailing space — это из спецификации задания.
set -u
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN="$SCRIPT_DIR/build/toys"

if [ ! -x "$BIN" ]; then
    cmake -S "$SCRIPT_DIR" -B "$SCRIPT_DIR/build" -DCMAKE_BUILD_TYPE=Release > /dev/null
    cmake --build "$SCRIPT_DIR/build" > /dev/null
fi

PASS=0
FAIL=0

run_test() {
    local name="$1"
    local input="$2"
    local expected="$3"
    local actual
    # strip trailing whitespace per line (Toy::~Toy prints "was dropped " with trailing space)
    actual=$(printf "%s" "$input" | timeout 5 "$BIN" 2>/dev/null | sed 's/[[:space:]]*$//')
    expected=$(printf "%s" "$expected" | sed 's/[[:space:]]*$//')
    if [ "$actual" = "$expected" ]; then
        echo "[+] $name"
        PASS=$((PASS+1))
    else
        echo "[X] $name"
        echo "    expected:"
        echo "$expected" | sed 's/^/      |/'
        echo "    actual:"
        echo "$actual" | sed 's/^/      |/'
        FAIL=$((FAIL+1))
    fi
}

# Test 1: simple pickup + drop
run_test "pickup-then-drop" \
"pickup Sharik ball
drop Sharik
exit
" \
"Sharik picks up ball
Sharik drops ball
Toy ball was dropped "

# Test 2: same dog tries to pick up own toy
run_test "already-have" \
"pickup Sharik ball
pickup Sharik ball
exit
" \
"Sharik picks up ball
I already have this toy
Toy ball was dropped "

# Test 3: another dog tries to pick up busy toy
run_test "another-dog-busy" \
"pickup Sharik ball
pickup Druzhok ball
exit
" \
"Sharik picks up ball
Another dog is playing with this toy
Toy ball was dropped "

# Test 4: drop empty
run_test "drop-empty" \
"drop Sharik
exit
" \
"Nothing to drop"

# Test 5: drop then another picks
run_test "transfer-via-drop" \
"pickup Sharik ball
drop Sharik
pickup Druzhok ball
drop Druzhok
exit
" \
"Sharik picks up ball
Sharik drops ball
Druzhok picks up ball
Druzhok drops ball
Toy ball was dropped "

# Test 6: multi-toys, multi-dogs (alphabetical map destruction)
run_test "multi-toys" \
"pickup A ball
pickup B bone
pickup C ball
drop A
pickup C ball
exit
" \
"A picks up ball
B picks up bone
Another dog is playing with this toy
A drops ball
C picks up ball
Toy ball was dropped
Toy bone was dropped "

# Test 7: drop twice in a row → second is empty
run_test "drop-twice" \
"pickup Sharik ball
drop Sharik
drop Sharik
exit
" \
"Sharik picks up ball
Sharik drops ball
Nothing to drop
Toy ball was dropped "

# Test 8: empty exit
run_test "exit-clean" \
"exit
" \
""

# Test 9: pickup → other tries → owner drops → other picks
run_test "release-and-acquire" \
"pickup Sharik ball
pickup Druzhok ball
drop Sharik
pickup Druzhok ball
exit
" \
"Sharik picks up ball
Another dog is playing with this toy
Sharik drops ball
Druzhok picks up ball
Toy ball was dropped "

echo
echo "Pass: $PASS, Fail: $FAIL"
[ $FAIL -eq 0 ]
