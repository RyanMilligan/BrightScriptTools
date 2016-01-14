@ECHO OFF
REM This batch is used to automatically wrap other build scripts with additional information, like start time,
REM end time, and the final error level. The final error level must be preserved when exiting this script.

@ECHO %DATE% - %TIME% - STARTING %*
cmd.exe /C %*
@ECHO %DATE% - %TIME% - FINISHED %*

@ECHO ErrorLevel: %ERRORLEVEL%
EXIT %ERRORLEVEL%