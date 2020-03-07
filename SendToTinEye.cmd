@echo off & @rem based on XNT.kex script template version 2016-03-05
setlocal enableextensions & prompt @
if not "%~2" == ""     call "%~0" "%*"
if not "%~2" == ""     goto DONE & @rem expect one argument
if     "%~1" == ""     goto HELP & @rem expect one argument
if     "%~1" == "?"    goto HELP & @rem missing switch char
if     "%~1" == "/?"   goto HELP & @rem minimal requirement
if     "%~1" == "-?"   goto HELP & @rem permit DOS SWITCHAR
if     exist "%~1\*"   goto HELP & @rem bypass subdirectory
:DOIT --------------------------------------------------------------
set NEED=%~1
if not exist "%NEED%"  goto NEED
set NEED=sha1sum.exe
for %%x in ("%NEED%") do if not exist "%%~f$PATH:x" goto NEED
set HASH=%NEED% "%~1"
set NEED=win32
rem delims=\ to get rid of odd leading backslash in sha256sum output
for /F "tokens=1 usebackq delims=\ " %%x in (`%HASH%`) do set NEED=%%x
if "%NEED%" == "win32" goto FAIL
set NEED=https://tineye.com/search/%NEED%
echo start %NEED%
start %NEED%
if     errorlevel 1    goto NEED
set NEED=timeout.exe
for %%x in ("%NEED%") do if not exist "%%~f$PATH:x" goto WAIT
%NEED% /T 10
goto DONE
:FAIL --------------------------------------------------------------
rem 32bit sha256sum cannot "see" all system32 files on 64bit windows
echo %HASH%
%HASH%
echo Error: %0 got non-zero exit code [%ERRORLEVEL%]
goto WAIT
:NEED --------------------------------------------------------------
echo/
echo Error: %0 found no "%NEED%"
:HELP --------------------------------------------------------------
echo Usage: %0 FILE
echo/
echo Requires sha1sum.exe in the path to open
echo https://tineye.com/search/hash-of-FILE
echo Maybe create a shell:sendto shortcut to %~nx0.
echo/
:WAIT if first CMD line option was /c ------------------------------
set NEED=usebackq tokens=2 delims=/
for /F "%NEED% " %%c in ('%CMDCMDLINE%') do if /I "%%c" == "c" pause
:DONE -------------- (Frank Ellermann, 2016) -----------------------
