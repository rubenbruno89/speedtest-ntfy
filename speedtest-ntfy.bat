@echo off
setlocal enabledelayedexpansion
title Teste de Velocidade e IP
cls

echo ==========================================
echo   Verificando IP Publico
echo ==========================================
curl -s "ifconfig.me"
echo.
echo.

echo ==========================================
echo   Executando teste de velocidade...
echo   (isso pode levar alguns instantes)
echo ==========================================

REM Verifica se o comando speedtest existe antes de rodar
where speedtest >nul 2>&1
if errorlevel 1 (
    echo [ERRO] O comando "speedtest" nao foi encontrado no PATH.
    echo Instale o Speedtest CLI da Ookla e tente novamente.
    pause
    exit /b 1
)

REM Gera um nome de arquivo com data e hora para nao sobrescrever testes antigos
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set dt=%%I
set "timestamp=%dt:~0,4%-%dt:~4,2%-%dt:~6,2%_%dt:~8,2%-%dt:~10,2%-%dt:~12,2%"
set "arquivo=velocidade_%timestamp%.txt"

echo IP Publico: > "%arquivo%"
curl -s "ifconfig.me" >> "%arquivo%"
echo. >> "%arquivo%"
echo. >> "%arquivo%"
echo Data/Hora do teste: %date% %time% >> "%arquivo%"
echo. >> "%arquivo%"

speedtest >> "%arquivo%" 2>&1

if errorlevel 1 (
    echo [ERRO] Falha ao executar o speedtest.
    pause
    exit /b 1
)

echo.
echo ==========================================
echo   Enviando resultado para o ntfy.sh
echo ==========================================
curl --upload-file "%arquivo%" ntfy.sh/Alarmenoc

if errorlevel 1 (
    echo [ERRO] Falha ao enviar o arquivo para o ntfy.sh
) else (
    echo Resultado enviado com sucesso!
)

echo.
echo Arquivo salvo como: %arquivo%
echo.
pause
endlocal
exit /b 0
