#!/bin/bash
# Brew CRM - Ubuntu OCI 서버 자동 설정 스크립트
set -e

echo "============================================"
echo "  Brew CRM - 서버 설정 시작 (Ubuntu)"
echo "============================================"

# ──────────────────────────────────────────────
# 1. Java 17 설치
# ──────────────────────────────────────────────
echo ""
echo "[1/6] Java 17 설치 확인..."
if java -version 2>&1 | grep -q "17\|21"; then
    echo "  → Java 이미 설치됨. 건너뜀."
else
    echo "  → Java 17 설치 중..."
    apt-get update -qq
    apt-get install -y openjdk-17-jre-headless
    echo "  → Java 설치 완료."
fi
java -version

# ──────────────────────────────────────────────
# 2. MySQL 설치
# ──────────────────────────────────────────────
echo ""
echo "[2/6] MySQL 설치 확인..."
if systemctl is-active --quiet mysql 2>/dev/null; then
    echo "  → MySQL 이미 실행 중. 건너뜀."
else
    echo "  → MySQL 설치 중..."
    apt-get install -y mysql-server
    systemctl start mysql
    systemctl enable mysql
    echo "  → MySQL 설치 및 시작 완료."
fi

# ──────────────────────────────────────────────
# 3. MySQL DB / 사용자 생성
# ──────────────────────────────────────────────
echo ""
echo "[3/6] DB 및 사용자 설정..."
mysql -u root <<'EOF'
CREATE DATABASE IF NOT EXISTS dbstudy CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'dbuser'@'localhost' IDENTIFIED BY '1234';
GRANT ALL PRIVILEGES ON dbstudy.* TO 'dbuser'@'localhost';
FLUSH PRIVILEGES;
EOF
echo "  → DB 및 사용자 설정 완료."

# ──────────────────────────────────────────────
# 4. 스키마 적용
# ──────────────────────────────────────────────
echo ""
echo "[4/6] DB 스키마 적용..."
if [ -f /home/ubuntu/schema.sql ]; then
    mysql -u dbuser -p1234 dbstudy < /home/ubuntu/schema.sql 2>/dev/null || true
    echo "  → 스키마 적용 완료."
else
    echo "  → schema.sql 없음. 건너뜀."
fi

# ──────────────────────────────────────────────
# 5. 방화벽 포트 8081 열기
# ──────────────────────────────────────────────
echo ""
echo "[5/6] 방화벽 포트 8081 열기..."
ufw allow 8081/tcp 2>/dev/null || true
echo "  → 완료."

# ──────────────────────────────────────────────
# 6. 기존 앱 종료 후 재시작
# ──────────────────────────────────────────────
echo ""
echo "[6/6] Brew CRM 앱 시작..."

if [ -f /home/ubuntu/app.pid ]; then
    OLD_PID=$(cat /home/ubuntu/app.pid)
    kill "$OLD_PID" 2>/dev/null || true
    sleep 2
    rm -f /home/ubuntu/app.pid
    echo "  → 기존 프로세스 종료."
fi

nohup java -jar /home/ubuntu/brew-crm.war \
    > /home/ubuntu/app.log 2>&1 &

echo $! > /home/ubuntu/app.pid
echo "  → PID: $(cat /home/ubuntu/app.pid)"

sleep 6

echo ""
if grep -q "Started BrewCrmApplication" /home/ubuntu/app.log 2>/dev/null; then
    echo "  → 앱 정상 시작 확인!"
else
    echo "  → 앱 시작 중... (로그: tail -f /home/ubuntu/app.log)"
fi

echo ""
echo "============================================"
echo "  배포 완료!"
echo "  접속 주소: http://168.107.6.6:8081/brew-crm"
echo "  로그 확인: tail -f /home/ubuntu/app.log"
echo "============================================"
