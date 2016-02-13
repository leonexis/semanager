@echo off
title SEMU
echo SEMU - Space Engineers Maintenance Utility
echo By David McDonald 2015
echo.

rem PUT COMMANDS HERE. E.g. -s "C:\Path\to\save" -c powered -x -L both -q
rem For instructions, run SEMU with --help
set commands=-s "C:\setest\Saves\world" -x -l DEBUG -i -n -r -c block -d -m
echo Commands: %commands%
echo.
rem semu.exe %commands%
C:\Python34\python.exe semu.py %commands%

pause
