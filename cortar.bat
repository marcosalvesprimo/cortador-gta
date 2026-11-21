@echo off
rem Comando unico: cortar <link-da-live>
setlocal
set "PATH=%~dp0ferramentas\ffmpeg\bin;%~dp0ferramentas;%PATH%"
"%~dp0.venv\Scripts\python.exe" "%~dp0cortar.py" %*
