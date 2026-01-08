#!/usr/bin/env bash
BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PID_FILE="$BASE_DIR/bin/guide.pid"

if [ ! -f "$PID_FILE" ]; then
  echo "No pid file found"
  exit 1
fi

PID=$(cat "$PID_FILE")
kill -9 $PID
sleep 3
if kill -0 $PID 2>/dev/null; then
  echo "PID $PID still running; sending SIGKILL"
  kill -9 $PID
fi
rm -f "$PID_FILE"
echo "guide应用已停止"
