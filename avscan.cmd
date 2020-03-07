@echo off & @rem based on XNT.kex script template version 2016-03-05
setlocal enableextensions & prompt @
set PROG=Microsoft Security Client\MpCmdRun.exe
set OPTS=-Scan -ScanType 3 -DisableRemediation -File
if not "%~2" == ""     call "%~0" "%*"
if not "%~2" == ""     goto DONE & @rem expect one argument
if     "%~1" == ""     goto HELP & @rem expect one argument
if     "%~1" == "?"    goto HELP & @rem missing switch char
if     "%~1" == "/?"   goto HELP & @rem minimal requirement
if     "%~1" == "-?"   goto HELP & @rem permit DOS SWITCHAR
:DOIT --------------------------------------------------------------
set SCAN=%ProgramW6432%\%PROG%
set NEED=%SCAN%
if not exist "%NEED%"  goto NEED
set NEED=%~1
if not exist "%NEED%"  goto NEED
"%SCAN%" %OPTS% "%~f1"
echo exit code [%ERRORLEVEL%]
goto WAIT
:NEED --------------------------------------------------------------
echo/
echo Error: %0 found no "%NEED%"
:HELP --------------------------------------------------------------
echo Usage: %0 FILE
echo/
echo  runs "%PROG%" with
echo  options %OPTS%
echo  for the given FILE (or directory, incl. archives.)
echo/
echo  If an application allows to configure an anti virus
echo  scanner try %~f0
echo/
md . 2>nul & @rem non-zero errorlevel for security script
:WAIT if first CMD line option was /c ------------------------------
set NEED=usebackq tokens=2 delims=/
for /F "%NEED% " %%c in ('%CMDCMDLINE%') do if /I "%%c" == "c" pause
:DONE -------------- (Frank Ellermann, 2016) -----------------------
