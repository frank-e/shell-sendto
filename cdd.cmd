@echo off & @rem based on XNT.kex script template version 2016-03-05
setlocal enableextensions & prompt @
if not "%~2" == ""     call "%~0" "%*"
if not "%~2" == ""     goto DONE & @rem expect one argument
if     "%~1" == ""     goto TEMP & @rem expect one argument
if     "%~1" == "?"    goto HELP & @rem missing switch char
if     "%~1" == "/?"   goto HELP & @rem minimal requirement
if     "%~1" == "-?"   goto HELP & @rem permit DOS SWITCHAR
:DOIT --------------------------------------------------------------
set NEED=%~f1
if not exist "%NEED%"  goto NEED
if     exist "%~f1\*"  cd /D "%~f1\."
if     exist "%~f1\*"  goto OKAY & @rem valid directory
if     exist "%~f1\.." cd /D "%~f1\.."
if     exist "%~f1\.." goto OKAY & @rem valid parent
goto NEED
:TEMP --------------------------------------------------------------
if /I "%CD%" == "%SystemRoot%\System32" cd /D "%TEMP%"
:OKAY --------------------------------------------------------------
endlocal & cd /D "%CD%"
goto DONE
:NEED --------------------------------------------------------------
echo/
echo Error: %0 found no "%NEED%"
:HELP --------------------------------------------------------------
echo Usage: %0 FILE
echo/
echo Switches the current directory to the path of the specified
echo existing FILE or directory.  Wildcards (* or ?) are allowed.
echo/
echo Maybe create a shell::sendto shortcut (link) for
echo %%COMSPEC%% /k %~dpnx0
echo/
:WAIT if first CMD line option was /c ------------------------------
set NEED=usebackq tokens=2 delims=/
for /F "%NEED% " %%c in ('%CMDCMDLINE%') do if /I "%%c" == "c" pause
:DONE -------------- (Frank Ellermann, 2016) -----------------------
