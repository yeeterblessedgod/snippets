@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
echo Установка расширений VS Code (офлайн)...
echo.

set "CODECLI="

REM Свой путь (если автопоиск не сработал):
REM   install-extensions.cmd "C:\Program Files\Microsoft VS Code\bin\code.cmd"
if not "%~1"=="" (
    if exist "%~1" (
        set "CODECLI=%~1"
        goto :install
    )
    echo Файл не найден: %~1
    echo.
)

REM Стандартные пути VS Code на экзаменационных ПК
for %%P in (
    "%LocalAppData%\Programs\Microsoft VS Code\bin\code.cmd"
    "C:\Program Files\Microsoft VS Code\bin\code.cmd"
    "C:\Program Files (x86)\Microsoft VS Code\bin\code.cmd"
    "D:\Program Files\Microsoft VS Code\bin\code.cmd"
    "D:\Programs\Microsoft VS Code\bin\code.cmd"
    "E:\Program Files\Microsoft VS Code\bin\code.cmd"
) do (
    if not defined CODECLI if exist %%P set "CODECLI=%%~P"
)

REM Команда code в PATH — только если это НЕ Cursor
if not defined CODECLI (
    for /f "delims=" %%i in ('where code 2^>nul') do (
        echo %%i | findstr /i "cursor" >nul
        if errorlevel 1 if not defined CODECLI set "CODECLI=%%i"
    )
)

if not defined CODECLI goto :manual

:install
echo Найден VS Code: !CODECLI!
echo.

for %%f in ("%~dp0extensions\*.vsix") do (
    echo Устанавливаю %%~nxf ...
    "!CODECLI!" --install-extension "%%f"
)

echo.
echo Готово. Перезапустите VS Code.
pause
exit /b 0

:manual
echo VS Code автоматически не найден — это нормально, путь указывать не обязательно.
echo.
echo СПОСОБ 1 — вручную (самый надёжный на экзамене):
echo   1. Откройте VS Code
echo   2. Extensions (Ctrl+Shift+X)
echo   3. Три точки (...) - Install from VSIX...
echo   4. Папка: %~dp0extensions
echo   5. Установите все .vsix по очереди
echo.
echo СПОСОБ 2 — если знаете путь к code.cmd:
echo   install-extensions.cmd "C:\Program Files\Microsoft VS Code\bin\code.cmd"
echo.
pause
exit /b 1
