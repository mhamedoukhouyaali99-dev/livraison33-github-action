@echo off
setlocal
cd /d "%~dp0"

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
