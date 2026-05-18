@echo off
:: Serve web/web-output/ on http://localhost:8080 for local testing.
setlocal
cd /d %~dp0
if not exist web-output\index.html (
    echo ERROR: web-output\index.html not found. Run web-build.bat first.
    exit /b 1
)
cd web-output

where python >nul 2>nul
if %ERRORLEVEL%==0 (
    echo Starting Python HTTP server on http://localhost:8080 ...
    start "" http://localhost:8080
    python -m http.server 8080
    exit /b 0
)

where npx >nul 2>nul
if %ERRORLEVEL%==0 (
    echo Starting Node http-server on http://localhost:8080 ...
    start "" http://localhost:8080
    call npx --yes http-server -p 8080
    exit /b 0
)

echo No supported local server found (Python or Node.js required).
exit /b 1
