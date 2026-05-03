#!/bin/bash
# Tests for M30.4 Task 1 — HTTP commands.
# Использует mock-сервер на python3 чтобы не зависеть от httpbin.org.
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"
BIN="$DIR/hc"
g++ -std=c++17 -O0 -Wall -Wextra -o "$BIN" main.cpp || { echo "COMPILE FAIL"; exit 1; }

PASS=0; FAIL=0; TOTAL=0
run_test() {
    local desc="$1" expected="$2" actual="$3"
    TOTAL=$((TOTAL+1))
    if [ "$expected" = "$actual" ]; then echo "  [+] $desc"; PASS=$((PASS+1));
    else echo "  [X] $desc"; echo "    expected: $expected"; echo "    actual:   $actual"; FAIL=$((FAIL+1)); fi
}

# === Mock HTTP сервер на python ===
PORT=8765
MOCKLOG=$(mktemp)
trap 'kill $MOCK_PID 2>/dev/null; rm -f "$MOCKLOG"' EXIT

python3 -c "
import http.server, json
class H(http.server.BaseHTTPRequestHandler):
    def _resp(self):
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.end_headers()
        body = json.dumps({'method': self.command, 'path': self.path}).encode()
        self.wfile.write(body)
    def do_GET(self):    self._resp()
    def do_POST(self):   self._resp()
    def do_PUT(self):    self._resp()
    def do_DELETE(self): self._resp()
    def do_PATCH(self):  self._resp()
    def log_message(self, *a, **k): pass
http.server.HTTPServer(('127.0.0.1', $PORT), H).serve_forever()
" &
MOCK_PID=$!
sleep 0.3

# Подменяем BASE_URL через recompile
sed "s|http://httpbin.org|http://127.0.0.1:$PORT|" main.cpp > main_test.cpp
g++ -std=c++17 -O0 -Wall -Wextra -o "$BIN" main_test.cpp
rm -f main_test.cpp

# Test 1: exit
ACT=$(echo "exit" | timeout 5 "$BIN" 2>/dev/null)
run_test "exit immediately" "EXIT" "$ACT"

# Test 2: GET
ACT=$(printf "%s\n" "get" "exit" | timeout 5 "$BIN" 2>/dev/null | tail -1 | grep -o '"method": "GET"')
run_test "GET request returns method GET" '"method": "GET"' "$ACT"

# Test 3: POST
ACT=$(printf "%s\n" "post" "exit" | timeout 5 "$BIN" 2>/dev/null | tail -1 | grep -o '"method": "POST"')
run_test "POST request returns method POST" '"method": "POST"' "$ACT"

# Test 4: PUT
ACT=$(printf "%s\n" "put" "exit" | timeout 5 "$BIN" 2>/dev/null | tail -1 | grep -o '"method": "PUT"')
run_test "PUT request returns method PUT" '"method": "PUT"' "$ACT"

# Test 5: DELETE
ACT=$(printf "%s\n" "delete" "exit" | timeout 5 "$BIN" 2>/dev/null | tail -1 | grep -o '"method": "DELETE"')
run_test "DELETE request returns method DELETE" '"method": "DELETE"' "$ACT"

# Test 6: PATCH
ACT=$(printf "%s\n" "patch" "exit" | timeout 5 "$BIN" 2>/dev/null | tail -1 | grep -o '"method": "PATCH"')
run_test "PATCH request returns method PATCH" '"method": "PATCH"' "$ACT"

# Test 7: header line for each command
ACT=$(printf "%s\n" "get" "exit" | timeout 5 "$BIN" 2>/dev/null | head -1)
run_test "GET header line" "=== GET /get ===" "$ACT"

# Test 8: unknown command — пропускается, exit срабатывает
ACT=$(printf "%s\n" "weird" "exit" | timeout 5 "$BIN" 2>/dev/null)
run_test "unknown command then exit" "EXIT" "$ACT"

echo ""
echo "Total: $TOTAL Passed: $PASS Failed: $FAIL"
[ $FAIL -eq 0 ]
