#!/bin/bash
# M35.6 Task 3 — recursive_directory_iterator + extension filter
set -u
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN="$SCRIPT_DIR/build/files_by_ext"

if [ ! -x "$BIN" ]; then
    cmake -S "$SCRIPT_DIR" -B "$SCRIPT_DIR/build" -DCMAKE_BUILD_TYPE=Release > /dev/null
    cmake --build "$SCRIPT_DIR/build" > /dev/null
fi

PASS=0
FAIL=0

# Setup test fixture: temp dir with mixed file extensions
TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT

mkdir -p "$TMPDIR/sub1" "$TMPDIR/sub2/inner"
touch "$TMPDIR/a.txt" "$TMPDIR/b.cpp" "$TMPDIR/c.txt"
touch "$TMPDIR/sub1/d.txt" "$TMPDIR/sub1/e.h"
touch "$TMPDIR/sub2/f.cpp" "$TMPDIR/sub2/inner/g.txt"

# Test 1: find .txt files (4 expected: a.txt, c.txt, d.txt, g.txt)
actual=$(timeout 5 "$BIN" "$TMPDIR" .txt 2>/dev/null | sort)
expected=$(printf "%s\n" a.txt c.txt d.txt g.txt | sort)
if [ "$actual" = "$expected" ]; then
    echo "[+] find-txt-recursive"; PASS=$((PASS+1))
else
    echo "[X] find-txt-recursive"
    echo "  expected:"; printf "%s\n" "$expected" | sed 's/^/    |/'
    echo "  actual:";   printf "%s\n" "$actual"   | sed 's/^/    |/'
    FAIL=$((FAIL+1))
fi

# Test 2: find .cpp (2 expected: b.cpp, f.cpp)
actual=$(timeout 5 "$BIN" "$TMPDIR" .cpp 2>/dev/null | sort)
expected=$(printf "%s\n" b.cpp f.cpp | sort)
if [ "$actual" = "$expected" ]; then
    echo "[+] find-cpp-recursive"; PASS=$((PASS+1))
else
    echo "[X] find-cpp-recursive"; FAIL=$((FAIL+1))
fi

# Test 3: find .h (1 expected: e.h)
actual=$(timeout 5 "$BIN" "$TMPDIR" .h 2>/dev/null)
if [ "$actual" = "e.h" ]; then
    echo "[+] find-h-single"; PASS=$((PASS+1))
else
    echo "[X] find-h-single (got: '$actual')"; FAIL=$((FAIL+1))
fi

# Test 4: no matches
actual=$(timeout 5 "$BIN" "$TMPDIR" .nonexistent 2>/dev/null)
if [ -z "$actual" ]; then
    echo "[+] no-matches"; PASS=$((PASS+1))
else
    echo "[X] no-matches (got: '$actual')"; FAIL=$((FAIL+1))
fi

# Test 5: missing path → returns nothing, no crash
actual=$(timeout 5 "$BIN" /nonexistent/path/12345 .txt 2>/dev/null)
if [ -z "$actual" ]; then
    echo "[+] missing-path-handled"; PASS=$((PASS+1))
else
    echo "[X] missing-path-handled (got: '$actual')"; FAIL=$((FAIL+1))
fi

# Test 6: usage on no args
"$BIN" > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "[+] usage-on-no-args"; PASS=$((PASS+1))
else
    echo "[X] usage-on-no-args"; FAIL=$((FAIL+1))
fi

# Source checks
check() {
    local name="$1"
    if eval "$2" > /dev/null 2>&1; then echo "[+] $name"; PASS=$((PASS+1))
    else echo "[X] $name"; FAIL=$((FAIL+1)); fi
}
check "uses-recursive-iter" "grep -q 'recursive_directory_iterator' '$SCRIPT_DIR/src/main.cpp'"
check "uses-lambda"         "grep -qE '\[\].*\(' '$SCRIPT_DIR/src/main.cpp'"
check "uses-extension"      "grep -q '.extension()' '$SCRIPT_DIR/src/main.cpp'"
check "uses-compare"        "grep -q '.compare(' '$SCRIPT_DIR/src/main.cpp'"
check "uses-is_regular_file" "grep -q 'is_regular_file' '$SCRIPT_DIR/src/main.cpp'"

echo
echo "Pass: $PASS, Fail: $FAIL"
[ $FAIL -eq 0 ]
