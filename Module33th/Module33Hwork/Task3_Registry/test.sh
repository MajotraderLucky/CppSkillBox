#!/bin/bash
# M33.5 Task 3 — tests for templated Registry<K,V>
set -u
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN="$SCRIPT_DIR/build/registry"

if [ ! -x "$BIN" ]; then
    cmake -S "$SCRIPT_DIR" -B "$SCRIPT_DIR/build" -DCMAKE_BUILD_TYPE=Release > /dev/null
    cmake --build "$SCRIPT_DIR/build" > /dev/null
fi

PASS=0
FAIL=0

run_test() {
    local name="$1" types="$2" input="$3" expected="$4"
    local actual
    actual=$(printf "%s" "$input" | timeout 5 "$BIN" --types="$types" 2>/dev/null)
    if [ "$actual" = "$expected" ]; then
        echo "[+] $name"; PASS=$((PASS+1))
    else
        echo "[X] $name"
        echo "  expected:"; printf "%s\n" "$expected" | sed 's/^/    |/'
        echo "  actual:";   printf "%s\n" "$actual"   | sed 's/^/    |/'
        FAIL=$((FAIL+1))
    fi
}

# Test 1: int,int basics
run_test "int-int-add-find" "int,int" "add 1 100
add 1 200
add 2 99
find 1
exit
" "OK
OK
OK
100
200"

# Test 2: int,int print
run_test "int-int-print" "int,int" "add 1 10
add 2 20
print
exit
" "OK
OK
1 10
2 20"

# Test 3: int,int remove all by key
run_test "int-int-remove" "int,int" "add 1 100
add 1 200
add 2 99
remove 1
print
exit
" "OK
OK
OK
removed 2
2 99"

# Test 4: string,string
run_test "string-string" "string,string" "add foo bar
add foo baz
find foo
exit
" "OK
OK
bar
baz"

# Test 5: double,double
run_test "double-double" "double,double" "add 1.5 100.5
add 2.5 200.5
find 1.5
exit
" "OK
OK
100.5"

# Test 6: empty registry
run_test "empty-print" "int,int" "print
exit
" "(empty)"

# Test 7: find non-existent
run_test "find-missing" "int,int" "add 1 100
find 99
exit
" "OK
(no entries)"

# Test 8: int,string mixed
run_test "int-string" "int,string" "add 1 hello
add 2 world
find 1
exit
" "OK
OK
hello"

# Test 9: string,int
run_test "string-int" "string,int" "add alpha 1
add beta 2
add alpha 3
find alpha
exit
" "OK
OK
OK
1
3"

# Test 10: remove returns 0 when no match
run_test "remove-zero" "int,int" "remove 99
exit
" "removed 0"

echo
echo "Pass: $PASS, Fail: $FAIL"
[ $FAIL -eq 0 ]
