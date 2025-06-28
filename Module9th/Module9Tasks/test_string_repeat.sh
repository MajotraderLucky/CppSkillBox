#!/bin/bash

echo "Testing string_repeat program..."

# Test 1: Basic repeat pattern from assignment
result=$(echo "dabudabudabu" | ./string_repeat | grep -o "Yes\|No")
if [ "$result" = "Yes" ]; then
    echo "✓ Test 1 passed: 'dabudabudabu' is a repeat pattern"
else
    echo "✗ Test 1 failed: expected Yes, got $result"
fi

# Test 2: Another repeat pattern from assignment
result=$(echo "kapkap" | ./string_repeat | grep -o "Yes\|No")
if [ "$result" = "Yes" ]; then
    echo "✓ Test 2 passed: 'kapkap' is a repeat pattern"
else
    echo "✗ Test 2 failed: expected Yes, got $result"
fi

# Test 3: Not a repeat pattern from assignment
result=$(echo "abdabdab" | ./string_repeat | grep -o "Yes\|No")
if [ "$result" = "No" ]; then
    echo "✓ Test 3 passed: 'abdabdab' is not a repeat pattern"
else
    echo "✗ Test 3 failed: expected No, got $result"
fi

# Test 4: Another non-repeat from assignment
result=$(echo "gogolmogol" | ./string_repeat | grep -o "Yes\|No")
if [ "$result" = "No" ]; then
    echo "✓ Test 4 passed: 'gogolmogol' is not a repeat pattern"
else
    echo "✗ Test 4 failed: expected No, got $result"
fi

# Test 5: Single character repeat
result=$(echo "aaaa" | ./string_repeat | grep -o "Yes\|No")
if [ "$result" = "Yes" ]; then
    echo "✓ Test 5 passed: 'aaaa' is a repeat pattern"
else
    echo "✗ Test 5 failed: expected Yes, got $result"
fi

# Test 6: Single character, no repeat
result=$(echo "a" | ./string_repeat | grep -o "Yes\|No")
if [ "$result" = "No" ]; then
    echo "✓ Test 6 passed: single 'a' is not a repeat pattern"
else
    echo "✗ Test 6 failed: expected No, got $result"
fi

# Test 7: Empty string edge case
result=$(echo "" | ./string_repeat | grep -o "Yes\|No")
echo "ℹ Test 7: Empty string returned $result"

# Test 8: Two character repeat
result=$(echo "abab" | ./string_repeat | grep -o "Yes\|No")
if [ "$result" = "Yes" ]; then
    echo "✓ Test 8 passed: 'abab' is a repeat pattern"
else
    echo "✗ Test 8 failed: expected Yes, got $result"
fi

# Test 9: Three character repeat
result=$(echo "abcabc" | ./string_repeat | grep -o "Yes\|No")
if [ "$result" = "Yes" ]; then
    echo "✓ Test 9 passed: 'abcabc' is a repeat pattern"
else
    echo "✗ Test 9 failed: expected Yes, got $result"
fi

# Test 10: Almost repeat but not quite
result=$(echo "abcabcab" | ./string_repeat | grep -o "Yes\|No")
if [ "$result" = "No" ]; then
    echo "✓ Test 10 passed: 'abcabcab' is not a repeat pattern"
else
    echo "✗ Test 10 failed: expected No, got $result"
fi

echo "String repeat tests completed."