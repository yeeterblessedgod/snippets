@echo off
chcp 65001 >nul
echo Установка расширений VS Code (офлайн)...
echo.

where code >nul 2>&1
if errorlevel 1 (
    echo ОШИБКА: команда "code" не найдена.
    echo Откройте VS Code вручную: Extensions - три точки - Install from VSIX
    echo Папка: %~dp0extensions
    pause
    exit /b 1
)

for %%f in ("%~dp0extensions\*.vsix") do (
    echo Устанавливаю %%~nxf ...
    code --install-extension "%%f"
)

echo.
echo Готово. Перезапустите VS Code если нужно.
pause
