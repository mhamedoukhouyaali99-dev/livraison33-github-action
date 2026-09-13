@echo off
cd /d "%~dp0"
if not exist reports mkdir reports
if exist reports\performance rmdir /s /q reports\performance
mkdir reports\performance

set "RUN_PERFORMANCE=1"
echo Lancement des tests de performance...
python -m pytest tests_performance -m performance -s -q > reports\performance\performance-results.txt 2>&1
set "status=%ERRORLEVEL%"
type reports\performance\performance-results.txt
exit /b %status%
