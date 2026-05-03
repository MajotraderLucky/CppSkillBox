#!/bin/bash
# Tests for M21.5 Task 1 — Vedomost Struct
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

BIN="$DIR/vs"
g++ -std=c++17 -O0 -Wall -Wextra -o "$BIN" main.cpp || { echo "COMPILE FAIL"; exit 1; }

PASS=0; FAIL=0; TOTAL=0
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

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

# Test 1: list on empty file
F="$TMPDIR/empty.txt"
> "$F"
ACT=$(echo "list" | timeout 5 "$BIN" "$F" 2>/dev/null)
run_test "list on empty file" "(empty)" "$ACT"

# Test 2: add a record then list
F="$TMPDIR/v1.txt"
> "$F"
printf "%s\n" "add" "Ivan" "Petrov" "1.1.2026" "5000" | timeout 5 "$BIN" "$F" 2>/dev/null > /dev/null
ACT=$(echo "list" | timeout 5 "$BIN" "$F" 2>/dev/null)
EXP="Ivan Petrov 1.1.2026 5000"
run_test "add+list single record" "$EXP" "$ACT"

# Test 3: add appends (does not overwrite)
F="$TMPDIR/v2.txt"
echo "Anna Sidorova 5.3.2025 1000" > "$F"
printf "%s\n" "add" "Boris" "Volkov" "20.7.2024" "2500" | timeout 5 "$BIN" "$F" 2>/dev/null > /dev/null
ACT=$(echo "list" | timeout 5 "$BIN" "$F" 2>/dev/null)
EXP=$'Anna Sidorova 5.3.2025 1000\nBoris Volkov 20.7.2024 2500'
run_test "add appends to existing file" "$EXP" "$ACT"

# Test 4: invalid date rejected
F="$TMPDIR/v3.txt"
> "$F"
ACT=$(printf "%s\n" "add" "Bad" "Date" "32.1.2025" "100" | timeout 5 "$BIN" "$F" 2>/dev/null)
run_test "invalid day rejected" "FAIL" "$ACT"

# Test 5: invalid month rejected
F="$TMPDIR/v4.txt"
> "$F"
ACT=$(printf "%s\n" "add" "Bad" "Month" "1.13.2025" "100" | timeout 5 "$BIN" "$F" 2>/dev/null)
run_test "invalid month rejected" "FAIL" "$ACT"

# Test 6: negative amount rejected
F="$TMPDIR/v5.txt"
> "$F"
ACT=$(printf "%s\n" "add" "Neg" "Amount" "1.1.2025" "-100" | timeout 5 "$BIN" "$F" 2>/dev/null)
run_test "negative amount rejected" "FAIL" "$ACT"

# Test 7: list multiple records
F="$TMPDIR/v6.txt"
cat > "$F" <<'EOF'
Alice Smith 1.1.2025 100
Bob Jones 2.2.2025 200
Charlie Brown 3.3.2025 300
EOF
ACT=$(echo "list" | timeout 5 "$BIN" "$F" 2>/dev/null)
EXP=$'Alice Smith 1.1.2025 100\nBob Jones 2.2.2025 200\nCharlie Brown 3.3.2025 300'
run_test "list multiple records" "$EXP" "$ACT"

# Test 8: add success returns OK
F="$TMPDIR/v7.txt"
> "$F"
ACT=$(printf "%s\n" "add" "Test" "User" "1.1.2025" "999" | timeout 5 "$BIN" "$F" 2>/dev/null)
run_test "successful add prints OK" "OK" "$ACT"

# Test 9: add with leading-zeros date works
F="$TMPDIR/v8.txt"
> "$F"
printf "%s\n" "add" "Leading" "Zero" "01.01.2025" "100" | timeout 5 "$BIN" "$F" 2>/dev/null > /dev/null
ACT=$(echo "list" | timeout 5 "$BIN" "$F" 2>/dev/null)
EXP="Leading Zero 01.01.2025 100"
run_test "leading-zero date format" "$EXP" "$ACT"

# Test 10: list missing file returns (empty)
F="$TMPDIR/nonexistent.txt"
ACT=$(echo "list" | timeout 5 "$BIN" "$F" 2>/dev/null)
run_test "list missing file = (empty)" "(empty)" "$ACT"

echo ""
echo "Total: $TOTAL Passed: $PASS Failed: $FAIL"
[ $FAIL -eq 0 ]
