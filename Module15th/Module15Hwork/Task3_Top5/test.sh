#!/bin/bash
# Tests для Task 3 — Top-5 smallest (online algorithm)

DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$DIR/top5"

if [ ! -x "$BIN" ] || [ "$DIR/main.cpp" -nt "$BIN" ]; then
    g++ -std=c++11 -Wall -Wextra "$DIR/main.cpp" -o "$BIN" || exit 1
fi

PASSED=0
FAILED=0
TOTAL=0

# check_eq: проверяет ВСЁ stdout (несколько ответов в multi-query сценариях)
check_eq() {
    TOTAL=$((TOTAL + 1))
    local name="$1"
    local input="$2"
    local expected="$3"
    local output
    output=$(printf "%s\n" "$input" | timeout 5 "$BIN" 2>/dev/null)
    if [ "$output" = "$expected" ]; then
        echo "  PASS: $name"
        PASSED=$((PASSED + 1))
    else
        echo "  FAIL: $name"
        echo "    expected: '$expected'"
        echo "    got:      '$output'"
        FAILED=$((FAILED + 1))
    fi
}

echo "=== Task 3 — Top-5 smallest tests ==="

# Spec example #1: ровно 7 чисел в произвольном порядке, 5-е = 5
check_eq "spec ex 1: 7 5 3 1 2 4 6 -1 -2"  "7 5 3 1 2 4 6 -1 -2" "5"

# Spec example #2: после ex 1 добавили 1 1 1, 5-е = 2
# (но в spec это считается отдельным запуском после ex 1, а не накопительно)
# Здесь: добавим 5 чисел из spec, потом 1 1 1 → top5 = {1,1,1,1,2} → 5-е = 2
check_eq "spec ex 2: 7 5 3 1 2 4 6 1 1 1 -1 -2" "7 5 3 1 2 4 6 1 1 1 -1 -2" "2"

# Меньше 5 чисел — должна быть валидация
check_eq "less than 5 numbers"             "1 2 3 -1 -2" "Less than 5 numbers entered (have 3)"
check_eq "exactly 4 numbers"               "1 2 3 4 -1 -2" "Less than 5 numbers entered (have 4)"
check_eq "0 numbers entered"               "-1 -2" "Less than 5 numbers entered (have 0)"

# Ровно 5 чисел
check_eq "exactly 5 numbers"               "5 4 3 2 1 -1 -2" "5"

# Большие числа отбрасываются
check_eq "большие игнорируются"             "1 2 3 4 5 100 200 300 -1 -2" "5"

# Меньшее число вытесняет 5-ое
check_eq "новый минимум вытесняет"          "10 20 30 40 50 5 -1 -2" "40"
check_eq "несколько вытеснений"             "10 20 30 40 50 1 2 3 -1 -2" "20"

# Multi-query (несколько -1 в одной сессии)
check_eq "two queries, second больше"      "1 2 3 4 5 -1 0 -1 -2" "5
4"

# Negative numbers (сами числа, не -1/-2)
check_eq "all negative {-3,-5,-7,-10,-20}"  "-3 -5 -7 -10 -20 -1 -2" "-3"
check_eq "negative + positive mix"          "5 -3 7 -8 1 0 -1 -2" "5"

# Дубликаты
check_eq "all same {5,5,5,5,5}"             "5 5 5 5 5 -1 -2" "5"
check_eq "duplicates with new min"          "5 5 5 5 5 3 -1 -2" "5"

# Эмфаза на immediate -2 без чисел
check_eq "только -2"                        "-2" ""

# Большой массив (проверка что пропускаются больше 5)
check_eq "большой массив, top5 stable"      "100 99 98 97 96 95 94 93 92 91 -1 -2" "95"

echo ""
echo "Total: $TOTAL, Passed: $PASSED, Failed: $FAILED"
[ $FAILED -eq 0 ]
