#!/bin/bash

echo "Testing word_count program..."

# Test 1: Basic test from assignment
result=$(echo -e "mama myla ramu\nmy" | ./word_count | grep -o "[0-9]*")
if [ "$result" = "1" ]; then
    echo "✓ Test 1 passed: 'my' in 'mama myla ramu' = 1"
else
    echo "✗ Test 1 failed: expected 1, got $result"
fi

# Test 2: Multiple occurrences from assignment
result=$(echo -e "abudabudabdab\ndab" | ./word_count | grep -o "[0-9]*")
if [ "$result" = "3" ]; then
    echo "✓ Test 2 passed: 'dab' in 'abudabudabdab' = 3"
else
    echo "✗ Test 2 failed: expected 3, got $result"
fi

# Test 3: No occurrences
result=$(echo -e "hello world\nxyz" | ./word_count | grep -o "[0-9]*")
if [ "$result" = "0" ]; then
    echo "✓ Test 3 passed: 'xyz' not found in 'hello world' = 0"
else
    echo "✗ Test 3 failed: expected 0, got $result"
fi

# Test 4: Overlapping occurrences
result=$(echo -e "aaaa\naa" | ./word_count | grep -o "[0-9]*")
if [ "$result" = "3" ]; then
    echo "✓ Test 4 passed: 'aa' in 'aaaa' = 3 (overlapping)"
else
    echo "✗ Test 4 failed: expected 3, got $result"
fi

# Test 5: Whole string match
result=$(echo -e "test\ntest" | ./word_count | grep -o "[0-9]*")
if [ "$result" = "1" ]; then
    echo "✓ Test 5 passed: 'test' in 'test' = 1"
else
    echo "✗ Test 5 failed: expected 1, got $result"
fi

# Test 6: Empty search string edge case
result=$(echo -e "hello\n" | ./word_count | grep -o "[0-9]*")
echo "ℹ Test 6: Empty search string returned $result"

echo "Word count tests completed."