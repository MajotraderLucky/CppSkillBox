#!/bin/bash
# M33.5 Task 1 — tests for shopping cart
set -u
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN="$SCRIPT_DIR/build/cart"

if [ ! -x "$BIN" ]; then
    cmake -S "$SCRIPT_DIR" -B "$SCRIPT_DIR/build" -DCMAKE_BUILD_TYPE=Release > /dev/null
    cmake --build "$SCRIPT_DIR/build" > /dev/null
fi

PASS=0
FAIL=0

run_test() {
    local name="$1" input="$2" expected="$3"
    local actual
    actual=$(printf "%s" "$input" | timeout 5 "$BIN" 2>/dev/null)
    if [ "$actual" = "$expected" ]; then
        echo "[+] $name"; PASS=$((PASS+1))
    else
        echo "[X] $name"
        echo "  expected:"; printf "%s\n" "$expected" | sed 's/^/    |/'
        echo "  actual:";   printf "%s\n" "$actual"   | sed 's/^/    |/'
        FAIL=$((FAIL+1))
    fi
}

# Test 1: stock + add + list
run_test "stock-add-list" "stock A 10
add A 3
list
exit
" "OK
OK
A 3"

# Test 2: add unknown sku → invalid
run_test "add-unknown" "add UNKNOWN 1
exit
" "Invalid: unknown sku: UNKNOWN"

# Test 3: add too many → runtime
run_test "add-too-many" "stock A 5
add A 10
exit
" "OK
Runtime: not enough on stock for sku: A"

# Test 4: zero qty → invalid
run_test "zero-qty" "stock A 5
add A 0
exit
" "OK
Invalid: qty must be positive"

# Test 5: negative qty → invalid
run_test "negative-qty" "stock A 5
add A -1
exit
" "OK
Invalid: qty must be positive"

# Test 6: remove from empty cart → invalid
run_test "remove-empty" "stock A 5
remove A 1
exit
" "OK
Invalid: sku not in cart: A"

# Test 7: full lifecycle
run_test "full-lifecycle" "stock A 10
stock B 5
add A 3
add B 2
remove A 1
list
exit
" "OK
OK
OK
OK
OK
A 2
B 2"

# Test 8: remove too many from cart → runtime
run_test "remove-too-many" "stock A 10
add A 3
remove A 5
exit
" "OK
OK
Runtime: not enough in cart for sku: A"

# Test 9: empty cart list
run_test "list-empty" "list
exit
" "Cart is empty"

echo
echo "Pass: $PASS, Fail: $FAIL"
[ $FAIL -eq 0 ]
