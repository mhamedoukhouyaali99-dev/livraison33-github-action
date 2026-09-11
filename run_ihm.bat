@echo off
cd /d "%~dp0"
echo Lancement des tests IHM...
robot tests_ihm
exit /b %ERRORLEVEL%
