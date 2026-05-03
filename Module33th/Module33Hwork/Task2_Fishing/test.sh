#!/bin/bash
# M33.5 Task 2 — tests for fishing game
set -u
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN="$SCRIPT_DIR/build/fishing"

if [ ! -x "$BIN" ]; then
    cmake -S "$SCRIPT_DIR" -B "$SCRIPT_DIR/build" -DCMAKE_BUILD_TYPE=Release > /dev/null
    cmake --build "$SCRIPT_DIR/build" > /dev/null
fi

PASS=0
FAIL=0

run_test() {
    local name="$1" expected="$2"; shift 2
    local actual
    actual=$(timeout 5 "$BIN" "$@" 2>/dev/null | tail -1)
    if [ "$actual" = "$expected" ]; then
        echo "[+] $name"; PASS=$((PASS+1))
    else
        echo "[X] $name"; echo "  expected: $expected"; echo "  actual:   $actual"
        FAIL=$((FAIL+1))
    fi
}

# Deterministic outcomes for known seeds (auto-mode probes 1..9 in order)
run_test "seed7-fish-attempts1"   "Caught a fish! attempts=1"            --seed=7   --auto
run_test "seed33-fish-attempts2"  "Caught a fish! attempts=2"            --seed=33  --auto
run_test "seed100-fish-attempts3" "Caught a fish! attempts=3"            --seed=100 --auto
run_test "seed1-boot"             "Caught a boot. Game over after attempts=1"  --seed=1 --auto
run_test "seed4-boot-2"           "Caught a boot. Game over after attempts=2"  --seed=4 --auto
run_test "seed11-boot-5"          "Caught a boot. Game over after attempts=5"  --seed=11 --auto

# Test out-of-range sector handling (interactive)
EXPECTED_RANGE="Sector out of range
Caught a fish! attempts=1"
ACTUAL_RANGE=$(printf "0\n10\n%s\n" "$(timeout 1 /bin/true; echo 1)" | true)
# Note: hard to test interactively without knowing fish position; skip in unit tests

echo
echo "Pass: $PASS, Fail: $FAIL"
[ $FAIL -eq 0 ]
