@echo off
setlocal
cd /d "%~dp0"
echo 啟動 SOPCreationAssistant...
SOPCreationAssistant.exe
if errorlevel 1 (
  echo.
echo 程式啟動失敗，請查看啟動記錄檔：
echo %LOCALAPPDATA%\SOPCreationAssistant\startup.log
echo.
pause
)
endlocal
