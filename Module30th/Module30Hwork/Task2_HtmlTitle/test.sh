#!/bin/bash
# Tests for M30.4 Task 2 — HTML title (mock-server)
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"
BIN="$DIR/ht"
g++ -std=c++17 -O0 -Wall -Wextra -o "$BIN" main.cpp || { echo "COMPILE FAIL"; exit 1; }

PASS=0; FAIL=0; TOTAL=0
run_test() {
    local desc="$1" expected="$2" actual="$3"
    TOTAL=$((TOTAL+1))
    if [ "$expected" = "$actual" ]; then echo "  [+] $desc"; PASS=$((PASS+1));
    else echo "  [X] $desc"; echo "    expected: $expected"; echo "    actual:   $actual"; FAIL=$((FAIL+1)); fi
}

PORT=8766
trap 'kill $MOCK_PID 2>/dev/null' EXIT

start_mock() {
    local html_body="$1"
    python3 -c "
import http.server
class H(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-Type', 'text/html')
        self.end_headers()
        self.wfile.write(b'''$html_body''')
    def log_message(self, *a, **k): pass
http.server.HTTPServer(('127.0.0.1', $PORT), H).serve_forever()
" &
    MOCK_PID=$!
    sleep 0.2
}

stop_mock() {
    kill $MOCK_PID 2>/dev/null
    wait $MOCK_PID 2>/dev/null
}

# Test 1: standard <h1>
start_mock "<html><body><h1>Hello World</h1></body></html>"
ACT=$(timeout 5 "$BIN" --url=http://127.0.0.1:$PORT/ 2>/dev/null)
run_test "extract simple h1" "Hello World" "$ACT"
stop_mock

# Test 2: no h1 → NOT FOUND
start_mock "<html><body><p>no headline</p></body></html>"
ACT=$(timeout 5 "$BIN" --url=http://127.0.0.1:$PORT/ 2>/dev/null)
run_test "no h1 → NOT FOUND" "NOT FOUND" "$ACT"
stop_mock

# Test 3: h1 with multi-word text
start_mock "<h1>Herman Melville - Moby-Dick</h1>"
ACT=$(timeout 5 "$BIN" --url=http://127.0.0.1:$PORT/ 2>/dev/null)
run_test "h1 with hyphens and spaces" "Herman Melville - Moby-Dick" "$ACT"
stop_mock

# Test 4: empty body → NOT FOUND
start_mock ""
ACT=$(timeout 5 "$BIN" --url=http://127.0.0.1:$PORT/ 2>/dev/null)
run_test "empty body → NOT FOUND" "NOT FOUND" "$ACT"
stop_mock

# Test 5: only opening tag → NOT FOUND
start_mock "<h1>incomplete"
ACT=$(timeout 5 "$BIN" --url=http://127.0.0.1:$PORT/ 2>/dev/null)
run_test "missing </h1> → NOT FOUND" "NOT FOUND" "$ACT"
stop_mock

# Test 6: first h1 wins (multiple)
start_mock "<h1>First</h1> <h1>Second</h1>"
ACT=$(timeout 5 "$BIN" --url=http://127.0.0.1:$PORT/ 2>/dev/null)
run_test "first h1 wins" "First" "$ACT"
stop_mock

echo ""
echo "Total: $TOTAL Passed: $PASS Failed: $FAIL"
[ $FAIL -eq 0 ]
