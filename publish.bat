@echo off
chcp 65001 >nul
title NovaEdge Blog 一键发布

REM 切到当前脚本所在目录（就是你的博客根目录）
cd /d "%~dp0"

echo ==========================================
echo  1. 拉取远程最新源码 (git pull)
echo ==========================================
git pull
echo.

echo ==========================================
echo  2. 清理並重新生成靜態文件 (hexo clean / g)
echo ==========================================
call hexo clean
if errorlevel 1 goto END

call hexo g
if errorlevel 1 goto END
echo.

echo ==========================================
echo  3. 部署到 GitHub Pages (hexo d)
echo ==========================================
call hexo d
if errorlevel 1 goto END
echo.

echo ==========================================
echo  4. 提交本地源码變更並推送 (git add/commit/push)
echo ==========================================
git add .

REM 如果沒有變更，commit 會失敗，但腳本繼續跑
git commit -m "update %date% %time%" || echo [提示] 沒有新的變更可以提交，跳過 commit。

git push
echo.

echo ==========================================
echo  ✅ 完成！blog.novaedge.vip 很快就會更新
echo ==========================================
goto PAUSE

:END
echo.
echo ❌ 中間有命令報錯，請查看上面的錯誤信息。

:PAUSE
echo.
pause
