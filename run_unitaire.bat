@echo off
cd /d "%~dp0"
echo Lancement des tests unitaires...
python -m unittest discover -v tests_unitaire
exit /b %ERRORLEVEL%
