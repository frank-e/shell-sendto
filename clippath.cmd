@echo off & @rem based on XNT.kex script template version 2016-03-05
setlocal enableextensions & prompt @
if not "%~2" == ""     call "%~0" "%*"
if not "%~2" == ""     goto DONE & @rem expect one argument
if     "%~1" == ""     goto HELP & @rem expect one argument
if     "%~1" == "?"    goto HELP & @rem missing switch char
if     "%~1" == "/?"   goto HELP & @rem minimal requirement
if     "%~1" == "-?"   goto HELP & @rem permit DOS SWITCHAR
:DOIT --------------------------------------------------------------
set NEED=clip.exe
for %%x in (%NEED%) do if not exist "%%~f$PATH:x" goto NEED
set NEED=%~1
if not exist "%NEED%"  goto NEED
echo echo %~f1^|clip.exe
call echo %~f1|clip.exe
if     errorlevel 1    echo Error: %0 got exit code [%ErrorLevel%]
if     errorlevel 1    goto WAIT
if not errorlevel 1    goto DONE
:NEED --------------------------------------------------------------
echo/
echo Error: %0 found no "%NEED%"
:HELP --------------------------------------------------------------
echo Usage: %0 PATH
echo/
echo Puts the full path of the given existing PATH into the
echo clipboard with the first found CLIP.EXE, for use in a
echo shell:sendto link.
echo/
:WAIT if first CMD line option was /c ------------------------------
set NEED=usebackq tokens=2 delims=/
for /F "%NEED% " %%c in ('%CMDCMDLINE%') do if /I "%%c" == "c" pause
:DONE -------------- (Frank Ellermann, 2016) -----------------------
