@echo off
setlocal
call %~dp0_dev_settings.cmd

call %TOOLDEV%\DocBook\docbook-ask-project.cmd YES %1
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

echo.
echo Generating HTML document(s) from the DocBook project...
echo.

call %TOOLDEV%\DocBook\dobudish.cmd %DOCNAME% html

endlocal
