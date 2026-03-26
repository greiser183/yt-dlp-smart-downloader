@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul
title yt-dlp 智能下载工具

echo.
echo  ╔════════════════════════════════════════════════════════════╗
echo                 yt-dlp 智能版（只需输入视频地址）                 
echo       yt-dlp.exe + ffmpeg.exe + *cookies.txt 必须在同文件夹   
echo       自动安装并调用 Node.js 作为 JS 运行                      
echo       先显示所有格式 → 你选择 → 再下载               
echo  ╚════════════════════════════════════════════════════════════╝
echo.

:: ==================== 检查并处理工具更新 ====================
echo 正在檢查必要工具...

set "NEED_UPDATE=0"

if not exist ".\yt-dlp.exe" set "NEED_UPDATE=1"
if not exist ".\ffmpeg.exe" set "NEED_UPDATE=1"

:: ===== 检查 Node.js 是否存在 =====
set "NODE_VER="
for /f "delims=" %%i in ('node -v 2^>nul') do set "NODE_VER=%%i"
if defined NODE_VER (
    echo Node.js 版本：%NODE_VER%
) else (
    echo 未檢測到 Node.js
    set "NEED_UPDATE=1"
)
echo.

if "!NEED_UPDATE!"=="1" (
    echo.
    echo 檢測到缺少必要工具，開始自動安裝...
    goto :auto_install
) else (
    echo 正在檢查 yt-dlp 是否有新版本...
    .\yt-dlp.exe --update-to stable --no-download-archive > "update_check.txt" 2>nul
    findstr /i "updating" "update_check.txt" >nul && (
        echo 發現 yt-dlp 新版本！
        set "UPDATE_YT="
        set /p "UPDATE_YT=是否立即更新 yt-dlp？ (Y/N，直接回车=更新): "
        if /i not "!UPDATE_YT!"=="N" (
            echo 正在更新 yt-dlp...
            .\yt-dlp.exe -U
            echo yt-dlp 更新完成！請重新運行腳本。
            del "update_check.txt" 2>nul
            pause
            exit /b 0
        )
    ) || echo yt-dlp 已是最新版本。
    del "update_check.txt" 2>nul
)

:: ==================== FFmpeg 更新檢查 ====================
echo.
echo 正在檢查 FFmpeg 是否存在...
if not exist ".\ffmpeg.exe" (
    echo FFmpeg 未找到，準備下載...
    goto :update_ffmpeg
) else (
    echo FFmpeg 已存在，跳過下載。
)
echo.
goto :input_url

:: ==================== FFmpeg 下載（真正動態進度條） ====================
:update_ffmpeg
echo.
echo 正在下載最新 FFmpeg 全套工具（約 100MB）...
echo 下载中，请耐心等待...

:: 實際下載（只執行一次）
if not exist "ffmpeg-latest.zip" (
    powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri 'https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip' -OutFile 'ffmpeg-latest.zip' -UseBasicParsing" >nul 2>&1
)

if exist "ffmpeg-latest.zip" (
    echo.
    echo 下載完成，正在解壓...
    goto :extract_ffmpeg
) else (
    timeout /t 1 >nul
    goto :download_progress
)

:extract_ffmpeg
powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue'; Expand-Archive -Path 'ffmpeg-latest.zip' -DestinationPath 'temp_ffmpeg' -Force" >nul 2>&1

echo 正在替換 ffmpeg.exe、ffprobe.exe、ffplay.exe ...
for /d %%D in ("temp_ffmpeg\ffmpeg-*") do xcopy "%%D\bin\*.exe" ".\" /Y /Q >nul 2>&1

rd /s /q "temp_ffmpeg" 2>nul
del "ffmpeg-latest.zip" 2>nul

echo FFmpeg 更新完成。
echo.
goto :input_url

:: ==================== 缺少工具時的自動安裝 ====================
:auto_install
echo.

:: ===== 安装 Node.js =====
node -v >nul 2>&1
if errorlevel 1 (
    echo [1/3] 正在下載並安裝 Node.js...

    if not exist "nodejs.msi" (
        powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -Command ^
        "$ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri 'https://nodejs.org/dist/latest/node-v20.11.1-x64.msi' -OutFile 'nodejs.msi' -UseBasicParsing" >nul 2>&1
    )

    if exist "nodejs.msi" (
        msiexec /i nodejs.msi /quiet /norestart
        del "nodejs.msi" >nul 2>&1
        echo Node.js 安裝完成
    ) else (
        echo Node.js 下載失敗
    )
)

