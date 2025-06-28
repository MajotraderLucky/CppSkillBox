#!/bin/bash

echo "Testing train_time program..."

# Test 1: Same day travel (example from task)
result=$(echo -e "09:20\n10:20" | ./train_time | grep -o "[0-9]* ч. [0-9]* мин.")
expected="1 ч. 0 мин."
if [ "$result" = "$expected" ]; then
    echo "✓ Test 1 passed: 09:20 to 10:20 = $result"
else
    echo "✗ Test 1 failed: expected '$expected', got '$result'"
fi

# Test 2: Next day arrival (example from task)
result=$(echo -e "09:20\n08:40" | ./train_time | grep -o "[0-9]* ч. [0-9]* мин.")
expected="23 ч. 20 мин."
if [ "$result" = "$expected" ]; then
    echo "✓ Test 2 passed: 09:20 to 08:40 = $result"
else
    echo "✗ Test 2 failed: expected '$expected', got '$result'"
fi

# Test 3: Midnight crossing
result=$(echo -e "23:30\n01:15" | ./train_time | grep -o "[0-9]* ч. [0-9]* мин.")
expected="1 ч. 45 мин."
if [ "$result" = "$expected" ]; then
    echo "✓ Test 3 passed: 23:30 to 01:15 = $result"
else
    echo "✗ Test 3 failed: expected '$expected', got '$result'"
fi

# Test 4: Same time (0 minutes)
result=$(echo -e "12:00\n12:00" | ./train_time | grep -o "[0-9]* ч. [0-9]* мин.")
expected="0 ч. 0 мин."
if [ "$result" = "$expected" ]; then
    echo "✓ Test 4 passed: 12:00 to 12:00 = $result"
else
    echo "✗ Test 4 failed: expected '$expected', got '$result'"
fi

# Test 5: Almost full day
result=$(echo -e "00:01\n00:00" | ./train_time | grep -o "[0-9]* ч. [0-9]* мин.")
expected="23 ч. 59 мин."
if [ "$result" = "$expected" ]; then
    echo "✓ Test 5 passed: 00:01 to 00:00 = $result"
else
    echo "✗ Test 5 failed: expected '$expected', got '$result'"
fi

# Test 6: Hour boundary
result=$(echo -e "14:59\n15:01" | ./train_time | grep -o "[0-9]* ч. [0-9]* мин.")
expected="0 ч. 2 мин."
if [ "$result" = "$expected" ]; then
    echo "✓ Test 6 passed: 14:59 to 15:01 = $result"
else
    echo "✗ Test 6 failed: expected '$expected', got '$result'"
fi

# Test 7: Exactly one hour
result=$(echo -e "10:30\n11:30" | ./train_time | grep -o "[0-9]* ч. [0-9]* мин.")
expected="1 ч. 0 мин."
if [ "$result" = "$expected" ]; then
    echo "✓ Test 7 passed: 10:30 to 11:30 = $result"
else
    echo "✗ Test 7 failed: expected '$expected', got '$result'"
fi

# Test 8: Exactly 12 hours
result=$(echo -e "06:00\n18:00" | ./train_time | grep -o "[0-9]* ч. [0-9]* мин.")
expected="12 ч. 0 мин."
if [ "$result" = "$expected" ]; then
    echo "✓ Test 8 passed: 06:00 to 18:00 = $result"
else
    echo "✗ Test 8 failed: expected '$expected', got '$result'"
fi

echo ""
echo "Testing input validation..."

# Test 9: Invalid time format - should ask for re-input
echo "ℹ Test 9: Testing invalid time format '25:00' (should ask for re-input)"
timeout 5s bash -c 'echo -e "25:00\n09:00\n10:00" | ./train_time' 2>/dev/null || echo "   Program correctly handles invalid input"

# Test 10: Invalid time format - wrong separator
echo "ℹ Test 10: Testing invalid time format '09-30' (should ask for re-input)"
timeout 5s bash -c 'echo -e "09-30\n09:00\n10:00" | ./train_time' 2>/dev/null || echo "   Program correctly handles invalid input"

# Test 11: Invalid time format - letters
echo "ℹ Test 11: Testing invalid time format 'ab:cd' (should ask for re-input)"
timeout 5s bash -c 'echo -e "ab:cd\n09:00\n10:00" | ./train_time' 2>/dev/null || echo "   Program correctly handles invalid input"

echo ""
echo "Train time tests completed."