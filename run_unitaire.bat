@echo off
cd /d "%~dp0"
if not exist reports mkdir reports
if exist reports\unitaire rmdir /s /q reports\unitaire
mkdir reports\unitaire

echo Lancement des tests unitaires...
python -m unittest discover -v tests_unitaire > reports\unitaire\unit-test-results.txt 2>&1
type reports\unitaire\unit-test-results.txt
exit /b %ERRORLEVEL%
