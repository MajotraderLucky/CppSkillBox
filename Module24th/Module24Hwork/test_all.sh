#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"

OVERALL_PASS=0
OVERALL_FAIL=0
OVERALL_TOTAL=0
FAILED_TASKS=""

for task in Task1_TimeTracker Task2_Birthday Task3_Timer; do
    echo ""
    echo "============================================================"
    echo "  Running: $task"
    echo "============================================================"
    if [ -x "$DIR/$task/test.sh" ]; then
        if "$DIR/$task/test.sh"; then : ; else FAILED_TASKS="$FAILED_TASKS $task"; fi
        COUNTS=$("$DIR/$task/test.sh" 2>&1 | grep -E "^Total:" | tail -1)
        if [ -n "$COUNTS" ]; then
            T=$(echo "$COUNTS" | sed -E 's/Total: ([0-9]+).*/\1/')
            P=$(echo "$COUNTS" | sed -E 's/.*Passed: ([0-9]+).*/\1/')
            F=$(echo "$COUNTS" | sed -E 's/.*Failed: ([0-9]+).*/\1/')
            OVERALL_TOTAL=$((OVERALL_TOTAL + T))
            OVERALL_PASS=$((OVERALL_PASS + P))
            OVERALL_FAIL=$((OVERALL_FAIL + F))
        fi
    fi
done

echo ""
echo "============================================================"
echo "  OVERALL SUMMARY"
echo "============================================================"
echo "Total tests:  $OVERALL_TOTAL"
echo "Passed:       $OVERALL_PASS"
echo "Failed:       $OVERALL_FAIL"
if [ -n "$FAILED_TASKS" ]; then echo "Failed tasks:$FAILED_TASKS"; fi
[ $OVERALL_FAIL -eq 0 ]
