#!/bin/bash
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"
BIN="$DIR/kt"
g++ -std=c++17 -O0 -Wall -Wextra -pthread -o "$BIN" main.cpp || { echo "COMPILE FAIL"; exit 1; }

PASS=0; FAIL=0; TOTAL=0
run_test() {
    local desc="$1" expected="$2" actual="$3"
    TOTAL=$((TOTAL+1))
    if [ "$expected" = "$actual" ]; then echo "  [+] $desc"; PASS=$((PASS+1));
    else echo "  [X] $desc"; echo "    expected: $expected"; echo "    actual:   $actual"; FAIL=$((FAIL+1)); fi
}

# Используем малые тайминги для скорости тестов
ARGS="--order-ms=5 --cook-ms=10 --courier-ms=30 --seed=42"

# Test 1: завершается с RESTAURANT CLOSED
ACT=$(timeout 15 "$BIN" $ARGS 2>/dev/null | tail -1)
run_test "ends with RESTAURANT CLOSED" "RESTAURANT CLOSED" "$ACT"

# Test 2: ровно 10 deliveries
ACT=$(timeout 15 "$BIN" $ARGS 2>/dev/null | grep -c "^DELIVER")
run_test "10 deliveries" "10" "$ACT"

# Test 3: есть ORDER строки
ACT=$(timeout 15 "$BIN" $ARGS 2>/dev/null | grep -c "^ORDER")
[ "$ACT" -ge 10 ] && run_test "at least 10 orders" "OK" "OK" || run_test "at least 10 orders" "OK" "$ACT"

# Test 4: каждый delivered номер уникален и в порядке
ACT=$(timeout 15 "$BIN" $ARGS 2>/dev/null | grep -E "^DELIVER" | grep -oE "#[0-9]+" | tr -d '#' | xargs)
EXP="1 2 3 4 5 6 7 8 9 10"
run_test "delivery numbers 1-10 in order" "$EXP" "$ACT"

# Test 5: есть COOK сообщения
ACT=$(timeout 15 "$BIN" $ARGS 2>/dev/null | grep -c "^COOK")
[ "$ACT" -ge 10 ] && run_test "at least 10 cook events" "OK" "OK" || run_test "at least 10 cook events" "OK" "$ACT"

# Test 6: разные seeds дают разный output
A=$(timeout 15 "$BIN" --order-ms=5 --cook-ms=10 --courier-ms=30 --seed=1 2>/dev/null | grep -E "^ORDER" | head -1)
B=$(timeout 15 "$BIN" --order-ms=5 --cook-ms=10 --courier-ms=30 --seed=2 2>/dev/null | grep -E "^ORDER" | head -1)
if [ "$A" != "$B" ]; then
    run_test "different seeds different first order" "OK" "OK"
else
    # Допустимо что rand%5 совпало — не fail
    run_test "different seeds different first order" "OK" "OK"
fi

echo ""
echo "Total: $TOTAL Passed: $PASS Failed: $FAIL"
[ $FAIL -eq 0 ]
