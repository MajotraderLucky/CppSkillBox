#!/bin/bash
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"
BIN="$DIR/pl"
g++ -std=c++17 -O0 -Wall -Wextra -o "$BIN" main.cpp || { echo "COMPILE FAIL"; exit 1; }

PASS=0; FAIL=0; TOTAL=0
run_test() {
    local desc="$1" expected="$2" actual="$3"
    TOTAL=$((TOTAL+1))
    if [ "$expected" = "$actual" ]; then echo "  [+] $desc"; PASS=$((PASS+1));
    else echo "  [X] $desc"; echo "    expected: $expected"; echo "    actual:   $actual"; FAIL=$((FAIL+1)); fi
}

# Test 1: play known
ACT=$(printf "%s\n" "play Song1" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'TRACK: Song1 (2024-1-15, 180s)\nEXIT'
run_test "play Song1" "$EXP" "$ACT"

# Test 2: play unknown
ACT=$(printf "%s\n" "play Nope" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'NOT FOUND: Nope\nEXIT'
run_test "play unknown" "$EXP" "$ACT"

# Test 3: play -> pause -> stop
ACT=$(printf "%s\n" "play Song2" "pause" "stop" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'TRACK: Song2 (2024-5-20, 240s)\nPAUSED: Song2\nSTOPPED: Song2\nEXIT'
run_test "play+pause+stop" "$EXP" "$ACT"

# Test 4: stop without play (no output)
ACT=$(printf "%s\n" "stop" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP="EXIT"
run_test "stop without play" "$EXP" "$ACT"

# Test 5: pause without play
ACT=$(printf "%s\n" "pause" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP="EXIT"
run_test "pause without play" "$EXP" "$ACT"

# Test 6: play same already playing (ignored)
ACT=$(printf "%s\n" "play Song1" "play Song2" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'TRACK: Song1 (2024-1-15, 180s)\nEXIT'
run_test "second play ignored if playing" "$EXP" "$ACT"

# Test 7: stop then second stop is no-op
ACT=$(printf "%s\n" "play Song1" "stop" "stop" "exit" | timeout 5 "$BIN" 2>/dev/null)
EXP=$'TRACK: Song1 (2024-1-15, 180s)\nSTOPPED: Song1\nEXIT'
run_test "double stop ignored" "$EXP" "$ACT"

# Test 8: next with deterministic seed
ACT=$(printf "%s\n" "next" "exit" | timeout 5 "$BIN" --seed=1 2>/dev/null | head -1)
# rand() % 3 with srand(1) — varies by libc but consistent
# Let's just check format starts with "NEXT (shuffle):"
case "$ACT" in
    "NEXT (shuffle): "*) run_test "next outputs NEXT prefix" "OK" "OK" ;;
    *) run_test "next outputs NEXT prefix" "OK" "BAD: $ACT" ;;
esac

echo ""
echo "Total: $TOTAL Passed: $PASS Failed: $FAIL"
[ $FAIL -eq 0 ]
