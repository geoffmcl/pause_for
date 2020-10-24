@setlocal
@set TMPEXE=pause_for.exe
@set TMPSRC=Release\%TMPEXE%
@set TMPDST=C:\MDOS
@set TMPFIL=%TMPDST%\%TMPEXE%

@REM sanity checks
@if NOT EXIST %TMPSRC% goto NOSRC
@if NOT EXIST %TMPDST%\nul goto NODST
@fc4 -? >nul
@if ERRORLEVEL 4 goto NOFC4
@if ERRORLEVEL 3 goto GOTFC4
@goto NOFC4
:GOTFC4

@if NOT EXIST %TMPFIL% goto DOCOPY

@fc4 -q -v0 %TMPSRC% %TMPFIL% >nul

@if ERRORLEVEL 1 goto DOCOPY
@echo.
@echo Files %TMPSRC% and %TMPFIL% appear exactly the SAME
@echo Nothing to do here...
@echo.
@goto END

:DOCOPY
@echo.
@echo Files %TMPSRC% and %TMPFIL% different... proceed to update...
@echo.
@pause

copy %TMPSRC% %TMPFIL%


@goto END

:NOSRC
@echo Can NOT locate src %TMPSRC%! *** FIX ME ***
@goto END

:NODST
@echo Can NOT locate dst %TMPDST%! *** FIX ME ***
@echo Set a VALID destination directory...
@goto END

:NOFC4
@echo Can NOT run comare utility! *** FIX ME ***
@echo Either get a copy of FC4, or
@echo change this batch to use another binary comare utility...
@goto END


:END
