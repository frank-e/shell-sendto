@echo off & @rem based on XNT.kex script template version 2016-03-05
setlocal enableextensions & prompt @
set WIND=%windir%\system32
set NEED=%WIND%\ImDisk.exe
if not exist "%NEED%"  goto NEED & @rem check prerequisites
set NEED=%WIND%\ImDisk.cpl
if not exist "%NEED%"  goto NEED & @rem check prerequisites
if     "%~1" == ".."   goto GUI2 & @rem permit 2nd argument
if not "%~2" == ""     call "%~f0" "%*"
if not "%~2" == ""     goto DONE & @rem expect one argument
if     "%~1" == ""     goto HELP & @rem expect one argument
if     "%~1" == "?"    goto HELP & @rem missing switch char
if     "%~1" == "/?"   goto HELP & @rem minimal requirement
if     "%~1" == "-?"   goto HELP & @rem permit DOS SWITCHAR
if     exist "%~1"     goto DOIT & @rem skip -s option test
for %%x in (-s -S /s /S) do if "%~1" == "%%x" goto SENDTO
:DOIT --------------------------------------------------------------
for %%x in (a b c d e f g h i j) do if "%%x:" == "%~1" goto EJECT
for %%x in (A B C D E F G H I J) do if "%%x:" == "%~1" goto FORCE
for %%x in (k l m n o p q r s t) do if "%%x:" == "%~1" goto EJECT
for %%x in (K L M N O P Q R S T) do if "%%x:" == "%~1" goto FORCE
for %%x in (u v w x y z)         do if "%%x:" == "%~1" goto EJECT
for %%x in (U V W X Y Z)         do if "%%x:" == "%~1" goto FORCE
for %%x in (0 1 2 3 4 5 6 7 8 9) do if "%%x"  == "%~1" goto UNIT
if     "%~1" == "*"    goto LIST
if     "%~1" == "."    goto GUI1
set NEED=%~1
if     exist "%~1\*"   goto HELP & @rem bypass subdirectory
if not exist "%~1"     goto NEED
goto MOUNT
:UNIT ----------- list unit details --------------------------------
imdisk.exe -l -u %1
goto WAIT
:LIST ----------- list known units ---------------------------------
imdisk.exe -l
goto WAIT
:MOUNT ---------- attach existing file -----------------------------
imdisk.exe -a -f "%~f1" -m #:
goto WAIT
:EJECT ---------- detach mounted M: --------------------------------
imdisk.exe -d -m %1
goto WAIT
:FORCE ---------- forced unmount M: --------------------------------
imdisk.exe -D -m %1
goto WAIT
:GUI1 ----------- start control panel ------------------------------
control.exe ImDisk.cpl
if not errorlevel 2    goto DONE
goto WAIT
:GUI2 ----------- start MountFile GUI ------------------------------
set NEED=%*
rundll32.exe ImDisk.cpl,RunDLL_MountFile %NEED:..=%
goto WAIT
:SENDTO ------------------------------------------------------------
set NEED=%TEMP%\~n0.err
echo TITLE = "Mount with ImDisk"             > "%NEED%"
echo WHERE = "WScript.Shell"                 >>"%NEED%"
echo set W = WScript.CreateObject( WHERE )   >>"%NEED%"
echo WHERE = W.SpecialFolders( "SendTo" )    >>"%NEED%"
echo WHERE = WHERE ^& "\" ^& TITLE ^& ".lnk" >>"%NEED%"
echo set L = W.CreateShortcut( WHERE )       >>"%NEED%"
echo L.TargetPath       = "%~nx0"            >>"%NEED%"
echo L.Arguments        = ".."               >>"%NEED%"
echo L.WindowStyle      = 7                  >>"%NEED%"
echo L.IconLocation     = "%WIND%\ImDisk.cpl">>"%NEED%"
echo L.Description      = TITLE              >>"%NEED%"
echo L.WorkingDirectory = "%~dp0"            >>"%NEED%"
echo L.Save                                  >>"%NEED%"
echo WScript.Echo WHERE                      >>"%NEED%"
cscript //nologo //E:vbs "%NEED%"
if     errorlevel 1    echo Error: debug VBS "%NEED%" [%ERRORLEVEL%]
if     errorlevel 1    goto WAIT
del "%NEED%"
echo/
echo Shortcut created or updated, please test it.
goto DONE
:NEED --------------------------------------------------------------
echo/
echo Error: %0 found no "%NEED%"
:HELP --------------------------------------------------------------
echo Usage: %0 image^|x:^|X:^|*^|#^|.^|..^|/s^|/h^|/?
echo    %~nx0 image
echo        Shorthand for `ImDisk -a -f image -m #:` to attach an image
echo        file (IMA, VFD, ISO, etc.) with the next free volume letter.
echo    %~nx0 x:    (volume letter a..z or A..Z plus colon)
echo        Shorthand for `ImDisk -d -m x:` to detach ImDisk volume x:.
echo        Shorthand for `ImDisk -D -m X:` to detach locked volume X:.
echo    %~nx0 *
echo        Shorthand for `ImDisk -l` to list all ImDisk unit numbers.
echo    %~nx0 #     (unit number 0..9)
echo        Shorthand for `ImDisk -l -u #` to list ImDisk unit details.
echo    %~nx0 .     (dot, use two dots for RunDLL_MountFile)
echo        Shorthand for `control ImDisk.cpl`; open control panel GUI.
echo    %~nx0 /s    (ditto -s, -S, /S)
echo        Create a "Mount with ImDisk" shortcut in shell:sendto, and
echo        disable the ImDisk registration for all file extensions.
echo/
:WAIT if first CMD line option was /c ------------------------------
set NEED=usebackq tokens=2 delims=/
for /F "%NEED% " %%c in ('%CMDCMDLINE%') do if /I "%%c" == "c" pause
:DONE -------------- (Frank Ellermann, 2016) -----------------------
