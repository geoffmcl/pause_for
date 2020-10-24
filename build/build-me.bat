@setlocal
@set TMPPRJ=pause_for
@echo Building project %TMPPRJ%
@set TMPSRC=..
@if NOT EXIST %TMPSRC%\nul goto NOSRC
@if NOT EXIST %TMPSRC%\CMakeLists.txt goto NOCM
@set TMPLOG=bldlog-1.txt
@REM ******************************************************
@REM *** Note special install location, but is NOT used ***
@REM *** No install is setup in the CMakeLists.txt      ***
@set TMPOPTS=-DCMAKE_INSTALL_PREFIX=C:/MDOS
@REM ******************************************************

@REM set TMPOPTS=%TMPOPTS% -DCMAKE_PREFIX_PATH:PATH=F:/FG/18/install/msvc100/simgear;Z:/software;F:/FG/18/3rdParty
@REM set TMPOPTS=%TMPOPTS% -DCMAKE_PREFIX_PATH:PATH=X:/install/msvc100/simgear;X:/3rdParty

@REM Just a check if MSVC IDE is running... cna be ignored, removed...
@call chkmsvc %TMPPRJ%

@echo Begin %TMPPRJ% %DATE% %TIME% > %TMPLOG%

@echo Doing: 'cmake %TMPSRC% %TMPOPTS%' output to %TMPLOG%
@echo Doing: 'cmake %TMPSRC% %TMPOPTS%' >>%TMPLOG%
cmake %TMPSRC% %TMPOPTS% >>%TMPLOG% 2>&1
@if ERRORLEVEL 1 goto ERR1

@echo Doing: 'cmake --build . --config Debug' output to %TMPLOG%
@echo Doing: 'cmake --build . --config Debug' >>%TMPLOG%
cmake --build . --config Debug >>%TMPLOG% 2>&1
@if ERRORLEVEL 1 goto ERR2

@echo Doing: 'cmake --build . --config Release' output to %TMPLOG%
@echo Doing: 'cmake --build . --config Release' >>%TMPLOG%
cmake --build . --config Release >>%TMPLOG% 2>&1
@if ERRORLEVEL 1 goto ERR3

@echo Appears a successful build...
@echo.
@echo No install at this time... But check, change and maybe use upd-exe.bat...
@echo.
@goto END

@echo Continue with install? Only Ctrl+C aborts...
@pause
@REM echo Doing: 'cmake --build . --config Debug --target INSTALL' output to %TMPLOG%
@REM echo Doing: 'cmake --build . --config Debug --target INSTALL' >>%TMPLOG%
@REM cmake --build . --config Debug --target INSTALL >>%TMPLOG% 2>&1
@REM if ERRORLEVEL 1 goto ERR4

@echo Doing: 'cmake --build . --config Release --target INSTALL' output to %TMPLOG%
@echo Doing: 'cmake --build . --config Release --target INSTALL' >>%TMPLOG%
cmake --build . --config Release --target INSTALL >>%TMPLOG% 2>&1
@if ERRORLEVEL 1 goto ERR5

@echo Appears a successful build and install... see %TMPLOG% for details

@goto END

:NOZDIR
@echo Error: Z: drive NOT setup!
@goto ISERR

:NOXDIR
@echo Error: X: drive NOT setup!
@goto ISERR

:NOSRC
@echo Can NOT locate source %TMPSRC%! *** FIX ME ***
@goto ISERR

:NOCM
@echo Can NOT locate source %TMPSRC%\CMakeLists.txt! *** FIX ME ***
@goto ISERR

:ERR4
:ERR5
@echo See %TMPLOG% for error
@goto ISERR

:Err1
@echo cmake config, gen error
@goto ISERR

:Err2
@echo debug build error
@goto ISERR

:Err3
@echo release build error
@goto ISERR

:ISERR
@endlocal
@exit /b 1

:END
@endlocal
@exit /b 0

@REM eof
