@echo off & @rem based on XNT.kex script template version 2016-03-05
setlocal enableextensions & prompt @
if not "%~3" == ""     call "%~0" "%*"
if not "%~3" == ""     goto DONE & @rem up to two arguments
if     "%~1" == ""     goto HELP & @rem expect one argument
if     "%~1" == "?"    goto HELP & @rem missing switch char
if     "%~1" == "/?"   goto HELP & @rem minimal requirement
if     "%~1" == "-?"   goto HELP & @rem permit DOS SWITCHAR
:DOIT --------------------------------------------------------------
set NEED=windiff.exe
for %%x in (%NEED%) do  set EXEC=%%~f$PATH:x
if not exist "%EXEC%"  goto NEED
set EXEC=start "%~0" /D . "%EXEC%"
set NEED=%~f1
if not exist "%NEED%"  goto NEED
if     "%~2" == ""     goto WHAT
set NEED=%~2
set DEST=%~2
if /I "%~f1" == "%~f2" goto DEST
if not exist "%DEST%"  goto DEST
if     exist "%DEST%"  goto GOOD
:WHAT --------------------------------------------------------------
pushd "%~dp1."
echo SRC=%NEED%
echo CWD=%CD%
set /P DEST=DST=
for /F "usebackq tokens=*" %%x in ('%DEST%') do set DEST=%%~fx
popd
if     exist "%DEST%"  goto GOOD
set NEED=%DEST%
if not "%NEED%" == ""  goto NEED
if     "%NEED%" == ""  goto HELP
:GOOD --------------------------------------------------------------
echo %EXEC% "%~f1" "%DEST%"
%EXEC%      "%~f1" "%DEST%"
if not errorlevel 1    goto DONE
goto WAIT
:DEST --------------------------------------------------------------
echo/
echo Error: %0 cannot create "%DEST%"
goto HELP
:NEED --------------------------------------------------------------
echo/
echo Error: %0 found no "%NEED%"
:HELP --------------------------------------------------------------
echo Usage: %0 PATH1 [PATH2]
echo/
echo Shorthand for windiff.exe PATH1 PATH2.  If both paths are given
echo and exist the script starts WINDIFF.exe
echo/
:WAIT if first CMD line option was /c ------------------------------
set NEED=usebackq tokens=2 delims=/
for /F "%NEED% " %%c in ('%CMDCMDLINE%') do if /I "%%c" == "c" pause
:DONE -------------- (Frank Ellermann, 2016) -----------------------
