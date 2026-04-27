#!/bin/bash
# ============================================================
# ROWNCafe — 배포 스크립트
# 사용: ./deploy.sh
# ============================================================
set -e  # 어느 단계라도 실패하면 즉시 중단

# 작업 디렉토리 (스크립트 위치 기준)
cd "$(dirname "$0")"

echo ""
echo "===== [1/4] git pull ====="
git pull

echo ""
echo "===== [2/4] Docker 이미지 빌드 ====="
docker compose build app
echo "  빌드 완료"

echo ""
echo "===== [3/4] 컨테이너 재기동 (app만) ====="
docker compose up -d --no-deps app
echo "  app 재기동 완료"

echo ""
echo "===== [4/4] 상태 확인 ====="
sleep 5
docker compose ps
echo ""
echo "  로그 보기: docker compose logs -f app"
echo "  접속:      http://134.185.108.180/"
echo ""
echo "배포 완료. Spring Boot 기동에 1~2분 걸릴 수 있습니다."
