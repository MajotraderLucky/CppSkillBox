#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$DIR/whatwherewhen"

if [ ! -x "$BIN" ] || [ "$DIR/main.cpp" -nt "$BIN" ]; then
    g++ -std=c++11 -Wall -Wextra "$DIR/main.cpp" -o "$BIN" || exit 1
fi

PASSED=0
FAILED=0
TOTAL=0

# Setup sectors fixtures
SDIR="$DIR/sectors"
rm -rf "$SDIR"
mkdir "$SDIR"
for i in $(seq 1 13); do
    echo "Question for sector $i" > "$SDIR/question_$i.txt"
    echo "answer$i" > "$SDIR/answer_$i.txt"
done

check_contains() {
    TOTAL=$((TOTAL + 1))
    local name="$1"
    local input="$2"
    local pattern="$3"
    local output
    output=$(printf "%s\n" "$input" | timeout 5 "$BIN" "$SDIR" 2>/dev/null)
    if echo "$output" | grep -qF "$pattern"; then
        echo "  PASS: $name"
        PASSED=$((PASSED + 1))
    else
        echo "  FAIL: $name (pattern '$pattern' missing)"
        echo "    output:"
        echo "$output" | head -10 | sed 's/^/      /'
        FAILED=$((FAILED + 1))
    fi
}

echo "=== Task 5 — Что? Где? Когда? tests ==="

# Player wins 6-0: offset 0 → sector 1 with answer "answer1", repeat 6 times
# But sector 1 plays once. So we need 6 different sectors with correct answers.
# Player offsets: 0 (sec1), 1 (sec2), 1 (sec3), 1 (sec4), 1 (sec5), 1 (sec6)
PLAYER_WINS_6=$(printf "0\nanswer1\n1\nanswer2\n1\nanswer3\n1\nanswer4\n1\nanswer5\n1\nanswer6\n")
check_contains "Player wins 6-0"   "$PLAYER_WINS_6"   "Player wins! 6-0"

# Audience wins 6-0: same offsets, all wrong
AUD_WINS_6=$(printf "0\nWRONG\n1\nWRONG\n1\nWRONG\n1\nWRONG\n1\nWRONG\n1\nWRONG\n")
check_contains "Audience wins 6-0" "$AUD_WINS_6"      "Audience wins! 6-0"

# Mixed game — player wins 6-2
MIXED=$(printf "0\nanswer1\n1\nanswer2\n1\nanswer3\n1\nWRONG\n1\nanswer5\n1\nanswer6\n1\nWRONG\n1\nanswer8\n")
check_contains "Player wins 6-2"  "$MIXED"           "Player wins!"

# Sector wrap-around: starting at 0, offset=15 → sector (0+15)%13 = 2
WRAP=$(printf "15\nanswer3\n0\nWRONG\n0\nWRONG\n0\nWRONG\n0\nWRONG\n0\nWRONG\n0\nWRONG\n")
check_contains "wrap-around sector 3"  "$WRAP"       "Sector 3 question"

# Already played sector — выбирает следующий
# offset 0 → sector 1 (correct), then offset 0 → sector 1 played, take 2
REPEAT=$(printf "0\nanswer1\n0\nanswer2\n1\nanswer3\n1\nanswer4\n1\nanswer5\n1\nanswer6\n")
check_contains "already-played skip"   "$REPEAT"     "Player wins!"

rm -rf "$SDIR"

echo ""
echo "Total: $TOTAL, Passed: $PASSED, Failed: $FAILED"
[ $FAILED -eq 0 ]
