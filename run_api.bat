@echo off
cd /d "%~dp0"
if not exist reports mkdir reports
if exist reports\api rmdir /s /q reports\api
mkdir reports\api

echo Lancement des tests d'API...
python -m robot --outputdir reports\api tests_api
set "robot_status=%ERRORLEVEL%"
if not exist reports\api-pytest mkdir reports\api-pytest
python -m pytest tests\test_api --html=reports\api-pytest\results_api.html --self-contained-html -q
set "pytest_status=%ERRORLEVEL%"

if not "%robot_status%"=="0" exit /b %robot_status%
exit /b %pytest_status%
