@echo off & @rem based on XNT.kex script template version 2016-03-05
setlocal enableextensions & prompt @
if not "%~3" == ""     call "%~0" "%*"
if not "%~3" == ""     goto DONE & @rem up to two arguments
if     "%~1" == ""     goto HELP & @rem expect one argument
if     "%~1" == "?"    goto HELP & @rem missing switch char
if     "%~1" == "/?"   goto HELP & @rem minimal requirement
if     "%~1" == "-?"   goto HELP & @rem permit DOS SWITCHAR
:DOIT --------------------------------------------------------------
if not exist "%~1\*"    set LINK=/H
if     exist "%~1\*"    set LINK=/D
set NEED=%~f1
if not exist "%NEED%"  goto NEED
if     "%~2" == ""     goto WHAT
set DEST=%~2
if not exist "%DEST%"  goto GOOD
if     exist "%~2\*"    set DEST=%~dp2%~nx1
if not exist "%DEST%"  goto GOOD
if     exist "%DEST%"  goto DEST
:WHAT --------------------------------------------------------------
pushd "%~dp1."
echo SRC=%NEED%
echo CWD=%CD%
set /P DEST=DST=
for /F "usebackq tokens=*" %%x in ('%DEST%') do set DEST=%%~fx
popd
if     "%DEST%" == ""  goto UTIL
if     exist "%DEST%\*" set DEST=%DEST%\%~nx1
if     exist "%DEST%"  goto DEST
:GOOD --------------------------------------------------------------
echo mklink %LINK% "%DEST%" "%NEED%"
mklink      %LINK% "%DEST%" "%NEED%"
if     errorlevel 1    goto DEST
if "%LINK%" == "/D"    goto WAIT
:UTIL --------------------------------------------------------------
set NEED=fsutil.exe
for %%x in (%NEED%) do if not exist "%%~f$PATH:x" goto NEED
echo/
echo %NEED% hardlink list "%~1"
%NEED% hardlink list "%~1"
echo/
goto WAIT
:DEST --------------------------------------------------------------
echo/
echo Error: %0 cannot create "%DEST%"
goto HELP
:NEED --------------------------------------------------------------
echo/
echo Error: %0 found no "%NEED%"
:HELP --------------------------------------------------------------
echo Usage: %0 FILE [DEST]
echo/
echo Shorthand for "mklink /H", determines a missing DEST
echo interactively, suited for a simple shell:sendto link.
echo DEST can be a directory to keep the name of the FILE
echo as is.
echo/
:WAIT --------------------------------------------------------------
set NEED=usebackq tokens=2 delims=/
for /F "%NEED% " %%c in ('%CMDCMDLINE%') do if /I "%%c" == "c" pause
:DONE -------------- (Frank Ellermann, 2016) -----------------------
