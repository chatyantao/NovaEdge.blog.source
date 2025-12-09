@echo off
chcp 65001 >nul
title NovaEdge Blog 本地預覽

cd /d "%~dp0"

echo 啟動 Hexo 本地服務：http://localhost:4000
echo 關閉預覽請在窗口中按 Ctrl + C
echo.

call hexo s
