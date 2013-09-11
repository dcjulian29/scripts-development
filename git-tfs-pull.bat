@echo off
setlocal
call %~dp0_dev_settings.cmd

call %DEVT%\_ask-project-directory.cmd YES .git %1
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

pushd %DEVF%\%PROJNAME%

call %DEVT%\git-backup-remove.bat >NUL

echo.
echo Backup project (Just In Case)...
echo.

call %DEVT%\git-backup.bat >NUL

echo.
echo Updating project from TFS: %PROJNAME%
echo.

call %GIT% tfs fetch
:: Keep individual changes individual and do not merge...
call %GIT% rebase tfs/default

echo.
CHOICE /C:YN /M "Was the update successful"
SET RESULT=%ERRORLEVEL%
echo.

IF %RESULT% EQU 1 call %DEVT%\git-backup-remove.bat

popd

:EOF
