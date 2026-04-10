@echo off
cd /d "%~dp0"
echo Starting Brew CRM...
mvn spring-boot:run
pause
