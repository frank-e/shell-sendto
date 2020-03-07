@echo off & @rem based on XNT.kex script template version 2016-03-05
setlocal enableextensions & prompt @
if not "%~2" == ""     call "%~0" "%*"
if not "%~2" == ""     goto DONE & @rem expect one argument
if     "%~1" == ""     goto HELP & @rem expect one argument
if     "%~1" == "?"    goto HELP & @rem missing switch char
if     "%~1" == "/?"   goto HELP & @rem minimal requirement
if     "%~1" == "-?"   goto HELP & @rem permit DOS SWITCHAR
:DOIT --------------------------------------------------------------
set NEED=%~1
set FILE=%~1
set DEST=%~n1.zip
set WORK=nul
set OPTS=-tzip -mx=9 -mfb=255 -mmt=off -mpass=15 --
if not exist "%NEED%"  goto NEED
::: PROG=7z.exe or 7za.exe in %ProgramFiles%\7-ZIP or %PATH%
set NEED=7z.exe 7za.exe
set PROG=%ProgramFiles%\7-ZIP;%PATH%
for %%x in (%NEED%) do if exist "%%~f$PROG:x" set PROG=%%~f$PROG:x
if not exist "%PROG%"  goto NEED
if     exist "%~1\*"   goto PDIR
"%PROG%" t -- "%FILE%">nul
if     errorlevel 1    goto FAIL
if not "%TEMP%" == ""  set TMP=%TEMP%
if not exist "%TMP%\*" set TMP=.
set DEST=%TMP%\%~n1
set WORK=%DEST%
if exist "%DEST%\*"    rmdir /S "%DEST%"
if exist "%DEST%\*"    goto DEST
if exist "%DEST%"      erase /P "%DEST%"
if exist "%DEST%"      goto DEST
set DEST=%~n1.bak
if exist "%DEST%\*"    rmdir /S "%DEST%"
if exist "%DEST%\*"    goto DEST
if exist "%DEST%"      erase /P "%DEST%"
if exist "%DEST%"      goto DEST
set DEST=%~n1.zip
"%PROG%" x -o"%WORK%" -- "%~1"
if     errorlevel 1    goto FAIL
set NEED=%WORK%
dir /B "%WORK%"|find /I /V "%~n1">nul
if not errorlevel 1    goto PACK & @rem not only %~n1 stuff
dir /B "%WORK%"|find /I /C "%~n1"|find "1">nul
if     errorlevel 1    goto PACK & @rem not exactly 1 thing
set NEED=%WORK%\%~n1
if    exist "%NEED%\*" goto PACK & @rem only 1 subdirectory
set NEED=%WORK%\%~n1.tar
if not exist "%NEED%"  goto PACK & @rem this is no %~n1.tar
set NEED=%WORK%\%~n1
"%PROG%" x -o"%NEED%" -- "%NEED%.tar"
if     errorlevel 1    goto FAIL
:PACK --------------------------------------------------------------
if not exist "%NEED%"  set NEED=%WORK%
if     exist "%DEST%"  set FILE=%~dpn1.bak
if     exist "%DEST%"  ren "%DEST%" "%~n1.bak"
if     exist "%DEST%"  goto FAIL
"%PROG%" a %OPTS% "%DEST%" "%NEED%"
if     errorlevel 1    goto FAIL
echo Ready: %0 created "%DEST%"
for %%x in ("%FILE%") do echo %%~tznxx
for %%x in ("%DEST%") do echo %%~tznxx
del /P "%FILE%"
rmdir /S /Q "%WORK%"
goto DONE
:PDIR --------------------------------------------------------------
if     exist "%DEST%"  goto DEST
"%PROG%" a %OPTS% "%DEST%" "%~1"
if     errorlevel 1    goto FAIL
echo Ready: %0 created "%DEST%"
for %%x in ("%DEST%") do echo %%~tznxx
goto WAIT
:FAIL --------------------------------------------------------------
echo/
if     errorlevel 1    echo Error: %0 got exit code [%ERRORLEVEL%]
if exist "%WORK%\*"    rmdir /S /Q "%WORK%"
goto WAIT
:DEST --------------------------------------------------------------
echo/
echo Error: %0 cannot create "%DEST%"
goto WAIT
:NEED --------------------------------------------------------------
echo/
echo Error: %0 found no "%NEED%"
:HELP --------------------------------------------------------------
echo Usage: %0 NAME.EXT
echo/
echo 1: Use 7z.exe or 7za.exe in %%ProgramFiles%%\7-ZIP or %%PATH%%.
echo 2: If NAME.EXT is a directory pack it into NAME.zip and exit.
echo    Otherwise test it with 7-ZIP and exit on error.
echo 3: Get rid of any old %%TEMP%%\NAME (and NAME.bak for step 6).
echo 4: Extract NAME.EXT into %%TEMP%%\NAME.
echo 5: If only %%TEMP%%\NAME\NAME exists goto 6 using NAME\NAME.
echo    If only %%TEMP%%\NAME\NAME.tar exists extract it into
echo    %%TEMP%%\NAME\NAME and goto 6 using NAME\NAME.
echo 6: If target .\NAME.zip is the same as source NAME.EXT rename
echo    the source to NAME.bak.  Undo on error not yet implemented.
echo 7: Pack %%TEMP%%\NAME (or NAME\NAME) in .\NAME.zip and remove
echo    %%TEMP%%\NAME.  Offer to delete NAME.EXT (or bak), and exit.
echo/
:WAIT if first CMD line option was /c ------------------------------
set NEED=usebackq tokens=2 delims=/
for /F "%NEED% " %%c in ('%CMDCMDLINE%') do if /I "%%c" == "c" pause
:DONE -------------- (Frank Ellermann, 2016) -----------------------
