#!/bin/bash
# M33.5 — run all task tests
set -u
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

OK=0
KO=0

for task in Task1_Cart Task2_Fishing Task3_Registry Task4_Average; do
    echo "=== $task ==="
    if "$DIR/$task/test.sh"; then OK=$((OK+1)); else KO=$((KO+1)); fi
    echo
done

echo "================================================="
echo "Tasks passed: $OK, failed: $KO"
[ $KO -eq 0 ]
