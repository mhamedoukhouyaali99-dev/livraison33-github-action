@echo off
cd /d "%~dp0"
if not exist reports mkdir reports
if exist reports\api rmdir /s /q reports\api
mkdir reports\api

echo Lancement des tests d'API...
python -m robot --outputdir reports\api tests_api
exit /b %ERRORLEVEL%
