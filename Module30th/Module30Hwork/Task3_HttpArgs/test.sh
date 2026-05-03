#!/bin/bash
# Tests for M30.4 Task 3 — HTTP args (mock-server)
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"
BIN="$DIR/ha"
g++ -std=c++17 -O0 -Wall -Wextra -o "$BIN" main.cpp || { echo "COMPILE FAIL"; exit 1; }

PASS=0; FAIL=0; TOTAL=0
run_test() {
    local desc="$1" expected="$2" actual="$3"
    TOTAL=$((TOTAL+1))
    if [ "$expected" = "$actual" ]; then echo "  [+] $desc"; PASS=$((PASS+1));
    else echo "  [X] $desc"; echo "    expected: $expected"; echo "    actual:   $actual"; FAIL=$((FAIL+1)); fi
}

PORT=8767
trap 'kill $MOCK_PID 2>/dev/null' EXIT

# Mock-сервер: GET → echo args (?k=v&...), POST → echo form (k=v&...)
python3 -c "
import http.server, urllib.parse, json
class H(http.server.BaseHTTPRequestHandler):
    def _resp(self, payload):
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.end_headers()
        self.wfile.write(json.dumps(payload).encode())
    def do_GET(self):
        q = urllib.parse.urlparse(self.path).query
        args = dict(urllib.parse.parse_qsl(q))
        self._resp({'args': args})
    def do_POST(self):
        n = int(self.headers.get('Content-Length', 0))
        body = self.rfile.read(n).decode()
        form = dict(urllib.parse.parse_qsl(body))
        self._resp({'form': form})
    def log_message(self, *a, **k): pass
http.server.HTTPServer(('127.0.0.1', $PORT), H).serve_forever()
" &
MOCK_PID=$!
sleep 0.3

ARGS="--base=http://127.0.0.1:$PORT"

# Test 1: simple POST (std::map сортирует ключи: city < name)
ACT=$(printf "%s\n" "name" "Alice" "city" "Moscow" "post" | timeout 5 "$BIN" $ARGS 2>/dev/null | tail -1)
run_test "POST 2 args"   '{"form": {"city": "Moscow", "name": "Alice"}}' "$ACT"

# Test 2: simple GET
ACT=$(printf "%s\n" "foo" "bar" "x" "y" "get" | timeout 5 "$BIN" $ARGS 2>/dev/null | tail -1)
run_test "GET 2 args"    '{"args": {"foo": "bar", "x": "y"}}' "$ACT"

# Test 3: empty POST (immediate post)
ACT=$(printf "%s\n" "post" | timeout 5 "$BIN" $ARGS 2>/dev/null | tail -1)
run_test "POST no args"  '{"form": {}}' "$ACT"

# Test 4: empty GET
ACT=$(printf "%s\n" "get" | timeout 5 "$BIN" $ARGS 2>/dev/null | tail -1)
run_test "GET no args"   '{"args": {}}' "$ACT"

# Test 5: command header line
ACT=$(printf "%s\n" "post" | timeout 5 "$BIN" $ARGS 2>/dev/null | head -1)
run_test "POST header line" "=== post ===" "$ACT"

ACT=$(printf "%s\n" "get" | timeout 5 "$BIN" $ARGS 2>/dev/null | head -1)
run_test "GET header line" "=== get ===" "$ACT"

# Test 7: many args POST
ACT=$(printf "%s\n" "a" "1" "b" "2" "c" "3" "post" | timeout 5 "$BIN" $ARGS 2>/dev/null | tail -1)
run_test "POST 3 args" '{"form": {"a": "1", "b": "2", "c": "3"}}' "$ACT"

echo ""
echo "Total: $TOTAL Passed: $PASS Failed: $FAIL"
[ $FAIL -eq 0 ]
