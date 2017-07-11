@echo off
set bin_path=D:\\modeltech64_10.5\\win64
call %bin_path%/vsim   -do "do {gps_simulate.do}" -l simulate.log
if "%errorlevel%"=="1" goto END
if "%errorlevel%"=="0" goto SUCCESS
:END
exit 1
:SUCCESS
exit 0
