@echo off
setlocal enabledelayedexpansion
title Teste de Velocidade e IP (Automatico)

set /a intervalo_minutos=60

:loop
cls
echo ==========================================
echo   Verificando IP Publico
echo ==========================================
curl -s "ifconfig.me"
echo.

for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set dt=%%I
set "timestamp=%dt:~0,4%-%dt:~4,2%-%dt:~6,2%_%dt:~8,2%-%dt:~10,2%-%dt:~12,2%"
set "arquivo=velocidade_%timestamp%.txt"

echo IP Publico: > "%arquivo%"
curl -s "ifconfig.me" >> "%arquivo%"
echo. >> "%arquivo%"
echo Data/Hora do teste: %date% %time% >> "%arquivo%"
echo. >> "%arquivo%"

speedtest >> "%arquivo%" 2>&1
curl --upload-file "%arquivo%" ntfy.sh/Alarmenoc

echo.
echo Proximo teste em %intervalo_minutos% minutos...
timeout /t %intervalo_minutos:*60%... 2>nul

REM Converte minutos para segundos e aguarda
set /a espera_segundos=intervalo_minutos*60
timeout /t %espera_segundos% /nobreak

goto loop