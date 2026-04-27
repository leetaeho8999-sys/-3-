# ============================================================
# ROWNCafe — Multi-stage Dockerfile
# Stage 1: Maven으로 WAR 빌드
# Stage 2: JRE 런타임에 WAR만 복사해서 실행
# ============================================================

# ---- Stage 1: Build ----
FROM maven:3.9-eclipse-temurin-21 AS builder
WORKDIR /build

# pom.xml 먼저 복사 → 의존성만 미리 다운로드 (Docker 캐시 활용)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# 소스 복사 후 빌드
COPY src ./src
RUN mvn clean package -DskipTests -B

# ---- Stage 2: Runtime ----
FROM eclipse-temurin:21-jre

WORKDIR /app

ENV TZ=Asia/Seoul
RUN apt-get update && apt-get install -y --no-install-recommends tzdata curl && ln -fs /usr/share/zoneinfo/Asia/Seoul /etc/localtime && rm -rf /var/lib/apt/lists/*

# 빌더에서 만든 WAR만 복사
COPY --from=builder /build/target/cafe-0.0.1-SNAPSHOT.war app.war

ENV JAVA_OPTS="-Xms256m -Xmx512m -XX:+UseContainerSupport"

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=5 CMD curl -fsS http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["sh","-c","java $JAVA_OPTS -jar app.war"]
