#!/bin/bash
# Tests для Task 2 — Two Sum

DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$DIR/twosum"

if [ ! -x "$BIN" ] || [ "$DIR/main.cpp" -nt "$BIN" ]; then
    g++ -std=c++11 -Wall -Wextra "$DIR/main.cpp" -o "$BIN" || exit 1
fi

PASSED=0
FAILED=0
TOTAL=0

check() {
    TOTAL=$((TOTAL + 1))
    local name="$1"
    local input="$2"
    local expected="$3"
    local output
    output=$(printf "%s\n" "$input" | timeout 5 "$BIN" 2>/dev/null | tail -1)
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

echo "=== Task 2 — Two Sum tests ==="

# Spec example
check "spec example {2,7,11,15} target=9"   "4 2 7 11 15 9"           "2 7"

# Различные позиции пары
check "пара в начале"                        "5 1 4 5 6 7 5"           "1 4"
check "пара в конце"                         "5 1 2 3 6 7 13"          "6 7"
check "пара через массив"                    "5 1 2 3 4 5 6"           "1 5"

# Negative numbers
check "negative target"                      "4 -3 -5 1 2 -8"          "-3 -5"
check "negative + positive"                  "4 -1 2 3 5 4"            "-1 5"
check "оба отрицательные"                    "3 -10 -5 -3 -8"          "-5 -3"

# Дубликаты
check "пара одинаковых {3,3} target=6"       "2 3 3 6"                 "3 3"

# Zero involved
check "x + 0 = x"                            "3 0 5 5 5"               "0 5"
check "0 + 0 = 0"                            "3 0 0 7 0"               "0 0"

# Нет пары (валидация)
check "no pair found"                        "3 1 2 3 100"             "No pair found"

# Граничные размеры
check "n=2 valid pair"                       "2 4 5 9"                 "4 5"
check "n=0 → no pair"                        "0 5"                     "No pair found"
check "n=1 → no pair"                        "1 5 5"                   "No pair found"

# Early exit: только первая пара (для проверки нет тестов т.к. одна пара гарантирована)

echo ""
echo "Total: $TOTAL, Passed: $PASSED, Failed: $FAILED"
[ $FAILED -eq 0 ]
