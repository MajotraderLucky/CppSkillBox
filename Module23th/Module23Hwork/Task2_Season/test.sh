#!/bin/bash
# Tests for M23.4 Task 2 — Season (compile-time selection)
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

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

# Test 1-4: each season selected via -D flag
for season in SPRING:Spring SUMMER:Summer AUTUMN:Autumn WINTER:Winter; do
    flag=${season%%:*}
    expected=${season##*:}
    BIN="$DIR/season_${flag}"
    g++ -std=c++17 -O0 -Wall -Wextra -D${flag} -o "$BIN" main.cpp 2>/dev/null || {
        TOTAL=$((TOTAL+1)); FAIL=$((FAIL+1))
        echo "  [X] $flag → COMPILE FAIL"
        continue
    }
    ACT=$("$BIN" 2>/dev/null)
    run_test "-D${flag} → ${expected}" "$expected" "$ACT"
    rm -f "$BIN"
done

# Test 5: no season → exits with error
BIN="$DIR/season_none"
g++ -std=c++17 -O0 -Wall -Wextra -o "$BIN" main.cpp 2>/dev/null
"$BIN" >/dev/null 2>/dev/null
RC=$?
TOTAL=$((TOTAL+1))
if [ $RC -eq 1 ]; then
    echo "  [+] no -D → exit code 1"
    PASS=$((PASS+1))
else
    echo "  [X] no -D → expected exit 1, got $RC"
    FAIL=$((FAIL+1))
fi
rm -f "$BIN"

echo ""
echo "Total: $TOTAL Passed: $PASS Failed: $FAIL"
[ $FAIL -eq 0 ]
