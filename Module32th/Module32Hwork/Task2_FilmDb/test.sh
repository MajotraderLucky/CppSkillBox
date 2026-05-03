#!/bin/bash
# M32.5 Task 2 — tests for film DB actor search
set -u
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN="$SCRIPT_DIR/build/filmdb"
DB="$SCRIPT_DIR/films.json"

if [ ! -x "$BIN" ]; then
    cmake -S "$SCRIPT_DIR" -B "$SCRIPT_DIR/build" -DCMAKE_BUILD_TYPE=Release > /dev/null
    cmake --build "$SCRIPT_DIR/build" > /dev/null
fi

PASS=0
FAIL=0

run_test() {
    local name="$1"; shift
    local expected="$1"; shift
    local actual
    actual=$(timeout 5 "$BIN" --db="$DB" "$@" 2>/dev/null | sort)
    expected=$(printf "%s" "$expected" | sort)
    if [ "$actual" = "$expected" ]; then
        echo "[+] $name"; PASS=$((PASS+1))
    else
        echo "[X] $name"
        echo "  expected:"; printf "%s\n" "$expected" | sed 's/^/    |/'
        echo "  actual:";   printf "%s\n" "$actual"   | sed 's/^/    |/'
        FAIL=$((FAIL+1))
    fi
}

# Test 1: actor in two films
run_test "DiCaprio-2-films" \
"Inception | Leonardo DiCaprio as Dom Cobb
Django Unchained | Leonardo DiCaprio as Calvin Candie" \
--query=DiCaprio

# Test 2: case-insensitive
run_test "case-insensitive-dicaprio" \
"Inception | Leonardo DiCaprio as Dom Cobb
Django Unchained | Leonardo DiCaprio as Calvin Candie" \
--query=dicaprio

# Test 3: Michael Caine in 2 films (Dark Knight + Interstellar)
run_test "michael-caine-2-films" \
"The Dark Knight | Michael Caine as Alfred Pennyworth
Interstellar | Michael Caine as Professor Brand" \
--query="Caine"

# Test 4: Samuel L. Jackson in 2 films
run_test "samuel-jackson-2-films" \
"Pulp Fiction | Samuel L. Jackson as Jules Winnfield
Django Unchained | Samuel L. Jackson as Stephen" \
--query="Jackson"

# Test 5: actor with no matches
run_test "no-matches" \
"No matches" \
--query="Robert Downey Jr"

# Test 6: substring match by first name
run_test "first-name-only" \
"Pulp Fiction | Samuel L. Jackson as Jules Winnfield
Django Unchained | Samuel L. Jackson as Stephen" \
--query="Samuel"

# Test 7: Cillian Murphy in 2 films
run_test "cillian-murphy-2-films" \
"Inception | Cillian Murphy as Robert Fischer
The Dark Knight | Cillian Murphy as Jonathan Crane / Scarecrow" \
--query="Murphy"

# Test 8: Heath Ledger only one film
run_test "heath-ledger-one-film" \
"The Dark Knight | Heath Ledger as Joker" \
--query="Ledger"

echo
echo "Pass: $PASS, Fail: $FAIL"
[ $FAIL -eq 0 ]
