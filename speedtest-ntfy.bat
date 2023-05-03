@echo off
cls
echo IP Publico
curl "ifconfig.me"
echo.
echo Salvando o resultado no arquivo velocidade.txt
speedtest >velocidade.txt
curl --upload-file velocidade.txt ntfy.sh/Alarmenoc
exit
