@echo off

if exist calc.obj del calc.obj
if exist calc.exe del calc.exe

@echo ---  Assembling
\masm32\bin\ml.exe /c /coff /Zi calc.asm
if errorlevel 1 goto errasm

@echo ---  Linking
\masm32\bin\Link.exe /SUBSYSTEM:WINDOWS /OPT:NOREF calc.obj
if errorlevel 1 goto errlink

goto TheEnd

:errlink
echo _
echo Link error
goto TheEnd

:errasm
echo _
echo Assembly Error
goto TheEnd

:TheEnd

pause
