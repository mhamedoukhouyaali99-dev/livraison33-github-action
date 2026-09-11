@echo off
cd /d "%~dp0"
echo Lancement des tests d'API...
robot tests_api
exit /b %ERRORLEVEL%
