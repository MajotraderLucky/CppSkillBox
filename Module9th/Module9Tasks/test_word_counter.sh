#!/bin/bash

echo "Testing word_counter program..."

# Test examples from task
echo "=== Testing examples from task ==="

# Test 1: Simple words
result=$(echo "abcd abce skjc ahdy" | ./word_counter | grep -o "[0-9]*")
if [ "$result" = "4" ]; then
    echo "✓ Test 1 passed: 'abcd abce skjc ahdy' = 4 words"
else
    echo "✗ Test 1 failed: expected 4, got $result"
fi

# Test 2: Special characters
result=$(echo "..33 !!@! WWW )))))))))) __ ))" | ./word_counter | grep -o "[0-9]*")
if [ "$result" = "6" ]; then
    echo "✓ Test 2 passed: special characters = 6 words"
else
    echo "✗ Test 2 failed: expected 6, got $result"
fi

# Test 3: Single character with spaces
result=$(echo "    _    " | ./word_counter | grep -o "[0-9]*")
if [ "$result" = "1" ]; then
    echo "✓ Test 3 passed: '    _    ' = 1 word"
else
    echo "✗ Test 3 failed: expected 1, got $result"
fi

# Test 4: Only spaces
result=$(echo "     " | ./word_counter | grep -o "[0-9]*")
if [ "$result" = "0" ]; then
    echo "✓ Test 4 passed: only spaces = 0 words"
else
    echo "✗ Test 4 failed: expected 0, got $result"
fi

echo ""
echo "=== Testing additional edge cases ==="

# Test 5: Empty string
result=$(echo "" | ./word_counter | grep -o "[0-9]*")
if [ "$result" = "0" ]; then
    echo "✓ Test 5 passed: empty string = 0 words"
else
    echo "✗ Test 5 failed: expected 0, got $result"
fi

# Test 6: Single word
result=$(echo "hello" | ./word_counter | grep -o "[0-9]*")
if [ "$result" = "1" ]; then
    echo "✓ Test 6 passed: 'hello' = 1 word"
else
    echo "✗ Test 6 failed: expected 1, got $result"
fi

# Test 7: Single character
result=$(echo "a" | ./word_counter | grep -o "[0-9]*")
if [ "$result" = "1" ]; then
    echo "✓ Test 7 passed: 'a' = 1 word"
else
    echo "✗ Test 7 failed: expected 1, got $result"
fi

# Test 8: Multiple spaces between words
result=$(echo "word1    word2     word3" | ./word_counter | grep -o "[0-9]*")
if [ "$result" = "3" ]; then
    echo "✓ Test 8 passed: multiple spaces = 3 words"
else
    echo "✗ Test 8 failed: expected 3, got $result"
fi

# Test 9: Leading and trailing spaces
result=$(echo "  word1 word2  " | ./word_counter | grep -o "[0-9]*")
if [ "$result" = "2" ]; then
    echo "✓ Test 9 passed: leading/trailing spaces = 2 words"
else
    echo "✗ Test 9 failed: expected 2, got $result"
fi

# Test 10: Numbers as words
result=$(echo "123 456 789" | ./word_counter | grep -o "[0-9]*")
if [ "$result" = "3" ]; then
    echo "✓ Test 10 passed: numbers = 3 words"
else
    echo "✗ Test 10 failed: expected 3, got $result"
fi

# Test 11: Mixed characters
result=$(echo "a1b2 c3d4 e5f6" | ./word_counter | grep -o "[0-9]*")
if [ "$result" = "3" ]; then
    echo "✓ Test 11 passed: mixed characters = 3 words"
else
    echo "✗ Test 11 failed: expected 3, got $result"
fi

# Test 12: Punctuation
result=$(echo "hello, world! how are you?" | ./word_counter | grep -o "[0-9]*")
if [ "$result" = "5" ]; then
    echo "✓ Test 12 passed: punctuation = 5 words"
else
    echo "✗ Test 12 failed: expected 5, got $result"
fi

# Test 13: Only one space
result=$(echo " " | ./word_counter | grep -o "[0-9]*")
if [ "$result" = "0" ]; then
    echo "✓ Test 13 passed: single space = 0 words"
else
    echo "✗ Test 13 failed: expected 0, got $result"
fi

# Test 14: Long string with many words
result=$(echo "one two three four five six seven eight nine ten" | ./word_counter | grep -o "[0-9]*")
if [ "$result" = "10" ]; then
    echo "✓ Test 14 passed: 10 words = 10"
else
    echo "✗ Test 14 failed: expected 10, got $result"
fi

# Test 15: Special symbols as words
result=$(echo "@ # $ % ^ & * ( )" | ./word_counter | grep -o "[0-9]*")
if [ "$result" = "9" ]; then
    echo "✓ Test 15 passed: special symbols = 9 words"
else
    echo "✗ Test 15 failed: expected 9, got $result"
fi

echo ""
echo "Word counter tests completed."