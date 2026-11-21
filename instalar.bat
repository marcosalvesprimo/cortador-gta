@echo off
rem Instalador para Windows. De dois cliques ou rode: instalar.bat
rem Nao precisa de winget: baixa ffmpeg e Deno direto para a pasta "ferramentas".
setlocal
cd /d "%~dp0"
set "FERR=%~dp0ferramentas"
set "PATH=%FERR%\ffmpeg\bin;%FERR%;%PATH%"

echo [1/4] Conferindo o Python...
python -c "import sys; sys.exit(0 if sys.version_info >= (3, 11) else 1)" >nul 2>nul
if errorlevel 1 goto sem_python

if not exist "%FERR%" mkdir "%FERR%"

echo [2/4] Conferindo o ffmpeg...
where ffmpeg >nul 2>nul
if not errorlevel 1 goto tem_ffmpeg
echo       Baixando ffmpeg (cerca de 200 MB, pode demorar)...
if exist "%FERR%\ffmpeg" rmdir /s /q "%FERR%\ffmpeg"
if exist "%FERR%\tmp" rmdir /s /q "%FERR%\tmp"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; $ProgressPreference='SilentlyContinue'; $f=$env:FERR; Invoke-WebRequest -Uri 'https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip' -OutFile ($f+'\ffmpeg.zip'); Expand-Archive -Force ($f+'\ffmpeg.zip') ($f+'\tmp'); $d=Get-ChildItem ($f+'\tmp') -Directory; Move-Item $d[0].FullName ($f+'\ffmpeg'); Remove-Item -Recurse -Force ($f+'\tmp'), ($f+'\ffmpeg.zip')"
if errorlevel 1 goto erro
:tem_ffmpeg

echo [3/4] Conferindo o Deno (necessario para o YouTube)...
where deno >nul 2>nul
if not errorlevel 1 goto tem_deno
echo       Baixando Deno...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; $ProgressPreference='SilentlyContinue'; $f=$env:FERR; Invoke-WebRequest -Uri 'https://github.com/denoland/deno/releases/latest/download/deno-x86_64-pc-windows-msvc.zip' -OutFile ($f+'\deno.zip'); Expand-Archive -Force ($f+'\deno.zip') $f; Remove-Item -Force ($f+'\deno.zip')"
if errorlevel 1 goto erro
:tem_deno

echo [4/4] Instalando as bibliotecas Python (alguns minutos)...
if not exist ".venv\Scripts\python.exe" python -m venv .venv
if errorlevel 1 goto erro
".venv\Scripts\python.exe" -m pip install --upgrade pip -q
".venv\Scripts\python.exe" -m pip install -r requirements.txt
if errorlevel 1 goto erro

echo.
echo Pronto! Abra um terminal nesta pasta e use:
echo    cortar ^<link-da-live^>
pause
exit /b 0

:sem_python
echo.
echo Python 3.11 ou mais novo nao encontrado.
echo Baixe em https://www.python.org/downloads/ e, na instalacao,
echo marque a opcao "Add python.exe to PATH". Depois rode este instalador de novo.
pause
exit /b 1

:erro
echo.
echo Deu erro na instalacao. Copie as mensagens acima e mande para quem esta te ajudando.
pause
exit /b 1
