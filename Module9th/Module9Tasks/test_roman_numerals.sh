#!/bin/bash

echo "Testing roman_numerals program..."

# Function to extract roman numeral from output
extract_result() {
    echo "$1" | sed 's/.*: //'
}

echo "=== Testing examples from task ==="

# Test 1: 351 -> CCCLI
output=$(echo "351" | ./roman_numerals)
result=$(extract_result "$output")
if [ "$result" = "CCCLI" ]; then
    echo "✓ Test 1 passed: 351 = CCCLI"
else
    echo "✗ Test 1 failed: expected CCCLI, got '$result'"
fi

# Test 2: 449 -> CDXLIX
output=$(echo "449" | ./roman_numerals)
result=$(extract_result "$output")
if [ "$result" = "CDXLIX" ]; then
    echo "✓ Test 2 passed: 449 = CDXLIX"
else
    echo "✗ Test 2 failed: expected CDXLIX, got '$result'"
fi

# Test 3: 1313 -> MCCCXIII
output=$(echo "1313" | ./roman_numerals)
result=$(extract_result "$output")
if [ "$result" = "MCCCXIII" ]; then
    echo "✓ Test 3 passed: 1313 = MCCCXIII"
else
    echo "✗ Test 3 failed: expected MCCCXIII, got '$result'"
fi

# Test 4: 2020 -> MMXX
output=$(echo "2020" | ./roman_numerals)
result=$(extract_result "$output")
if [ "$result" = "MMXX" ]; then
    echo "✓ Test 4 passed: 2020 = MMXX"
else
    echo "✗ Test 4 failed: expected MMXX, got '$result'"
fi

echo ""
echo "=== Testing special cases with 4 and 9 ==="

# Test 5: 4 -> IV
output=$(echo "4" | ./roman_numerals)
result=$(extract_result "$output")
if [ "$result" = "IV" ]; then
    echo "✓ Test 5 passed: 4 = IV"
else
    echo "✗ Test 5 failed: expected IV, got '$result'"
fi

# Test 6: 9 -> IX
output=$(echo "9" | ./roman_numerals)
result=$(extract_result "$output")
if [ "$result" = "IX" ]; then
    echo "✓ Test 6 passed: 9 = IX"
else
    echo "✗ Test 6 failed: expected IX, got '$result'"
fi

# Test 7: 40 -> XL
output=$(echo "40" | ./roman_numerals)
result=$(extract_result "$output")
if [ "$result" = "XL" ]; then
    echo "✓ Test 7 passed: 40 = XL"
else
    echo "✗ Test 7 failed: expected XL, got '$result'"
fi

# Test 8: 90 -> XC
output=$(echo "90" | ./roman_numerals)
result=$(extract_result "$output")
if [ "$result" = "XC" ]; then
    echo "✓ Test 8 passed: 90 = XC"
else
    echo "✗ Test 8 failed: expected XC, got '$result'"
fi

# Test 9: 400 -> CD
output=$(echo "400" | ./roman_numerals)
result=$(extract_result "$output")
if [ "$result" = "CD" ]; then
    echo "✓ Test 9 passed: 400 = CD"
else
    echo "✗ Test 9 failed: expected CD, got '$result'"
fi

# Test 10: 900 -> CM
output=$(echo "900" | ./roman_numerals)
result=$(extract_result "$output")
if [ "$result" = "CM" ]; then
    echo "✓ Test 10 passed: 900 = CM"
else
    echo "✗ Test 10 failed: expected CM, got '$result'"
fi

echo ""
echo "=== Testing boundary cases ==="

# Test 11: 1 -> I
output=$(echo "1" | ./roman_numerals)
result=$(extract_result "$output")
if [ "$result" = "I" ]; then
    echo "✓ Test 11 passed: 1 = I"
else
    echo "✗ Test 11 failed: expected I, got '$result'"
fi

# Test 12: 3999 -> MMMCMXCIX (maximum)
output=$(echo "3999" | ./roman_numerals)
result=$(extract_result "$output")
if [ "$result" = "MMMCMXCIX" ]; then
    echo "✓ Test 12 passed: 3999 = MMMCMXCIX"
else
    echo "✗ Test 12 failed: expected MMMCMXCIX, got '$result'"
fi

echo ""
echo "=== Testing basic numbers ==="

# Test 13: 5 -> V
output=$(echo "5" | ./roman_numerals)
result=$(extract_result "$output")
if [ "$result" = "V" ]; then
    echo "✓ Test 13 passed: 5 = V"
else
    echo "✗ Test 13 failed: expected V, got '$result'"
fi

# Test 14: 10 -> X
output=$(echo "10" | ./roman_numerals)
result=$(extract_result "$output")
if [ "$result" = "X" ]; then
    echo "✓ Test 14 passed: 10 = X"
else
    echo "✗ Test 14 failed: expected X, got '$result'"
fi

# Test 15: 50 -> L
output=$(echo "50" | ./roman_numerals)
result=$(extract_result "$output")
if [ "$result" = "L" ]; then
    echo "✓ Test 15 passed: 50 = L"
