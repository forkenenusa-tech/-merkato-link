@echo off
echo Switching environment configuration...
echo.

if "%1"=="device" (
  echo Copying device configuration (192.168.1.9) to .env
  copy .env.device .env > nul
  echo ✓ Switched to DEVICE configuration
  echo   API_URL will be: http://192.168.1.9:5001
  echo   For physical Android device testing
) else if "%1"=="emulator" (
  echo Copying emulator configuration to .env
  copy .env.emulator .env > nul
  echo ✓ Switched to EMULATOR configuration
  echo   API_URL will be: http://10.0.2.2:5001
  echo   For Android emulator testing
) else if "%1"=="localhost" (
  echo Copying localhost configuration to .env
  echo API_URL=http://localhost:5001 > .env
  echo ✓ Switched to LOCALHOST configuration
  echo   API_URL will be: http://localhost:5001
  echo   For web or desktop testing
) else (
  echo Usage: switch_env [device|emulator|localhost]
  echo.
  echo Current .env file content:
  type .env
)

echo.
echo Note: You need to restart the Flutter app after switching configurations.