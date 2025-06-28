#!/bin/bash

echo "Testing bulls_cows program..."

# Function to extract bulls and cows from output
extract_result() {
    echo "$1" | grep -o "Быков: [0-9]*, коров: [0-9]*" | sed 's/Быков: \([0-9]*\), коров: \([0-9]*\)/\1 \2/'
}

echo "=== Testing examples from task ==="

# Test 1: 5671 vs 7251 - should be 1 bull, 2 cows
output=$(echo -e "5671\n7251" | ./bulls_cows)
result=$(extract_result "$output")
if [ "$result" = "1 2" ]; then
    echo "✓ Test 1 passed: 5671 vs 7251 = 1 bull, 2 cows"
else
    echo "✗ Test 1 failed: expected '1 2', got '$result'"
fi

# Test 2: 1234 vs 1234 - should be 4 bulls, 0 cows
output=$(echo -e "1234\n1234" | ./bulls_cows)
result=$(extract_result "$output")
if [ "$result" = "4 0" ]; then
    echo "✓ Test 2 passed: 1234 vs 1234 = 4 bulls, 0 cows"
else
    echo "✗ Test 2 failed: expected '4 0', got '$result'"
fi

# Test 3: 0023 vs 2013 - should be 2 bulls, 1 cow
output=$(echo -e "0023\n2013" | ./bulls_cows)
result=$(extract_result "$output")
if [ "$result" = "2 1" ]; then
    echo "✓ Test 3 passed: 0023 vs 2013 = 2 bulls, 1 cow"
else
    echo "✗ Test 3 failed: expected '2 1', got '$result'"
fi

# Test 4: 2013 vs 0023 - should be 2 bulls, 1 cow
output=$(echo -e "2013\n0023" | ./bulls_cows)
result=$(extract_result "$output")
if [ "$result" = "2 1" ]; then
    echo "✓ Test 4 passed: 2013 vs 0023 = 2 bulls, 1 cow"
else
    echo "✗ Test 4 failed: expected '2 1', got '$result'"
fi

# Test 5: 1111 vs 1111 - should be 4 bulls, 0 cows
output=$(echo -e "1111\n1111" | ./bulls_cows)
result=$(extract_result "$output")
if [ "$result" = "4 0" ]; then
    echo "✓ Test 5 passed: 1111 vs 1111 = 4 bulls, 0 cows"
else
    echo "✗ Test 5 failed: expected '4 0', got '$result'"
fi

# Test 6: 1222 vs 2234 - should be 1 bull, 1 cow
output=$(echo -e "1222\n2234" | ./bulls_cows)
result=$(extract_result "$output")
if [ "$result" = "1 1" ]; then
    echo "✓ Test 6 passed: 1222 vs 2234 = 1 bull, 1 cow"
else
    echo "✗ Test 6 failed: expected '1 1', got '$result'"
fi

echo ""
echo "=== Testing additional edge cases ==="

# Test 7: No matches at all
output=$(echo -e "1234\n5678" | ./bulls_cows)
result=$(extract_result "$output")
if [ "$result" = "0 0" ]; then
    echo "✓ Test 7 passed: 1234 vs 5678 = 0 bulls, 0 cows"
else
    echo "✗ Test 7 failed: expected '0 0', got '$result'"
fi

# Test 8: All cows, no bulls
output=$(echo -e "1234\n4321" | ./bulls_cows)
result=$(extract_result "$output")
if [ "$result" = "0 4" ]; then
    echo "✓ Test 8 passed: 1234 vs 4321 = 0 bulls, 4 cows"
else
    echo "✗ Test 8 failed: expected '0 4', got '$result'"
fi

# Test 9: Numbers with leading zeros
output=$(echo -e "0001\n1000" | ./bulls_cows)
result=$(extract_result "$output")
if [ "$result" = "1 1" ]; then
    echo "✓ Test 9 passed: 0001 vs 1000 = 1 bull, 1 cow"
else
    echo "✗ Test 9 failed: expected '1 1', got '$result'"
fi

# Test 10: All zeros
output=$(echo -e "0000\n0000" | ./bulls_cows)
result=$(extract_result "$output")
if [ "$result" = "4 0" ]; then
    echo "✓ Test 10 passed: 0000 vs 0000 = 4 bulls, 0 cows"
else
    echo "✗ Test 10 failed: expected '4 0', got '$result'"
fi

# Test 11: Complex case with repeating digits
output=$(echo -e "1122\n2211" | ./bulls_cows)
result=$(extract_result "$output")
if [ "$result" = "0 4" ]; then
    echo "✓ Test 11 passed: 1122 vs 2211 = 0 bulls, 4 cows"
else
    echo "✗ Test 11 failed: expected '0 4', got '$result'"
fi

# Test 12: Complex case with partial matches
output=$(echo -e "1223\n3221" | ./bulls_cows)
result=$(extract_result "$output")
if [ "$result" = "0 4" ]; then
    echo "✓ Test 12 passed: 1223 vs 3221 = 0 bulls, 4 cows"
else
    echo "✗ Test 12 failed: expected '0 4', got '$result'"
fi

# Test 13: One digit matches in wrong position
output=$(echo -e "1000\n0001" | ./bulls_cows)
result=$(extract_result "$output")
if [ "$result" = "2 1" ]; then
    echo "✓ Test 13 passed: 1000 vs 0001 = 2 bulls, 1 cow"
else
    echo "✗ Test 13 failed: expected '2 1', got '$result'"
fi

# Test 14: Tricky case with multiple same digits
output=$(echo -e "1112\n1121" | ./bulls_cows)
result=$(extract_result "$output")
if [ "$result" = "2 2" ]; then
    echo "✓ Test 14 passed: 1112 vs 1121 = 2 bulls, 2 cows"
else
    echo "✗ Test 14 failed: expected '2 2', got '$result'"
fi

# Test 15: Another tricky case
output=$(echo -e "1233\n3123" | ./bulls_cows)
result=$(extract_result "$output")
if [ "$result" = "1 3" ]; then
    echo "✓ Test 15 passed: 1233 vs 3123 = 1 bull, 3 cows"
else
    echo "✗ Test 15 failed: expected '1 3', got '$result'"
fi

# Test 16: Testing with shorter input numbers (should be padded)
output=$(echo -e "23\n32" | ./bulls_cows)
result=$(extract_result "$output")
if [ "$result" = "0 2" ]; then
    echo "✓ Test 16 passed: 23 vs 32 (padded to 0023 vs 0032) = 0 bulls, 2 cows"
else
    echo "✗ Test 16 failed: expected '0 2', got '$result'"
fi

# Test 17: Single digit input
output=$(echo -e "5\n5" | ./bulls_cows)
result=$(extract_result "$output")
if [ "$result" = "1 0" ]; then
    echo "✓ Test 17 passed: 5 vs 5 (padded to 0005 vs 0005) = 1 bull, 0 cows"
else
    echo "✗ Test 17 failed: expected '1 0', got '$result'"
fi

echo ""
echo "Bulls and cows tests completed."