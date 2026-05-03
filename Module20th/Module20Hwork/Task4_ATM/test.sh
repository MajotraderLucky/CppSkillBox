#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$DIR/atm"

if [ ! -x "$BIN" ] || [ "$DIR/main.cpp" -nt "$BIN" ]; then
    g++ -std=c++11 -Wall -Wextra "$DIR/main.cpp" -o "$BIN" || exit 1
fi

PASSED=0
FAILED=0
TOTAL=0

STATE="$DIR/test_atm.bin"

run_fresh() {
    rm -f "$STATE"
    printf "%s\n" "$1" | timeout 5 "$BIN" "$STATE" 42 2>/dev/null
}

run_existing() {
    printf "%s\n" "$1" | timeout 5 "$BIN" "$STATE" 42 2>/dev/null
}

check_contains() {
    TOTAL=$((TOTAL + 1))
    local name="$1"
    local input="$2"
    local pattern="$3"
    local out=$(run_fresh "$input")
    if echo "$out" | grep -qF "$pattern"; then
        echo "  PASS: $name"
        PASSED=$((PASSED + 1))
    else
        echo "  FAIL: $name (pattern '$pattern' missing)"
        echo "$out" | head -5 | sed 's/^/      /'
        FAILED=$((FAILED + 1))
    fi
}

echo "=== Task 4 — ATM tests ==="

# Empty ATM at start
check_contains "empty initially"     "q"          "Empty ATM"
check_contains "state saved"         "q"          "State saved"

# Fill ATM
check_contains "fill makes it 1000"  "+
q"        "Total:"

# Withdraw small amount after fill
check_contains "withdraw 100 after fill"   "+
- 100
q"  "Withdrew 100"

# Try invalid amount (not multiple of 100)
check_contains "invalid (not 100x)"  "+
- 150
q"   "Cannot"

# Persistence: fill in run 1, check in run 2
TOTAL=$((TOTAL + 1))
rm -f "$STATE"
run_existing "+
q" > /dev/null
out=$(run_existing "q")
if echo "$out" | grep -qF "Loaded state"; then
    echo "  PASS: state persistence (loaded after re-run)"
    PASSED=$((PASSED + 1))
else
    echo "  FAIL: state persistence"
    FAILED=$((FAILED + 1))
fi

# Withdraw entire 100 type — should reduce
TOTAL=$((TOTAL + 1))
rm -f "$STATE"
out=$(printf "+\n- 100\n- 100\n- 100\nq\n" | timeout 5 "$BIN" "$STATE" 42 2>/dev/null)
withdraw_count=$(echo "$out" | grep -c "Withdrew 100")
if [ "$withdraw_count" -ge 1 ]; then
    echo "  PASS: multiple withdrawals"
    PASSED=$((PASSED + 1))
else
    echo "  FAIL: multiple withdrawals (got $withdraw_count)"
    FAILED=$((FAILED + 1))
fi

rm -f "$STATE"
echo ""
echo "Total: $TOTAL, Passed: $PASSED, Failed: $FAILED"
[ $FAILED -eq 0 ]
