#!/bin/bash

echo "Testing float_validator program..."

# Test valid examples from task
echo "=== Testing VALID examples ==="

# Test 1: Simple integer
result=$(echo "0123" | ./float_validator | grep -o "Yes\|No")
if [ "$result" = "Yes" ]; then
    echo "✓ Test 1 passed: '0123' is valid"
else
    echo "✗ Test 1 failed: expected Yes, got $result"
fi

# Test 2: Decimal with leading and trailing zeros
result=$(echo "00.000" | ./float_validator | grep -o "Yes\|No")
if [ "$result" = "Yes" ]; then
    echo "✓ Test 2 passed: '00.000' is valid"
else
    echo "✗ Test 2 failed: expected Yes, got $result"
fi

# Test 3: Decimal starting with dot
result=$(echo ".15" | ./float_validator | grep -o "Yes\|No")
if [ "$result" = "Yes" ]; then
    echo "✓ Test 3 passed: '.15' is valid"
else
    echo "✗ Test 3 failed: expected Yes, got $result"
fi

# Test 4: Decimal ending with dot
result=$(echo "165." | ./float_validator | grep -o "Yes\|No")
if [ "$result" = "Yes" ]; then
    echo "✓ Test 4 passed: '165.' is valid"
else
    echo "✗ Test 4 failed: expected Yes, got $result"
fi

# Test 5: Very long number
result=$(echo "999999999999999999999999999999999.999999999999999999999" | ./float_validator | grep -o "Yes\|No")
if [ "$result" = "Yes" ]; then
    echo "✓ Test 5 passed: long number is valid"
else
    echo "✗ Test 5 failed: expected Yes, got $result"
fi

# Test 6: Negative decimal
result=$(echo "-1.0" | ./float_validator | grep -o "Yes\|No")
if [ "$result" = "Yes" ]; then
    echo "✓ Test 6 passed: '-1.0' is valid"
else
    echo "✗ Test 6 failed: expected Yes, got $result"
fi

# Test 7: Negative decimal starting with dot
result=$(echo "-.35" | ./float_validator | grep -o "Yes\|No")
if [ "$result" = "Yes" ]; then
    echo "✓ Test 7 passed: '-.35' is valid"
else
    echo "✗ Test 7 failed: expected Yes, got $result"
fi

echo ""
echo "=== Testing INVALID examples ==="

# Test 8: Two decimal points
result=$(echo "1.2.3" | ./float_validator | grep -o "Yes\|No")
if [ "$result" = "No" ]; then
    echo "✓ Test 8 passed: '1.2.3' is invalid (two dots)"
else
    echo "✗ Test 8 failed: expected No, got $result"
fi

# Test 9: Only minus and dot
result=$(echo "-." | ./float_validator | grep -o "Yes\|No")
if [ "$result" = "No" ]; then
    echo "✓ Test 9 passed: '-.' is invalid (no digits)"
else
    echo "✗ Test 9 failed: expected No, got $result"
fi

# Test 10: Exponential notation
result=$(echo "11e-3" | ./float_validator | grep -o "Yes\|No")
if [ "$result" = "No" ]; then
    echo "✓ Test 10 passed: '11e-3' is invalid (exponential)"
else
    echo "✗ Test 10 failed: expected No, got $result"
fi

# Test 11: Plus sign
result=$(echo "+25" | ./float_validator | grep -o "Yes\|No")
if [ "$result" = "No" ]; then
    echo "✓ Test 11 passed: '+25' is invalid (plus sign)"
else
    echo "✗ Test 11 failed: expected No, got $result"
fi

echo ""
echo "=== Testing ADDITIONAL edge cases ==="

# Test 12: Single digit
result=$(echo "5" | ./float_validator | grep -o "Yes\|No")
if [ "$result" = "Yes" ]; then
    echo "✓ Test 12 passed: '5' is valid"
else
    echo "✗ Test 12 failed: expected Yes, got $result"
fi

# Test 13: Single negative digit
result=$(echo "-7" | ./float_validator | grep -o "Yes\|No")
if [ "$result" = "Yes" ]; then
    echo "✓ Test 13 passed: '-7' is valid"
else
    echo "✗ Test 13 failed: expected Yes, got $result"
fi

# Test 14: Zero
result=$(echo "0" | ./float_validator | grep -o "Yes\|No")
if [ "$result" = "Yes" ]; then
    echo "✓ Test 14 passed: '0' is valid"
else
    echo "✗ Test 14 failed: expected Yes, got $result"
fi

# Test 15: Negative zero
result=$(echo "-0" | ./float_validator | grep -o "Yes\|No")
if [ "$result" = "Yes" ]; then
    echo "✓ Test 15 passed: '-0' is valid"
else
    echo "✗ Test 15 failed: expected Yes, got $result"
fi

# Test 16: Only dot
result=$(echo "." | ./float_validator | grep -o "Yes\|No")
if [ "$result" = "No" ]; then
    echo "✓ Test 16 passed: '.' is invalid (no digits)"
else
    echo "✗ Test 16 failed: expected No, got $result"
fi

# Test 17: Empty string
result=$(echo "" | ./float_validator | grep -o "Yes\|No")
if [ "$result" = "No" ]; then
    echo "✓ Test 17 passed: empty string is invalid"
else
    echo "✗ Test 17 failed: expected No, got $result"
fi

# Test 18: Only minus
result=$(echo "-" | ./float_validator | grep -o "Yes\|No")
if [ "$result" = "No" ]; then
    echo "✓ Test 18 passed: '-' is invalid"
else
    echo "✗ Test 18 failed: expected No, got $result"
fi

# Test 19: Letters
result=$(echo "abc" | ./float_validator | grep -o "Yes\|No")
if [ "$result" = "No" ]; then
    echo "✓ Test 19 passed: 'abc' is invalid"
else
    echo "✗ Test 19 failed: expected No, got $result"
fi

# Test 20: Mixed letters and numbers
result=$(echo "1a2" | ./float_validator | grep -o "Yes\|No")
if [ "$result" = "No" ]; then
    echo "✓ Test 20 passed: '1a2' is invalid"
else
    echo "✗ Test 20 failed: expected No, got $result"
fi

# Test 21: Space in number
result=$(echo "1 2" | ./float_validator | grep -o "Yes\|No")
if [ "$result" = "No" ]; then
    echo "✓ Test 21 passed: '1 2' is invalid"
else
    echo "✗ Test 21 failed: expected No, got $result"
fi

# Test 22: Multiple minuses
result=$(echo "--5" | ./float_validator | grep -o "Yes\|No")
if [ "$result" = "No" ]; then
    echo "✓ Test 22 passed: '--5' is invalid"
else
    echo "✗ Test 22 failed: expected No, got $result"
fi

echo ""
echo "Float validator tests completed."