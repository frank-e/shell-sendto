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
set NEED=TruePNG.exe
for %%x in (%NEED%) do   if not exist "%%~f$PATH:x" goto NEED
set NEED=PNGwolf.exe
for %%x in (%NEED%) do   if not exist "%%~f$PATH:x" goto NEED
set NEED=%~1
if not exist "%NEED%"    goto NEED
set DEST=%HOMEDRIVE%
if not exist "%DEST%\*"  set  DEST=%SYSTEMDRIVE%
if not exist "%DEST%\*"  set  DEST=C:
set NEED=%DEST%\TEMP
set DEST=%NEED%
if not exist "%DEST%\*"  set  DEST=%TEMP%
if not exist "%DEST%\*"  set  DEST=%TMP%
if not exist "%DEST%\*"  goto NEED
rem TruePNG /o4 (max) is not lossless, /o3 /na should be lossless
set TINY=tiny
set NEED=%DEST%\deleteme.png
set DEST=%~dp1%TINY%.png
set EXEC=/o3 /na
if     exist "%DEST%"    del /P "%DEST%"
if     exist "%DEST%"    goto DEST
if /I "%TINY%" == "tiny" set EXEC=/o4 /a0 /md keep all
set EXEC=TruePNG.exe %EXEC% /y /out "%NEED%" "%~1"
echo %EXEC%
%EXEC%
if not errorlevel 1      goto WOLF
echo Error: %0 got exit code [%ERRORLEVEL%]
echo Retry: %0 TruePNG failed, trying PNGwolf now...
copy "%~1" "%NEED%"
if     errorlevel 1      goto DEST
:WOLF --------------------------------------------------------------
rem PNGwolf --normalize-alpha is like TruePNG /a0 (implied by /o3)
set EXEC=PNGwolf.exe --verbose-genomes
if /I "%TINY%" == "tiny" set EXEC=%EXEC% --normalize-alpha
if not exist "%NEED%"    goto NEED
set EXEC=%EXEC% --max-stagnate-time=11 --in="%NEED%" --out="%DEST%"
echo %EXEC%
%EXEC%
if     errorlevel 1      echo Error: %0 got exit code [%ErrorLevel%]
if     errorlevel 1      goto WAIT
echo orig: %~z1 bytes
for %%x in ("%NEED%") do echo %TINY%: %%~zx bytes
for %%x in ("%DEST%") do echo wolf: %%~zx bytes
del "%NEED%"
goto WAIT
:DEST --------------------------------------------------------------
echo/
echo Error: %0 cannot create "%DEST%"
goto WAIT
:NEED --------------------------------------------------------------
echo/
echo Error: %0 found no "%NEED%"
:HELP --------------------------------------------------------------
echo Usage: %0 PNG
echo/
echo Compresses a given PNG with TruePNG.exe followed
echo by PNGwolf.exe if found; suited for shell:sendto
echo/
:WAIT if first CMD line option was /c ------------------------------
set NEED=usebackq tokens=2 delims=/
for /F "%NEED% " %%c in ('%CMDCMDLINE%') do if /I "%%c" == "c" pause
:DONE -------------- (Frank Ellermann, 2016) -----------------------
