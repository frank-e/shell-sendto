@echo off & @rem based on XNT.kex script template version 2016-03-05
setlocal enableextensions & prompt @
if not "%~2" == ""     call "%~0" "%*"
if not "%~2" == ""     goto DONE & @rem expect one argument
if     "%~1" == ""     goto HELP & @rem expect one argument
if     "%~1" == "?"    goto HELP & @rem missing switch char
if     "%~1" == "/?"   goto HELP & @rem minimal requirement
if     "%~1" == "-?"   goto HELP & @rem permit DOS SWITCHAR
if     exist "%~1\*"   goto HELP & @rem bypass subdirectory
:DOIT ---------------- find a W2K KILLer ---------------------------
set NEED=%ProgramFiles%\Support Tools
set TOOL=%NEED%
if not exist "%TOOL%"  set  TOOL=%windir%
if not exist "%TOOL%"  set  TOOL=%SystemRoot%
if not exist "%TOOL%"  goto NEED
set NEED=reg.exe
for %%x in (%NEED%) do if exist "%%~f$PATH:x" set NEED=%%~f$PATH:x
if not exist "%NEED%"  set  NEED=%TOOL%\%NEED%
if not exist "%NEED%"  goto NEED
set XREG="%NEED%"
set KILL=!
set NEED=kill.exe
for %%x in (%NEED%) do if exist "%%~f$PATH:x" set NEED=%%~f$PATH:x
if not exist "%NEED%"  set  NEED=%TOOL%\%NEED%
if     exist "%NEED%"  set  KILL="%NEED%"
set NEED=pskill.exe
for %%x in (%NEED%) do if exist "%%~f$PATH:x" set NEED=%%~f$PATH:x
if not exist "%NEED%"  set  NEED=%TOOL%\%NEED%
if     exist "%NEED%"  set  KILL="%NEED%"
set NEED=taskkill.exe
for %%x in (%NEED%) do if exist "%%~f$PATH:x" set NEED=%%~f$PATH:x
if not exist "%NEED%"  set  NEED=%TOOL%\%NEED%
if     exist "%NEED%"  set  KILL="%NEED%" /f /im
if  "%KILL%" == "!"    goto NEED
:OKAY --------------------------------------------------------------
set HKEY=HKCU\Software\Microsoft\Windows\CurrentVersion
set HKEY=%HKEY%\Explorer\Advanced
set SHOW=ShowSuperHidden
for %%x in (-x -X /x /X) do if "%~1" == "%%x" goto SHOW
set HKEY=HKCR\DesktopBackground\Shell\Restart Explorer
set SHOW=
for %%x in (-i -I /i /I) do if "%~1" == "%%x" goto INST
for %%x in (-u -U /u /U) do if "%~1" == "%%x" goto UNST
echo Error: %0 %*
goto HELP
:INST ---------------- install -------------------------------------
set NEED=%TOOL%\%~nx0
if not "%~f0" == "%NEED%" copy /-Y "%~f0" "%NEED%"
if not exist  "%NEED%" goto NEED
echo %0 tries to reset "%HKEY%":
%XREG% add "%HKEY%\command" /ve /f /t REG_SZ /d ""%NEED%" /x"
%XREG% add "%HKEY%" /v Position /f /t REG_SZ /d Top
%XREG% add "%HKEY%" /v Icon     /f /t REG_SZ /d explorer.exe
if     errorlevel 1    goto FAIL
goto WAIT
:UNST ---------------- uninstall -----------------------------------
set NEED=%TOOL%\%~nx0
set KILL=%TEMP%\deleteme.bat
%XREG% query  "%HKEY%" /ve 2>nul
if     errorlevel 1    goto UN.2
%XREG% delete "%HKEY%"
if     errorlevel 1    goto FAIL
:UN.2
if not exist "%NEED%"  goto NEED
echo del /P  "%NEED%" > "%KILL%"
call "%KILL%" & del "%KILL%"
goto WAIT
:SHOW ---------------- switch 0x0 to 0x1 ---------------------------
%XREG% query %HKEY% /v %SHOW% /t REG_DWORD|find "0x0"
if     errorlevel 1    goto HIDE
%XREG% add %HKEY% /v %SHOW% /t REG_DWORD /d 1 /f
if     errorlevel 1    goto FAIL
goto KILL
:HIDE ---------------- switch 0x1 to 0x0 ---------------------------
%XREG% query %HKEY% /v %SHOW% /t REG_DWORD|find "0x1"
if     errorlevel 1    goto FAIL
%XREG% add %HKEY% /v %SHOW% /t REG_DWORD /d 0 /f
if     errorlevel 1    goto FAIL
:KILL ---------------- restart explorer ----------------------------
%KILL% explorer.exe
if     errorlevel 1    goto WAIT
start  explorer.exe
start  explorer.exe /n,
goto DONE
:FAIL ---------------- REG.exe trouble -----------------------------
echo Error: %0 cannot modify REG_DWORD %HKEY%\%SHOW%
goto WAIT
:NEED --------------------------------------------------------------
echo/
echo Error: %0 found no "%NEED%"
:HELP --------------------------------------------------------------
echo Usage: %0 /x^|/u^|/i
echo    %~nx0 /x
echo        toggles ShowSuperHidden in the registry with REG.exe and
echo        restarts the explorer.  This closes (kills) all open
echo        explorer windows before restarting one explorer window.
echo    %~nx0 /i (install)
echo        copies itself to %%windir%% and adds "Restart Explorer"
echo        to the desktop context menu.
echo    %~nx0 /u (uninstall)
echo        deletes "Restart Explorer" in the registry and removes
echo        its %%windir%% copy.
echo/
:WAIT if first CMD line option was /c ------------------------------
set NEED=usebackq tokens=2 delims=/
for /F "%NEED% " %%c in ('%CMDCMDLINE%') do if /I "%%c" == "c" pause
:DONE -------------- (Frank Ellermann, 2016) -----------------------
