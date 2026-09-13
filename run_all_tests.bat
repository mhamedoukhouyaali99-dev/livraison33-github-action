@echo off
setlocal
cd /d "%~dp0"

if exist reports rmdir /s /q reports
if exist log.html del /f /q log.html
if exist output.xml del /f /q output.xml
if exist report.html del /f /q report.html

set "global_status=0"

echo ===============================
echo LANCEMENT DE LA SUITE COMPLETE
echo ===============================

call run_unitaire.bat
if errorlevel 1 set "global_status=1"

call run_api.bat
if errorlevel 1 set "global_status=1"

call run_ihm.bat
if errorlevel 1 set "global_status=1"

call run_performance.bat
if errorlevel 1 set "global_status=1"

python scripts\generate_report_index.py --root reports
if errorlevel 1 set "global_status=1"

echo.
echo ===============================
echo RESULTAT GLOBAL
echo ===============================
if "%global_status%"=="0" (
    echo [OK] Tous les tests de la suite sont passés.
) else (
    echo [KO] Au moins un test de la suite a échoué.
)

exit /b %global_status%
