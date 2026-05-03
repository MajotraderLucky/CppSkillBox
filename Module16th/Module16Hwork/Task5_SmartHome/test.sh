#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$DIR/smarthome"

if [ ! -x "$BIN" ] || [ "$DIR/main.cpp" -nt "$BIN" ]; then
    g++ -std=c++11 -Wall -Wextra "$DIR/main.cpp" -o "$BIN" || exit 1
fi

PASSED=0
FAILED=0
TOTAL=0

# Helper: build a 48-line input by repeating a pattern
build_input() {
    local pattern="$1"
    local n="$2"
    for ((i=0; i<n; i++)); do echo "$pattern"; done
}

check_contains() {
    TOTAL=$((TOTAL + 1))
    local name="$1"
    local input="$2"
    local pattern="$3"
    local output
    output=$(echo "$input" | timeout 5 "$BIN" 2>/dev/null)
    if echo "$output" | grep -qF "$pattern"; then
        echo "  PASS: $name"
        PASSED=$((PASSED + 1))
    else
        echo "  FAIL: $name (pattern not found: $pattern)"
        echo "    output snippet:"
        echo "$output" | head -5 | sed 's/^/      /'
        FAILED=$((FAILED + 1))
    fi
}

count_pattern() {
    local input="$1"
    local pattern="$2"
    echo "$input" | timeout 5 "$BIN" 2>/dev/null | grep -cF "$pattern"
}

echo "=== Task 5 — Умный дом tests ==="

# Hour 0: t_in=10 (cold), t_out=10 (no pipe heat), motion=yes (но night/early), lights=on
INPUT1=$(build_input "10 10 yes on" 48)
check_contains "Heaters ON at start" "$INPUT1" "Heaters ON!"
check_contains "Color temp 5000K" "$INPUT1" "Color temperature: 5000K"
check_contains "Hour 16 → 5000K" "$INPUT1" "Color temperature: 5000K"

# Hot: trigger conditioner
INPUT2=$(build_input "30 30 yes on" 48)
check_contains "Conditioner ON when 30°" "$INPUT2" "Conditioner ON!"

# Cold outside: trigger water pipe heating
INPUT3=$(build_input "20 -5 no off" 48)
check_contains "Water pipe heating ON" "$INPUT3" "Water pipe heating ON!"

# Только изменения печатаются — счётчик HEATERS ON должен быть 1 (не 48)
INPUT4=$(build_input "10 10 yes on" 48)
TOTAL=$((TOTAL + 1))
heat_count=$(count_pattern "$INPUT4" "Heaters ON!")
if [ "$heat_count" = "1" ]; then
    echo "  PASS: Heaters ON printed once (state changes only)"
    PASSED=$((PASSED + 1))
else
    echo "  FAIL: Expected 1 'Heaters ON!', got $heat_count"
    FAILED=$((FAILED + 1))
fi

# Цветовая темп: 16:00 = 5000, 17:00 = 4425, 18:00 = 3850, 19:00 = 3275
INPUT5=$(build_input "23 10 no on" 48)
check_contains "17:00 → 4425K" "$INPUT5" "Color temperature: 4425K"
check_contains "18:00 → 3850K" "$INPUT5" "Color temperature: 3850K"
check_contains "19:00 → 3275K" "$INPUT5" "Color temperature: 3275K"

# 0:00 reset → 5000K
TOTAL=$((TOTAL + 1))
out_5000=$(count_pattern "$INPUT5" "Color temperature: 5000K")
# 48 hours: hours 0..15 (16 of 5000K) + hour 16 (start = 5000K) + hours 20..23 (4 stay)
# Per day: 16 + 1 + 4 = 21. × 2 days = 42.
if [ "$out_5000" = "42" ]; then
    echo "  PASS: 5000K printed 42 times (16+1+4 per day × 2 days)"
    PASSED=$((PASSED + 1))
else
    echo "  FAIL: Expected 42 5000K prints, got $out_5000"
    FAILED=$((FAILED + 1))
fi

# Lights outside: motion=yes + evening
INPUT6=$(build_input "23 10 yes off" 48)
check_contains "Outside lights when motion+evening" "$INPUT6" "Lights outside ON!"

echo ""
echo "Total: $TOTAL, Passed: $PASSED, Failed: $FAILED"
[ $FAILED -eq 0 ]
