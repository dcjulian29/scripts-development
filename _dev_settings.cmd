if [%DEVSETTINGS%] equ [LOADED] goto EOF

::pushd ..
::set DEVF=%CD%
::popd
:: Need to weed out any scripts that depend on a hard-coded "DEV" folder
set DEVF=ZZZ:
:: Need to weed out any scripts that use "postpone"... 
::    just delete the folder and then check out from SCM later...
set DEVP=%DEVF%\_postponed

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

for /f "usebackq delims=" %%O in (`where %~n0`) do set DEVT=%%~dpO

set P64="%ProgramW6432%"
if [%P64%] == [""] goto P64
goto DPDIR

:P64

set P64="%ProgramFiles%"

:DPDIR

set PDIR="%ProgramFiles(x86)%"
if [%PDIR%] == [""] goto B32

goto CONT

:B32

set PDIR="%ProgramFiles%"

:CONT

set PDIR=%PDIR:"=%

if not exist "%PDIR%\Git" goto NOGIT

set GIT_INSTALL_ROOT=%PDIR%\Git
set GIT="%GIT_INSTALL_ROOT%\bin\git.exe"
path "%GIT_INSTALL_ROOT%\bin";%PATH%

:NOGIT

set TOOLDIR=%SYSTEMDRIVE%\Tools
set TOOLAPP=%TOOLDIR%\apps
set TOOLBIN=%TOOLDIR%\binaries
set TOOLDEV=%TOOLDIR%\development

set ZIP="%TOOLBIN%\7Zip.cmd"
set PSHELL=call %TOOLBIN%\pshell.cmd 

set NANT=%TOOLDEV%\nant\bin\NAnt.exe
set NUNIT=%TOOLDEV%\nunit\bin\nunit-console-x86.exe
set NSIS=%TOOLDEV%\nsis\nsis.exe


:: Find MSBuild
set MSBUILD=
for /D %%D in (%SYSTEMROOT%\Microsoft.NET\Framework\v*) do (
  if exist %%D\MSBuild.exe set MSBUILD=%%D\MSBuild.exe
)
for /D %%D in (%SYSTEMROOT%\Microsoft.NET\Framework64\v*) do (
  if exist %%D\MSBuild.exe set MSBUILD=%%D\MSBuild.exe
)

:: As of 4.5.1 (VS 2013), MSBuild has been removed from the "framework"
for /D %%D in ("C:\Program Files (x86)\MSBuild\*") do (
  if exist %%D\bin\MSBuild.exe set MSBUILD="%%D\bin\MSBuild.exe"
)

set DEVSETTINGS=LOADED

:EOF
