REM === ARGUMENTS ===
REM  %1  Application folder        IE: demo or dma
REM  %2  Build target environment  IE: staging or reflector
REM  %3  Archive filename          IE: Demo_2015_01_01.zip  or  DMA_2015_01_01.zip
REM  %4  (optional) IP address     IE: 192.168.3.4
REM  %5  (optional) "FINAL" - If provided, the build will get debug features removed automatically, and will skip tests.

@REM FIX DEDICATED ROKU IP
SET DEDICATEDROKUIP=192.168.21.116
SET ARCHIVEFILENAME=%3

IF "%3" EQU "" (@ECHO Invalid parameters. This job should only be run by the build system. & EXIT /B 10)
IF /I "%4" EQU "FINAL" (SET FINAL=FINAL) ELSE (SET DEDICATEDROKUIP=%4&@ECHO Redirecting buildSystemJob to use Roku IP: %4)
IF /I "%5" EQU "FINAL" (SET FINAL=FINAL&SET DEDICATEDROKUIP=%4&@ECHO Redirecting buildSystemJob to use Roku IP: %4)

SET ZIPFILENAME=%1-%2%FINAL%-Roku.zip

:BuildApp
@ECHO ** Starting BuildApp Step **
call %~dp0..\build.bat %1 %2 %DEDICATEDROKUIP% %FINAL%
IF %ERRORLEVEL% NEQ 0 @ECHO *** BUILD APP FAILED *** & EXIT /B %ERRORLEVEL%

:ArchiveBuild
@ECHO ** Starting ArchiveBuild Step **
@REM copy /Y ".\out\%ZIPFILENAME%" "\\fileserver\Development\RatioTV\Builds\Roku\%ARCHIVEFILENAME%"
@REM IF %ERRORLEVEL% NEQ 0 @ECHO *** ARCHIVE BUILD FAILED *** & EXIT /B %ERRORLEVEL%

:DeployToRoku
@ECHO ** Starting DeployToRoku Step **
call %~dp0..\launch.bat %1 %2 %DEDICATEDROKUIP% /SkipReboot false
IF %ERRORLEVEL% NEQ 0 @ECHO *** DEPLOY TO ROKU FAILED *** & EXIT /B %ERRORLEVEL% 

:RunTests
@REM IF "%FINAL%" NEQ "" (@ECHO Final build; skipping tests. & GOTO DONE)
@REM @ECHO ** Starting RunTests Step **
@REM Runs against the dedicated build system Roku, with a short 5 minute timeout for all tests to complete.
@REM %~dp0TestConsole\TestConsole.exe /C roku:%DEDICATEDROKUIP% /W 5
@REM IF %ERRORLEVEL% NEQ 0 @ECHO *** RUN TESTS FAILED *** & EXIT /B %ERRORLEVEL% 

:DONE
@ECHO Done. Exiting with errorlevel %ERRORLEVEL%
EXIT /B %ERRORLEVEL%
