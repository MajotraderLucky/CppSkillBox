#!/bin/bash
# Tests for M24.5 Task 1 — TimeTracker
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

BIN="$DIR/tt"
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

# Используем --fake-time → каждый вызов now() = инкремент счётчика (детерминированно).
# begin task → start=N, end_at_status=прошло сколько-то тиков

# Test 1: empty status (no tasks at all)
ACT=$(printf "%s\n" "status" "exit" | timeout 5 "$BIN" --fake-time 2>/dev/null)
run_test "empty status" "" "$ACT"

# Test 2: begin → end → status (1 second)
# begin (now=1, start=1) → end (now=2, end=2) → status: TaskA: 1s
ACT=$(printf "%s\n" "begin" "TaskA" "end" "status" "exit" | timeout 5 "$BIN" --fake-time 2>/dev/null)
run_test "begin+end+status" "TaskA: 1s" "$ACT"

# Test 3: begin → status (active, no finished)
# begin (now=1, start=1) → status (active TaskA)
ACT=$(printf "%s\n" "begin" "TaskA" "status" "exit" | timeout 5 "$BIN" --fake-time 2>/dev/null)
run_test "active task in status" "active: TaskA" "$ACT"

# Test 4: begin TaskA → begin TaskB → status (TaskA finished, TaskB active)
# begin TaskA (now=1, A.start=1)
# begin TaskB (now=2, A.end=2 → A:1s, B.start=2)
# status (TaskA: 1s, active: TaskB)
ACT=$(printf "%s\n" "begin" "TaskA" "begin" "TaskB" "status" "exit" | timeout 5 "$BIN" --fake-time 2>/dev/null)
EXP=$'TaskA: 1s\nactive: TaskB'
run_test "begin auto-ends previous" "$EXP" "$ACT"

# Test 5: end without active does nothing
ACT=$(printf "%s\n" "end" "status" "exit" | timeout 5 "$BIN" --fake-time 2>/dev/null)
run_test "end on no-active is noop" "" "$ACT"

# Test 6: full sequence
# begin A (1)→ end (2, A=1s) → begin B (3) → end (4, B=1s) → status
ACT=$(printf "%s\n" "begin" "A" "end" "begin" "B" "end" "status" "exit" | timeout 5 "$BIN" --fake-time 2>/dev/null)
EXP=$'A: 1s\nB: 1s'
run_test "two completed tasks" "$EXP" "$ACT"

# Test 7: begin A → end → begin A again → status (A appears twice)
ACT=$(printf "%s\n" "begin" "A" "end" "begin" "A" "end" "status" "exit" | timeout 5 "$BIN" --fake-time 2>/dev/null)
EXP=$'A: 1s\nA: 1s'
run_test "same task twice → two entries" "$EXP" "$ACT"

# Test 8: exit terminates
ACT=$(printf "%s\n" "begin" "A" "exit" "status" | timeout 5 "$BIN" --fake-time 2>/dev/null)
run_test "exit ignores subsequent commands" "" "$ACT"

echo ""
echo "Total: $TOTAL Passed: $PASS Failed: $FAIL"
[ $FAIL -eq 0 ]
