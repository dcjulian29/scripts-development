:: Compare "custom" msbuild file with the Visual Studio "CSPROJ" file
@echo off

setlocal

CALL C:\bin\development-tools\_dev_settings.bat

IF NOT "%1" == "" GOTO C1

ECHO.
ECHO Please provide the custom msbuild file name.
ECHO.

GOTO EOF

:C1

IF NOT "%2" == "" GOTO C2

ECHO.
ECHO Please provide the Visual Studio CSPROJ file name.
ECHO.

GOTO EOF

:C2

IF EXIST %1 GOTO C3

ECHO.
ECHO Custom msbuild file does not exist.
ECHO.

GOTO EOF

:C3

IF EXIST %2 GOTO C4

ECHO.
ECHO Visual Studio CSPROJ file does not exist.
ECHO.

GOTO EOF

:C4

echo.
echo Comparing %1 to %2...
echo.

SET FIND=%WINDIR%\System32\find.exe
SET NFIND=%FIND% /V
SET SORT=%WINDIR%\System32\sort.exe
SET PSHELL=PowerShell -NoLogo -NoProfile -NonInteractive -Command

SET BAI=buildAssemblyInfo.cs
SET COMPILE=^<Compile Include=""
SET REFERENCE=^<Reference Include=""
SET WCF=^<Compile Include=""Service References\
SET WS=^<Compile Include=""Web References\

SET T1C=%TEMP%\sync-msbuild-1C.txt
SET T2C=%TEMP%\sync-msbuild-2C.txt

SET T1R=%TEMP%\sync-msbuild-1R.txt
SET T2R=%TEMP%\sync-msbuild-2R.txt

SET T1W=%TEMP%\sync-msbuild-1W.txt
SET T2W=%TEMP%\sync-msbuild-2W.txt

SET T1WS=%TEMP%\sync-msbuild-1WS.txt
SET T2WS=%TEMP%\sync-msbuild-2WS.txt

type %1 | %FIND% "%COMPILE%" | %NFIND% "%BAI%" | %NFIND% "%WCF%" | %NFIND% "%WS%" | %SORT% > %T1C%
type %2 | %FIND% "%COMPILE%" | %NFIND% "%BAI%" | %NFIND% "%WCF%" | %NFIND% "%WS%" | %SORT% > %T2C%
echo "" >> %T1C%
echo "" >> %T2C%

type %1 | %FIND% "%REFERENCE%" | %SORT% > %T1R%
type %2 | %FIND% "%REFERENCE%" | %SORT% > %T2R%
echo "" >> %T1R%
echo "" >> %T2R%

type %1 | %FIND% "%WCF%" | %SORT% > %T1W%
type %2 | %FIND% "%WCF%" | %SORT% > %T2W%
echo "" >> %T1W%
echo "" >> %T2W%

type %1 | %FIND% "%WS%" | %SORT% > %T1WS%
type %2 | %FIND% "%WS%" | %SORT% > %T2WS%
echo "" >> %T1WS%
echo "" >> %T2WS%

echo ----- Compile Item Differences
%PSHELL% "& {Compare-Object (Get-Content %T1C%) (Get-Content %T2C%)}"

echo.
echo ----- Reference Item Differences
%PSHELL% "& {Compare-Object (Get-Content %T1R%) (Get-Content %T2R%)}"

echo.
echo ----- Service Reference Item Differences
%PSHELL% "& {Compare-Object (Get-Content %T1W%) (Get-Content %T2W%)}"

echo.
echo ----- Web Reference Item Differences
%PSHELL% "& {Compare-Object (Get-Content %T1WS%) (Get-Content %T2WS%)}"

echo.

:EOF
