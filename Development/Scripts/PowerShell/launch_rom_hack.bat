@echo off
REM ROM Hack Quick Launch Script for Windows
REM Launches ROM hacks with the appropriate emulator

setlocal
set DEVELOPMENT_ROOT=G:\Development
set MGBA_PATH=%DEVELOPMENT_ROOT%\Tools\mGBA\mGBA-0.10.3-win64\mGBA.exe
set BIZHAWK_PATH=%DEVELOPMENT_ROOT%\Tools\BizHawk\EmuHawk.exe
set ROM_HACK_DIR=%DEVELOPMENT_ROOT%\Games\Pokemon_References\ROM_Hacks

echo ================================
echo    ROM Hack Quick Launcher
echo ================================

if not exist "%MGBA_PATH%" (
    echo ERROR: mGBA not found at %MGBA_PATH%
    pause
    exit /b 1
)

if not exist "%BIZHAWK_PATH%" (
    echo ERROR: BizHawk not found at %BIZHAWK_PATH%
    pause
    exit /b 1
)

echo Available ROM hacks:
echo.

REM List available ROM files
set /a count=0
for %%f in ("%ROM_HACK_DIR%\Completed_Hacks\*.gba" "%ROM_HACK_DIR%\Completed_Hacks\*.gbc" "%ROM_HACK_DIR%\Completed_Hacks\*.gb") do (
    set /a count+=1
    echo [!count!] %%~nxf
    set "rom!count!=%%f"
)

if %count%==0 (
    echo No ROM files found in %ROM_HACK_DIR%\Completed_Hacks\
    echo.
    echo Please add some ROM hack files to test!
    pause
    exit /b 0
)

echo.
set /p choice="Select ROM number (1-%count%) or press Enter to exit: "

if "%choice%"=="" exit /b 0

REM Validate choice
if %choice% LSS 1 goto invalid
if %choice% GTR %count% goto invalid

REM Get selected ROM
call set selected_rom=%%rom%choice%%%
echo.
echo Selected: %selected_rom%

REM Determine emulator based on file extension
for %%i in ("%selected_rom%") do set ext=%%~xi

echo Launching with appropriate emulator...
if /i "%ext%"==".gba" (
    echo Using mGBA for GBA ROM...
    start "" "%MGBA_PATH%" "%selected_rom%"
) else if /i "%ext%"==".gbc" (
    echo Using mGBA for GBC ROM...
    start "" "%MGBA_PATH%" "%selected_rom%"
) else if /i "%ext%"==".gb" (
    echo Using mGBA for GB ROM...
    start "" "%MGBA_PATH%" "%selected_rom%"
) else (
    echo Using BizHawk for other ROM types...
    start "" "%BIZHAWK_PATH%" "%selected_rom%"
)

echo ROM launched successfully!
pause
exit /b 0

:invalid
echo Invalid selection! Please choose a number between 1 and %count%.
pause
exit /b 1
