@echo off
cd /d "%~dp0"
echo Lancement des tests IHM...
python -m robot --outputdir reports\ihm tests_ihm
exit /b %ERRORLEVEL%