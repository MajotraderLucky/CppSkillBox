#!/bin/bash
# M32.5 Task 1 — validate film.json structure
set -u
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JSON="$SCRIPT_DIR/film.json"

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

check "valid-json"        "python3 -m json.tool '$JSON'"
check "has-title"         "python3 -c 'import json,sys; d=json.load(open(\"$JSON\")); sys.exit(0 if \"title\" in d else 1)'"
check "has-country"       "python3 -c 'import json,sys; d=json.load(open(\"$JSON\")); sys.exit(0 if \"country\" in d else 1)'"
check "has-release-date"  "python3 -c 'import json,sys; d=json.load(open(\"$JSON\")); sys.exit(0 if \"release_date\" in d else 1)'"
check "has-studio"        "python3 -c 'import json,sys; d=json.load(open(\"$JSON\")); sys.exit(0 if \"studio\" in d else 1)'"
check "has-screenwriter"  "python3 -c 'import json,sys; d=json.load(open(\"$JSON\")); sys.exit(0 if \"screenwriter\" in d else 1)'"
check "has-director"      "python3 -c 'import json,sys; d=json.load(open(\"$JSON\")); sys.exit(0 if \"director\" in d else 1)'"
check "has-producers"     "python3 -c 'import json,sys; d=json.load(open(\"$JSON\")); sys.exit(0 if isinstance(d.get(\"producers\"), list) else 1)'"
check "cast-is-array"     "python3 -c 'import json,sys; d=json.load(open(\"$JSON\")); sys.exit(0 if isinstance(d.get(\"cast\"), list) else 1)'"
check "cast-has-actor-role" "python3 -c 'import json,sys; d=json.load(open(\"$JSON\")); sys.exit(0 if all(\"actor\" in c and \"role\" in c for c in d[\"cast\"]) else 1)'"
check "cast-not-empty"    "python3 -c 'import json,sys; d=json.load(open(\"$JSON\")); sys.exit(0 if len(d[\"cast\"]) > 0 else 1)'"

echo
echo "Pass: $PASS, Fail: $FAIL"
[ $FAIL -eq 0 ]
