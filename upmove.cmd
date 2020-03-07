@echo off & @rem based on XNT.kex script template version 2016-03-05
setlocal enableextensions & prompt @
if     exist "%~2"     goto MANY & @rem shell::sendto split
if not "%~2" == ""     call "%~0" "%*"
if not "%~2" == ""     goto DONE & @rem expect one argument
if     "%~1" == ""     goto HELP & @rem expect one argument
if     "%~1" == "?"    goto HELP & @rem missing switch char
if     "%~1" == "/?"   goto HELP & @rem minimal requirement
if     "%~1" == "-?"   goto HELP & @rem permit DOS SWITCHAR
:DOIT --------------------------------------------------------------
set THIS=%0
set FULL=%~f1
set NAME=%~nx1
set NEED=%FULL%
if not exist "%NEED%"  goto NEED
set NEED=%~dp1..
for %%x in ("%FULL%\..\..") do set DEST=%%~fx
if "%~dp1" == "%DEST%" goto NEED
for %%x in ("%FULL%\..")    do set NEED=%%~nxx
if "%~nx1" == "%NEED%" goto DEST
call :EXEC move /-Y "%FULL%" "%DEST%"
if     errorlevel 1    goto WAIT
goto DONE
:DEST --------------------------------------------------------------
dir /A/B "%~dp1"|find /V /C ""|find "1">nul
if not errorlevel 1    goto WORK
echo Error: %0 found more than one "%NAME%\*" object
goto WAIT
:WORK --------------------------------------------------------------
call :EXEC cd /D "%DEST%"
if     errorlevel 1    goto WAIT
call :EXEC move /-Y "%NAME%" "%NAME%.tmp"
if     errorlevel 1    goto WAIT
call :EXEC move /-Y "%NAME%.tmp\%NAME%" "%DEST%"
if     errorlevel 1    goto UNDO
call :EXEC rd "%NAME%.tmp"
if     errorlevel 1    goto WAIT
goto DONE
:UNDO --------------------------------------------------------------
call :EXEC move /-Y "%NAME%.tmp" "%NAME%"
goto WAIT
:EXEC --------------------------------------------------------------
echo %*
%*>nul
if not errorlevel 1    goto DONE
echo Error: %THIS% got non-zero exit code %ERRORLEVEL%
goto DONE
:MANY --------------------------------------------------------------
call "%~0" "%~1"
shift /1
if not "%~1" == ""     goto MANY
goto DONE
:NEED --------------------------------------------------------------
echo/
echo Error: %0 found no "%NEED%"
:HELP --------------------------------------------------------------
echo Usage: %0 FILE
echo/
echo Moves a FILE or directory to its grandparent ..\..
echo and can handle D:\PATH\TARGET\SOURCE\SOURCE cases
echo with a temporary D:\PATH\TARGET\SOURCE.tmp folder.
echo The script can be used in a shell::SendTo shortcut.
echo/
:WAIT if first CMD line option was /c ------------------------------
set NEED=usebackq tokens=2 delims=/
for /F "%NEED% " %%c in ('%CMDCMDLINE%') do if /I "%%c" == "c" pause
:DONE -------------- (Frank Ellermann, 2016) -----------------------
