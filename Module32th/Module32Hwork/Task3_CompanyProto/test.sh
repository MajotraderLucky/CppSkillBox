#!/bin/bash
# M32.5 Task 3 — tests for Company.proto compilation
set -u
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROTOC="${PROTOC:-$HOME/.local/protoc/bin/protoc}"
PROTO="$SCRIPT_DIR/src/company.proto"
GEN="$SCRIPT_DIR/gen"

if [ ! -x "$PROTOC" ]; then
    echo "[!] protoc not found at $PROTOC"
    echo "    Set PROTOC env var or install protobuf-compiler"
    exit 1
fi

PASS=0
FAIL=0

check() {
    local name="$1"
    if eval "$2" > /dev/null 2>&1; then
        echo "[+] $name"; PASS=$((PASS+1))
    else
        echo "[X] $name"; FAIL=$((FAIL+1))
    fi
}

# Test 1: protoc compiles the .proto file successfully
mkdir -p "$GEN"
check "protoc-compile-success" \
"'$PROTOC' --proto_path='$SCRIPT_DIR/src' --cpp_out='$GEN' '$PROTO'"

# Test 2: .pb.h generated
check "pb-h-exists" "[ -f '$GEN/company.pb.h' ]"

# Test 3: .pb.cc generated
check "pb-cc-exists" "[ -f '$GEN/company.pb.cc' ]"

# Test 4: generated class is named Company
check "class-Company-defined" "grep -q '^class Company' '$GEN/company.pb.h'"

# Test 5: required field founded_year present (setter)
check "founded_year-setter"   "grep -q 'set_founded_year' '$GEN/company.pb.h'"

# Test 6: required field legal_address present
check "legal_address-setter"  "grep -q 'set_legal_address' '$GEN/company.pb.h'"

# Test 7: required field name present
check "name-setter"           "grep -q 'set_name' '$GEN/company.pb.h'"

# Test 8: optional field activity present
check "activity-setter"       "grep -q 'set_activity' '$GEN/company.pb.h'"

# Test 9: optional field foreign_economic present
check "foreign_economic-setter" "grep -q 'set_foreign_economic' '$GEN/company.pb.h'"

# Test 10: package skillbox.m32 in proto file
check "package-skillbox-m32"  "grep -q 'package skillbox.m32' '$PROTO'"

# Test 11: proto2 syntax declared
check "proto2-syntax"         "grep -q 'syntax = \"proto2\"' '$PROTO'"

# Test 12: founded_year is int32
check "founded_year-int32"    "grep -q 'required int32  *founded_year' '$PROTO'"

# Test 13: 5 fields total (5 = signs after type names — `= N;`)
check "5-fields-total" \
"[ \$(grep -cE '^[[:space:]]*(required|optional)[[:space:]]+(int32|string|bool)[[:space:]]+[a-z_]+[[:space:]]*=' '$PROTO') -eq 5 ]"

# Test 14: 3 required + 2 optional
check "3-required-fields"  "[ \$(grep -c '^[[:space:]]*required' '$PROTO') -eq 3 ]"
check "2-optional-fields"  "[ \$(grep -c '^[[:space:]]*optional' '$PROTO') -eq 2 ]"

echo
echo "Pass: $PASS, Fail: $FAIL"
[ $FAIL -eq 0 ]
