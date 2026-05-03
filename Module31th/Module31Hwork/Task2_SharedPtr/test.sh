#!/bin/bash
# M31.5 Task 2 — tests for custom shared_ptr_toy
# Reference scenario из спецификации: assert exact output.
set -u
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN="$SCRIPT_DIR/build/shared_ptr_toy"

if [ ! -x "$BIN" ]; then
    cmake -S "$SCRIPT_DIR" -B "$SCRIPT_DIR/build" -DCMAKE_BUILD_TYPE=Release > /dev/null
    cmake --build "$SCRIPT_DIR/build" > /dev/null
fi

PASS=0
FAIL=0

run_test() {
    local name="$1"
    local expected="$2"
    local actual
    # strip trailing whitespace per line — Toy::~Toy prints "was dropped " w/ trailing space
    actual=$(timeout 5 "$BIN" 2>/dev/null | sed 's/[[:space:]]*$//')
    expected=$(printf "%s" "$expected" | sed 's/[[:space:]]*$//')
    if [ "$actual" = "$expected" ]; then
        echo "[+] $name"
        PASS=$((PASS+1))
    else
        echo "[X] $name"
        echo "    expected:"
        echo "$expected" | sed 's/^/      |/'
        echo "    actual:"
        echo "$actual" | sed 's/^/      |/'
        FAIL=$((FAIL+1))
    fi
}

EXPECTED='=================================================
ball links:2  ball links:2  duck links:1
=================================================
ball links:1  duck links:2  duck links:2
=================================================
Toy ball was dropped
Nothing links:0  duck links:2  duck links:2
=================================================
Toy duck was dropped'

run_test "spec-reference-output" "$EXPECTED"

# Smoke checks via separate small programs (compile + run)
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

compile_run() {
    local src="$1"
    local bin="$TMPDIR/check"
    g++ -std=c++17 -O2 -x c++ - -o "$bin" <<EOF
$src
EOF
    "$bin" 2>/dev/null
}

# Helpers — paste shared_ptr_toy / Toy classes inline using sed to extract
HEADER=$(awk '/^class Toy/,/^shared_ptr_toy make_shared_toy/{print}' "$SCRIPT_DIR/src/main.cpp" \
    | sed '$d')   # drop trailing blank
HEADER="$HEADER
shared_ptr_toy make_shared_toy(const std::string& name) { return shared_ptr_toy(name); }"

# Helper to assemble check program with custom main
PROGRAM_PRELUDE='#include <iostream>
#include <string>
'

run_inline() {
    local name="$1"
    local body="$2"
    local expected="$3"
    local prog="${PROGRAM_PRELUDE}
${HEADER}

int main() {
${body}
    return 0;
}"
    local actual
    actual=$(compile_run "$prog" | sed 's/[[:space:]]*$//')
    expected=$(printf "%s" "$expected" | sed 's/[[:space:]]*$//')
    if [ "$actual" = "$expected" ]; then
        echo "[+] $name"
        PASS=$((PASS+1))
    else
        echo "[X] $name"
        echo "    expected:"
        echo "$expected" | sed 's/^/      |/'
        echo "    actual:"
        echo "$actual" | sed 's/^/      |/'
        FAIL=$((FAIL+1))
    fi
}

# Test 2: default ctor produces empty pointer
run_inline "default-ctor-empty" '
    shared_ptr_toy p;
    std::cout << p.getToyName() << " links:" << p.use_count() << std::endl;
' \
"Nothing links:0"

# Test 3: get() returns nullptr for empty
run_inline "get-empty-nullptr" '
    shared_ptr_toy p;
    std::cout << (p.get() == nullptr ? "null" : "set") << std::endl;
' \
"null"

# Test 4: get() non-null after construction
run_inline "get-nonnull-when-named" '
    shared_ptr_toy p("ball");
    std::cout << (p.get() != nullptr ? "set" : "null") << std::endl;
' \
"set
Toy ball was dropped"

# Test 5: copy ctor increments
run_inline "copy-ctor-counts" '
    shared_ptr_toy a("x");
    shared_ptr_toy b(a);
    shared_ptr_toy c(b);
    std::cout << a.use_count() << " " << b.use_count() << " " << c.use_count() << std::endl;
' \
"3 3 3
Toy x was dropped"

# Test 6: assign to self → no change
run_inline "self-assign" '
    shared_ptr_toy a("x");
    a = a;
    std::cout << a.getToyName() << " " << a.use_count() << std::endl;
' \
"x 1
Toy x was dropped"

# Test 7: assign to same toy → no change
run_inline "same-toy-assign" '
    shared_ptr_toy a("x");
    shared_ptr_toy b(a);
    a = b;
    std::cout << a.use_count() << " " << b.use_count() << std::endl;
' \
"2 2
Toy x was dropped"

# Test 8: assign different toy → old released, new captured
run_inline "diff-toy-assign-releases" '
    {
        shared_ptr_toy a("x");
        shared_ptr_toy b("y");
        a = b;
        std::cout << a.use_count() << " " << a.getToyName() << std::endl;
    }
    std::cout << "after" << std::endl;
' \
"Toy x was dropped
2 y
Toy y was dropped
after"

# Test 9: reset releases ownership without destroying object (other holder exists)
run_inline "reset-with-other-holder" '
    shared_ptr_toy a("x");
    shared_ptr_toy b(a);
    a.reset();
    std::cout << a.getToyName() << " " << a.use_count() << " " << b.use_count() << std::endl;
' \
"Nothing 0 1
Toy x was dropped"

# Test 10: reset on last owner → object dies
run_inline "reset-last-owner-dies" '
    shared_ptr_toy a("x");
    a.reset();
    std::cout << "after" << std::endl;
' \
"Toy x was dropped
after"

# Test 11: make_shared_toy returns shared_ptr_toy holding new toy
run_inline "make-shared-toy-helper" '
    shared_ptr_toy a = make_shared_toy("ball");
    std::cout << a.getToyName() << " " << a.use_count() << std::endl;
' \
"ball 1
Toy ball was dropped"

# Test 12: chain of assignments preserves correct counts
run_inline "chain-assign" '
    shared_ptr_toy a("x");
    shared_ptr_toy b("y");
    shared_ptr_toy c("z");
    a = b;            // a=y(2), b=y(2), c=z(1)
    b = c;            // a=y(1), b=z(2), c=z(2)
    std::cout << a.use_count() << " " << b.use_count() << " " << c.use_count() << std::endl;
' \
"Toy x was dropped
1 2 2
Toy z was dropped
Toy y was dropped"

echo
echo "Pass: $PASS, Fail: $FAIL"
[ $FAIL -eq 0 ]
