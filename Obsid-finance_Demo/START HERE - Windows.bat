@echo off
title Obsid-finance
cd /d "%~dp0"
echo Starting Obsid-finance...
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0launcher\server.ps1"
echo.
pause
