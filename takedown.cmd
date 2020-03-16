@echo off & @rem based on XNT.kex script template version 2020-03-16
setlocal enableextensions & prompt @
if not "%~2" == ""     call "%~0" "%*"
if not "%~2" == ""     goto DONE & @rem expect one argument
if     "%~1" == ""     goto HELP & @rem expect one argument
if     "%~1" == "?"    goto HELP & @rem missing switch char
if     "%~1" == "/?"   goto HELP & @rem minimal requirement
if     "%~1" == "-?"   goto HELP & @rem permit DOS SWITCHAR
:DOIT --------------------------------------------------------------
set NEED=takeown.exe
for %%x in (%NEED%) do if not exist "%%~f$PATH:x" goto NEED
set NEED=%~f1
if not exist "%NEED%"  goto NEED
if     exist "%~1\*"    set NEED=/R /A /F
if not exist "%~1\*"    set NEED=   /A /F
echo takeown.exe %NEED% "%~f1" 1>&2
@takeown.exe %NEED% "%~f1"
if     errorlevel 1    echo Error: %0 got exit code [%ERRORLEVEL%]
goto WAIT
:NEED --------------------------------------------------------------
echo/
echo Error: %0 found no "%NEED%"
:HELP --------------------------------------------------------------
echo Usage: %0 FILE
echo/
echo This admin shorthand for TAKEOWN.exe /R /A /F FILE can handle
echo/
echo Maybe create a shell::sendto shortcut (link) for
echo %%COMSPEC%% /k %~dpnx0
echo/
:WAIT if first CMD line option was /c ------------------------------
set NEED=usebackq tokens=2 delims=/
for /F "%NEED% " %%c in ('%CMDCMDLINE%') do if /I "%%c" == "c" pause
:DONE -------------- (Frank Ellermann, 2020) -----------------------