if not exist ".\yt-dlp.exe" (
    echo [2/3] 正在下載 yt-dlp.exe ...
    powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri 'https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe' -OutFile 'yt-dlp.exe' -UseBasicParsing" >nul 2>&1
    echo yt-dlp.exe 下載完成。
)

if not exist ".\ffmpeg.exe" (
    echo [3/3] 正在下載 FFmpeg 全套工具...
    goto :update_ffmpeg
)
echo 工具安裝完成。
goto :input_url

:: ==================== 输入视频地址 ====================
:input_url
echo.
echo ══════════════════════════════════════════════════════
set "VIDEO_URL="
if "%~1"=="" (
    set /p "VIDEO_URL=请输入视频链接: "
) else (
    set "VIDEO_URL=%~1"
    echo 已拖入：!VIDEO_URL!
)

if "!VIDEO_URL!"=="" (
    echo [错误] 未输入链接
    pause & exit /b 1
)

echo.
echo ══════════════════════════════════════════════════════
echo 视频地址： !VIDEO_URL!
echo cookies： .\www.youtube.com_cookies.txt
echo yt-dlp： .\yt-dlp.exe
echo ffmpeg： .\ffmpeg.exe
echo Node.js：已调用 [--js-runtimes node]
echo ══════════════════════════════════════════════════════
echo.

:: ==================== 显示格式列表 ====================
echo 【步骤1】正在获取格式列表（包含清晰度和文件大小）...
.\yt-dlp.exe -F "!VIDEO_URL!" ^
    --cookies ".\www.youtube.com_cookies.txt" ^
    --js-runtimes node ^
    --ffmpeg-location ".\ffmpeg.exe"

echo.
echo ══════════════════════════════════════════════════════════════ 
echo 格式列表已显示完毕，请继续选择下载格式...
echo 例如:
echo   * 315+140    ← 4K video + best audio
echo   * 303+140    ← 1080p60
echo   * bestvideo[height=2160]+bestaudio  ← Priority 4K
echo   * bestvideo+bestaudio/best          ← Auto best quality
echo ══════════════════════════════════════════════════════════════
echo.

:: ==================== 选择格式 ====================
set "FORMAT_CHOICE="
set /p "FORMAT_CHOICE=請輸入格式代碼（直接 Enter 使用預設 315+140）: "

if "!FORMAT_CHOICE!"=="" (
    set "FORMAT_FLAG=-f 315+140/401+140/313+140/bestvideo+bestaudio/best"
    echo 已選擇預設格式：315+140 → 401+140 → 313+140 （全部帶音訊）
    goto :download
)

set "FORMAT_CHOICE=!FORMAT_CHOICE: =!"
if "!FORMAT_CHOICE!"=="" (
    set "FORMAT_FLAG=-f 315+140/401+140/313+140/bestvideo+bestaudio/best"
    echo 已選擇預設格式：315+140 → 401+140 → 313+140
    goto :download
)

set "FORMAT_FLAG=-f "!FORMAT_CHOICE!""
echo 已選擇自訂格式：!FORMAT_CHOICE!

:download
echo.
echo 【步骤2】開始下載...
echo.

:: ==================== 下載核心命令 ====================
.\yt-dlp.exe %FORMAT_FLAG% ^
    --cookies ".\www.youtube.com_cookies.txt" ^
    --js-runtimes node ^
    --ffmpeg-location ".\ffmpeg.exe" ^
    --merge-output-format mkv ^
    --embed-subs --embed-metadata --embed-thumbnail --embed-chapters ^
    --sub-langs "all,-live_chat" ^
    --convert-subs srt ^
    --convert-thumbnails png ^
    --ppa "EmbedThumbnail: -c copy" ^
    --concurrent-fragments 16 ^
    --retries 15 ^
    --fragment-retries 10 ^
    --no-keep-fragments ^
    --windows-filenames ^
    -o "%%(title)s [%%(id)s] [%%(resolution)s].%%(ext)s" ^
    "!VIDEO_URL!"

echo.
echo ════════════════════════════════════════════════
if %ERRORLEVEL% EQU 0 (
    echo ✓ 下载完成! 文件就在当前文件夹
) else (
    echo × 下载失败...可能的原因...
    echo   1. 所选格式不存在 [试试直接回车用默认]
    echo   2. cookies 已过期或无效 [需重新登录导出]
    echo   3. 网络问题 [需要代理]
    echo   4. ffmpeg 路径或版本不兼容
    echo   请把上面红色错误信息复制给AI帮你分析...
)
echo ════════════════════════════════════════════════
echo.

pause
endlocal