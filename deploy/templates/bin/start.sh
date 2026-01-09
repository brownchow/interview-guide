#!/usr/bin/env bash
BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CONF_DIR="$BASE_DIR/config"
LIB_DIR="$BASE_DIR/lib"
LOG_DIR="$BASE_DIR/logs"
JAR="$BASE_DIR/guide.jar"
PID_FILE="$BASE_DIR/bin/guide.pid"

mkdir -p "$LOG_DIR"

JAVA_OPTS="-Xms512m -Xmx1g"
SPRING_OPTS="-Dspring.config.location=file:$CONF_DIR/application.yml -Dlogging.config=file:$CONF_DIR/logback-spring.xml"

# 可选远程调试（OpenJDK 21）
# 取消下面一行的注释并根据需要修改端口即可启用远程调试
DEBUG_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005"
DEBUG_OPTS="${DEBUG_OPTS:-}"

if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
  echo "应用程序 AI 面试后端已运行 (PID $(cat $PID_FILE))"
  exit 1
fi

nohup java $JAVA_OPTS $DEBUG_OPTS $SPRING_OPTS -cp "$JAR:$LIB_DIR/*" interview.guide.App > "$LOG_DIR/guide.out" 2>&1 &

echo $! > "$PID_FILE"
echo "guide应用已启动, PID $(cat $PID_FILE)"