else
    echo "✗ Test 15 failed: expected L, got '$result'"
fi

# Test 16: 100 -> C
output=$(echo "100" | ./roman_numerals)
result=$(extract_result "$output")
if [ "$result" = "C" ]; then
    echo "✓ Test 16 passed: 100 = C"
else
    echo "✗ Test 16 failed: expected C, got '$result'"
fi

# Test 17: 500 -> D
output=$(echo "500" | ./roman_numerals)
result=$(extract_result "$output")
if [ "$result" = "D" ]; then
    echo "✓ Test 17 passed: 500 = D"
else
    echo "✗ Test 17 failed: expected D, got '$result'"
fi

# Test 18: 1000 -> M
output=$(echo "1000" | ./roman_numerals)
result=$(extract_result "$output")
if [ "$result" = "M" ]; then
    echo "✓ Test 18 passed: 1000 = M"
else
    echo "✗ Test 18 failed: expected M, got '$result'"
fi

echo ""
echo "=== Testing complex numbers ==="

# Test 19: 27 -> XXVII
output=$(echo "27" | ./roman_numerals)
result=$(extract_result "$output")
if [ "$result" = "XXVII" ]; then
    echo "✓ Test 19 passed: 27 = XXVII"
else
    echo "✗ Test 19 failed: expected XXVII, got '$result'"
fi

# Test 20: 48 -> XLVIII
output=$(echo "48" | ./roman_numerals)
result=$(extract_result "$output")
if [ "$result" = "XLVIII" ]; then
    echo "✓ Test 20 passed: 48 = XLVIII"
else
    echo "✗ Test 20 failed: expected XLVIII, got '$result'"
fi

# Test 21: 59 -> LIX
output=$(echo "59" | ./roman_numerals)
result=$(extract_result "$output")
if [ "$result" = "LIX" ]; then
    echo "✓ Test 21 passed: 59 = LIX"
else
    echo "✗ Test 21 failed: expected LIX, got '$result'"
fi

# Test 22: 93 -> XCIII
output=$(echo "93" | ./roman_numerals)
result=$(extract_result "$output")
if [ "$result" = "XCIII" ]; then
    echo "✓ Test 22 passed: 93 = XCIII"
else
    echo "✗ Test 22 failed: expected XCIII, got '$result'"
fi

# Test 23: 141 -> CXLI
output=$(echo "141" | ./roman_numerals)
result=$(extract_result "$output")
if [ "$result" = "CXLI" ]; then
    echo "✓ Test 23 passed: 141 = CXLI"
else
    echo "✗ Test 23 failed: expected CXLI, got '$result'"
fi

# Test 24: 163 -> CLXIII
output=$(echo "163" | ./roman_numerals)
result=$(extract_result "$output")
if [ "$result" = "CLXIII" ]; then
    echo "✓ Test 24 passed: 163 = CLXIII"
else
    echo "✗ Test 24 failed: expected CLXIII, got '$result'"
fi

# Test 25: 402 -> CDII
output=$(echo "402" | ./roman_numerals)
result=$(extract_result "$output")
if [ "$result" = "CDII" ]; then
    echo "✓ Test 25 passed: 402 = CDII"
else
    echo "✗ Test 25 failed: expected CDII, got '$result'"
fi

# Test 26: 575 -> DLXXV
output=$(echo "575" | ./roman_numerals)
result=$(extract_result "$output")
if [ "$result" = "DLXXV" ]; then
    echo "✓ Test 26 passed: 575 = DLXXV"
else
    echo "✗ Test 26 failed: expected DLXXV, got '$result'"
fi

# Test 27: 911 -> CMXI
output=$(echo "911" | ./roman_numerals)
result=$(extract_result "$output")
if [ "$result" = "CMXI" ]; then
    echo "✓ Test 27 passed: 911 = CMXI"
else
    echo "✗ Test 27 failed: expected CMXI, got '$result'"
fi

# Test 28: 1024 -> MXXIV
output=$(echo "1024" | ./roman_numerals)
result=$(extract_result "$output")
if [ "$result" = "MXXIV" ]; then
    echo "✓ Test 28 passed: 1024 = MXXIV"
else
    echo "✗ Test 28 failed: expected MXXIV, got '$result'"
fi

# Test 29: 3000 -> MMM
output=$(echo "3000" | ./roman_numerals)
result=$(extract_result "$output")
if [ "$result" = "MMM" ]; then
    echo "✓ Test 29 passed: 3000 = MMM"
else
    echo "✗ Test 29 failed: expected MMM, got '$result'"
fi

echo ""
echo "=== Testing validation (should show error messages) ==="

echo "ℹ Test 30: Testing input validation for 0 (should show error)"
echo "0" | ./roman_numerals 2>/dev/null || echo "   Program correctly rejects 0"

echo "ℹ Test 31: Testing input validation for 4000 (should show error)"
echo "4000" | ./roman_numerals 2>/dev/null || echo "   Program correctly rejects 4000"

echo ""
echo "Roman numerals tests completed."