@echo off
doskey alias=doskey /m $*
doskey where=where /T $*
doskey 8888=ping -t 8.8.8.8
doskey cool=taskkill /f /im chrome.exe$Tresmon.exe
doskey wifi=netsh int set int WiFi DISABLED$tnetsh int set int WiFi ENABLED
doskey tops=resmon.exe $*
doskey posh=PowerShell.exe $*
doskey tatort=youtube-dl -f http-2 $*
doskey ffmpeg=ansicon -m ffmpeg.exe -hide_banner $*
doskey ffprobe=ansicon -m ffprobe.exe -hide_banner $*
doskey paste=for /F "tokens=*" %%T in ('powershell Get-Clipboard') do @echo %%T
doskey wmk=for %%D in (%%CD%%) do wmake -h -f %%~nD.wmk $*
doskey 7za=@"%ProgramW6432%\7-ZIP\7za.exe" $*
doskey git=@"%ProgramW6432%\git\cmd\git.exe" $*
doskey diff=@"%ProgramW6432%\git\usr\bin\diff.exe" $*
doskey github=@call "%AppData%\..\Local\GitHubDesktop\bin\github.bat" $*
doskey mediainfo=@"%ProgramW6432%\sysinternals\mediainfo\mediacmd.exe" $*
doskey wordpad=@"%ProgramW6432%\Windows NT\Accessories\wordpad.exe" $*
doskey imagex=@"%ProgramW6432%\Windows AIK\Tools\amd64\imagex.exe" $*
doskey oscdimg=@"%ProgramW6432%\Windows AIK\Tools\amd64\oscdimg.exe" $*
doskey checksur=@Dism.exe /Online /Cleanup-Image /ScanHealth $*
doskey xedit=@"%ProgramFiles(x86)%\KEDITW\KEDITW32.exe" $*
doskey xnview=@"%ProgramFiles(x86)%\XnView\XnView.exe" $*
doskey nconvert=@"%ProgramFiles(x86)%\XnView\nconvert.exe" $*
doskey regina=@"%REGINA_LANG_DIR%\regina.exe" $*
doskey noutil=@"%REGINA_LANG_DIR%\rexx.exe" $*
doskey regimm=echo $*$b@"%REGINA_LANG_DIR%\regina.exe"
doskey /insert
