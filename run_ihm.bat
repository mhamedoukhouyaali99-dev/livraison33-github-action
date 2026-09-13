@echo off
cd /d "%~dp0"
if not exist reports mkdir reports
if exist reports\ihm rmdir /s /q reports\ihm
mkdir reports\ihm

echo Lancement des tests IHM...
python -m robot --outputdir reports\ihm tests_ihm
exit /b %ERRORLEVEL%