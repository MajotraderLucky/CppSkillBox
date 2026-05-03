#!/bin/bash
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"
BIN="$DIR/cmp"
g++ -std=c++17 -O0 -Wall -Wextra -o "$BIN" main.cpp || { echo "COMPILE FAIL"; exit 1; }

PASS=0; FAIL=0; TOTAL=0
run_test() {
    local desc="$1" expected="$2" actual="$3"
    TOTAL=$((TOTAL+1))
    if [ "$expected" = "$actual" ]; then echo "  [+] $desc"; PASS=$((PASS+1));
    else echo "  [X] $desc"; echo "    expected: $expected"; echo "    actual:   $actual"; FAIL=$((FAIL+1)); fi
}

# Test 1: проверяем что есть ALL WORKERS BUSY и что все CEO/Manager строки есть
# 1 team, 1 worker — гарантированно при первой команде если rand%2 == 1
ACT=$(printf "%s\n" "1 1" "1" "2" "3" "4" "5" "6" "7" "8" | timeout 5 "$BIN" 2>/dev/null | tail -1)
run_test "eventually ALL WORKERS BUSY" "ALL WORKERS BUSY" "$ACT"

# Test 2: первый CEO output должен быть про команду 1
ACT=$(printf "%s\n" "2 2" "100" | timeout 5 "$BIN" 2>/dev/null | head -1)
run_test "first line: CEO command" "CEO Boss issues command 100" "$ACT"

# Test 3: один менеджер на одну команду → 1 manager line
ACT=$(printf "%s\n" "1 3" "5" | timeout 5 "$BIN" 2>/dev/null | grep -c "^Manager")
# каждый раз manager печатает "получил команду" — должна быть хотя бы 1
[ "$ACT" -ge 1 ] && run_test "Manager processed command" "OK" "OK" || run_test "Manager processed command" "OK" "FAIL"

# Test 4: правильный формат worker assignment
ACT=$(printf "%s\n" "1 5" "999" "999" "999" "999" "999" | timeout 5 "$BIN" 2>/dev/null | grep -E "Worker.*assigned" | head -1)
case "$ACT" in
    "Worker W1-"*" assigned task "*) run_test "Worker assigned format" "OK" "OK" ;;
    *) run_test "Worker assigned format" "OK" "BAD: $ACT" ;;
esac

# Test 5: всего сотрудников = teams * perTeam
ACT=$(printf "%s\n" "2 3" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" | timeout 5 "$BIN" 2>/dev/null | grep -c "Worker")
# Должно быть ровно 6 unique workers (2 teams * 3 = 6) — каждый assigned один раз
# Подсчитаем уникальные имена
ACT=$(printf "%s\n" "2 3" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" | timeout 5 "$BIN" 2>/dev/null | grep -oE "W[12]-[1-3]" | sort -u | wc -l)
run_test "total unique workers = 6 (2x3)" "6" "$ACT"

# Test 6: всё-таки ALL WORKERS BUSY должно появиться при достаточном вводе
ACT=$(printf "%s\n" "2 2" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" | timeout 5 "$BIN" 2>/dev/null | tail -1)
run_test "2x2 → eventually ALL WORKERS BUSY" "ALL WORKERS BUSY" "$ACT"

echo ""
echo "Total: $TOTAL Passed: $PASS Failed: $FAIL"
[ $FAIL -eq 0 ]
