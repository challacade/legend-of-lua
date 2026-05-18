@echo off
:: ============================================================================
:: Legend of Lua - Web Build Script (Windows)
::
:: Packages the project into a .love archive, then assembles the 2dengine
:: love.js player files into web/web-output/ ready for local testing or deploy.
::
:: Requirements: None (no Node.js required).
:: The love.js player is read from the sibling love.js fork; see LOVEJS_DIR.
::
:: Usage:
::   web-build.bat               -- local build (no <base href>)
::   web-build.bat /games/legend-of-lua/ -- deploy build with explicit base path
::
:: !! IMPORTANT: love.js player.js caches the .love archive in IndexedDB
:: (EM_PRELOAD_CACHE / PACKAGES) keyed by URI. The first bytes ever served
:: for a given .love filename are replayed FOREVER -- rebuilds are silently
:: ignored. index.template.html appends `&n=1` to the player.js script src
:: to disable that cache. End-user caching is unaffected (browser HTTP cache
:: still applies). DO NOT remove `&n=1`. See the extended comment in
:: web/index.template.html for the full backstory.
:: ============================================================================

setlocal
set PROJECT_NAME=Legend of Lua
set LOVE_FILE=legend-of-lua.love
set OUTPUT_DIR=web-output
if not defined BASE_HREF set BASE_HREF=
if not "%~1"=="" set BASE_HREF=%~1

:: Run from web/ regardless of where the script is invoked from.
cd /d %~dp0
set BUILD_DIR=%CD%
cd ..
set PROJECT_ROOT=%CD%

:: Path to the love.js fork. Defaults to the sibling Projects\love.js folder.
:: Change this if your fork lives elsewhere.
set LOVEJS_DIR=%PROJECT_ROOT%\..\love.js

echo ========================================
echo Legend of Lua Web Build (2dengine)
echo ========================================
echo Project root:  %PROJECT_ROOT%
echo love.js dir:   %LOVEJS_DIR%
echo Output dir:    %BUILD_DIR%\%OUTPUT_DIR%
echo.

:: Verify love.js player source exists.
if not exist "%LOVEJS_DIR%\player.js" (
    echo ERROR: love.js player not found at:
    echo   %LOVEJS_DIR%\player.js
    echo.
    echo Clone the fork with:
    echo   git clone https://github.com/challacade/love.js.git "%LOVEJS_DIR%"
    exit /b 1
)

:: Clean up previous output and create fresh directory structure.
if exist "%BUILD_DIR%\%OUTPUT_DIR%" rmdir /s /q "%BUILD_DIR%\%OUTPUT_DIR%"
mkdir "%BUILD_DIR%\%OUTPUT_DIR%"
mkdir "%BUILD_DIR%\%OUTPUT_DIR%\11.5"
mkdir "%BUILD_DIR%\%OUTPUT_DIR%\lua"

:: Build game.love by zipping the project source.
if exist "%BUILD_DIR%\%LOVE_FILE%" del /q "%BUILD_DIR%\%LOVE_FILE%"
echo Packaging project into %LOVE_FILE%...
cd /d "%PROJECT_ROOT%"
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$src = @('main.lua','conf.lua','src','sprites','fonts','sounds','maps','libraries') | Where-Object { Test-Path $_ };" ^
    "if (-not $src) { Write-Error 'No source files found to package'; exit 1 };" ^
    "$tmp = Join-Path '%BUILD_DIR%' 'game.zip';" ^
    "if (Test-Path $tmp) { Remove-Item $tmp -Force };" ^
    "Compress-Archive -Path $src -DestinationPath $tmp -Force;" ^
    "Move-Item -Force $tmp (Join-Path '%BUILD_DIR%' '%LOVE_FILE%')"
if errorlevel 1 (
    echo ERROR: Failed to package %LOVE_FILE%.
    exit /b 1
)

:: Copy game.love to output.
copy /y "%BUILD_DIR%\%LOVE_FILE%" "%BUILD_DIR%\%OUTPUT_DIR%\%LOVE_FILE%" >nul

:: Copy love.js player files.
echo Copying love.js player files...
copy /y "%LOVEJS_DIR%\player.js"  "%BUILD_DIR%\%OUTPUT_DIR%\player.js"  >nul
copy /y "%LOVEJS_DIR%\style.css"  "%BUILD_DIR%\%OUTPUT_DIR%\style.css"  >nul
if exist "%LOVEJS_DIR%\nogame.love" (
    copy /y "%LOVEJS_DIR%\nogame.love" "%BUILD_DIR%\%OUTPUT_DIR%\nogame.love" >nul
)

:: Copy all files in 11.5/ (love.js WASM bundle + licence).
for %%f in ("%LOVEJS_DIR%\11.5\*") do (
    copy /y "%%f" "%BUILD_DIR%\%OUTPUT_DIR%\11.5\" >nul
)

:: Copy Lua shims (normalize1.lua exposes love.js.savesync() among other things).
copy /y "%LOVEJS_DIR%\lua\normalize1.lua" "%BUILD_DIR%\%OUTPUT_DIR%\lua\normalize1.lua" >nul
copy /y "%LOVEJS_DIR%\lua\normalize2.lua" "%BUILD_DIR%\%OUTPUT_DIR%\lua\normalize2.lua" >nul

:: Generate index.html from template (substitutes __TITLE__ and __BASE_TAG__).
cd /d "%BUILD_DIR%"
echo Generating index.html...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$tpl = Get-Content -Raw 'index.template.html';" ^
    "$base = '%BASE_HREF%';" ^
    "$q = [char]34; $baseTag = if ($base) { '<base href=' + $q + $base + $q + '>' } else { '' };" ^
    "$tpl = $tpl.Replace('__TITLE__', '%PROJECT_NAME%').Replace('__BASE_TAG__', $baseTag);" ^
    "Set-Content -NoNewline -Encoding UTF8 -Path '%OUTPUT_DIR%\index.html' -Value $tpl"
if errorlevel 1 (
    echo ERROR: Failed to generate index.html.
    exit /b 1
)

:: Copy staticwebapp.config.json into the output ONLY for local builds
:: (no BASE_HREF). The COOP/COEP headers in that file are required for the
:: love.js WASM runtime to boot (SharedArrayBuffer). Locally, `python -m
:: http.server` does not serve those headers, but having the config present
:: lets tools like `swa start` apply them.
::
:: For deploy builds (BASE_HREF set, e.g. /games/legend-of-lua/) we deliberately
:: skip this: the challacade homepage repo owns the root SWA config, and
:: shipping a per-game config inside games/<name>/ causes Azure to apply an
:: unintended secondary config.
if "%BASE_HREF%"=="" (
    if exist "%BUILD_DIR%\staticwebapp.config.json" (
        echo Copying staticwebapp.config.json into output...
        copy /y "%BUILD_DIR%\staticwebapp.config.json" "%BUILD_DIR%\%OUTPUT_DIR%\staticwebapp.config.json" >nul
    )
)

echo.
echo ========================================
echo Build complete: %BUILD_DIR%\%OUTPUT_DIR%\
echo Run web-run.bat to test in a browser.
echo ========================================
endlocal
