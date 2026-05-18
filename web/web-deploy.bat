@echo off
:: ============================================================================
:: Legend of Lua - Production Deploy Build
::
:: 1. Builds the web bundle with <base href="/games/legend-of-lua/">.
:: 2. Restructures web-output/ into the layout expected by the challacade
::    homepage repo, which sidesteps Azure Static Web Apps' directory-index
::    quirks:
::        web-output/legend-of-lua.html   <- wrapper HTML (was index.html)
::        web-output/legend-of-lua/       <- all game assets
::    Copy BOTH the file and the folder into homepage/games/.
::
:: For local testing use web-build.bat (no base href) + web-run.bat instead.
:: ============================================================================
setlocal
set SLUG=legend-of-lua
cd /d %~dp0
set BUILD_DIR=%CD%
set OUT=%BUILD_DIR%\web-output

call "%BUILD_DIR%\web-build.bat" /games/%SLUG%/
if errorlevel 1 exit /b 1

if not exist "%OUT%\index.html" (
    echo ERROR: %OUT%\index.html missing after build.
    exit /b 1
)

echo.
echo Restructuring output for SWA deployment...
if exist "%OUT%\%SLUG%" rmdir /s /q "%OUT%\%SLUG%"
mkdir "%OUT%\%SLUG%"

:: Move every item in web-output/ into the SLUG subfolder, except index.html
:: and the SLUG folder itself.
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$out = '%OUT%'; $slug = '%SLUG%'; $sub = Join-Path $out $slug;" ^
    "Get-ChildItem -Path $out -Force | Where-Object { $_.Name -ne 'index.html' -and $_.Name -ne $slug } | ForEach-Object { Move-Item -Force -LiteralPath $_.FullName -Destination $sub }"
if errorlevel 1 (
    echo ERROR: Failed to move assets into %SLUG%\.
    exit /b 1
)

move /y "%OUT%\index.html" "%OUT%\%SLUG%.html" >nul
if errorlevel 1 (
    echo ERROR: Failed to rename index.html to %SLUG%.html.
    exit /b 1
)

echo.
echo ========================================
echo Deploy bundle ready:
echo   %OUT%\%SLUG%.html
echo   %OUT%\%SLUG%\
echo Copy BOTH into homepage repo at games\.
echo ========================================
endlocal
