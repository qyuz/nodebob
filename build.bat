@echo off

set CUR_DIR="%CD%"
set EXE_PATH=%CUR_DIR%\release\nw.exe
set ICO_PATH=%CUR_DIR%\app\app.ico
set NWEXE_PATH=%CUR_DIR%\buildTools\nw\nw.exe
set NWZIP_PATH=%CUR_DIR%\release\app.nw

SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)

call :ColorText 0C "nodebob v0.1"
echo.
call :ColorText 0C "---"
echo.
echo.

if not exist release md release

echo.
call :ColorText 0a "Creating app package..."
cd buildTools\7z
7z a -r -tzip %NWZIP_PATH% ..\..\app\*
cd ..\..

echo.
call :ColorText 0a "Creating executable..."
echo.
copy /b /y %NWEXE_PATH% %EXE_PATH%
cd buildTools\ar
if exist %ICO_PATH% Resourcer -op:upd -src:%EXE_PATH% -type:14 -name:IDR_MAINFRAME -file:%ICO_PATH%
copy /b /y %EXE_PATH% + %NWZIP_PATH% %EXE_PATH%
cd ..\..

echo.
call :ColorText 0a "Copying files..."
echo.
if not exist %CUR_DIR%\release\locales\ xcopy %CUR_DIR%\buildTools\nw\locales %CUR_DIR%\release\locales\
if not exist %CUR_DIR%\release\ffmpeg.dll copy %CUR_DIR%\buildTools\nw\ffmpeg.dll %CUR_DIR%\release\ffmpeg.dll
if not exist %CUR_DIR%\release\icudtl.dat copy %CUR_DIR%\buildTools\nw\icudtl.dat %CUR_DIR%\release\icudtl.dat
if not exist %CUR_DIR%\release\libEGL.dll copy %CUR_DIR%\buildTools\nw\libEGL.dll %CUR_DIR%\release\libEGL.dll
if not exist %CUR_DIR%\release\libGLESv2.dll copy %CUR_DIR%\buildTools\nw\libGLESv2.dll %CUR_DIR%\release\libGLESv2.dll
if not exist %CUR_DIR%\release\natives_blob.bin copy %CUR_DIR%\buildTools\nw\natives_blob.bin %CUR_DIR%\release\natives_blob.bin
if not exist %CUR_DIR%\release\node.dll copy %CUR_DIR%\buildTools\nw\node.dll %CUR_DIR%\release\node.dll
if not exist %CUR_DIR%\release\nw.dll copy %CUR_DIR%\buildTools\nw\nw.dll %CUR_DIR%\release\nw.dll
if not exist %CUR_DIR%\release\nw_100_percent.pak copy %CUR_DIR%\buildTools\nw\nw_100_percent.pak %CUR_DIR%\release\nw_100_percent.pak
if not exist %CUR_DIR%\release\nw_200_percent.pak copy %CUR_DIR%\buildTools\nw\nw_200_percent.pak %CUR_DIR%\release\nw_200_percent.pak
if not exist %CUR_DIR%\release\nw_elf.dll copy %CUR_DIR%\buildTools\nw\nw_elf.dll %CUR_DIR%\release\nw_elf.dll
if not exist %CUR_DIR%\release\resources.pak copy %CUR_DIR%\buildTools\nw\resources.pak %CUR_DIR%\release\resources.pak

echo.
call :ColorText 0a "Deleting temporary files..."
echo.
del %NWZIP_PATH%

echo.
call :ColorText 0a "Done!"
echo.
goto :eof


:ColorText
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1
goto :eof