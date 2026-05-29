@echo off

echo Fetching Windows WiFi IP...
for /f %%i in ('powershell -NoProfile -Command "(Get-NetIPAddress -InterfaceAlias WiFi -AddressFamily IPv4).IPAddress"') do set WIN_IP=%%i

if not defined WIN_IP (
    echo ERROR: Could not fetch WiFi IP. Are you connected?
    pause
    exit /b 1
)

echo IP: %WIN_IP%
set URL=http://%WIN_IP%:8080

wsl pwd

:: Hardcoded WSL path to your project folder
set WSL_CWD=/home/mars/python/projects/quizmaster/quizmaster

:: Generate raw QR code
wsl qrencode -o /tmp/qr_raw.png -s 20 -m 4 "%URL%"
if errorlevel 1 (
    echo ERROR: qrencode failed.
    pause
    exit /b 1
)

:: Add label, write final image directly to project folder
wsl convert /tmp/qr_raw.png ^
    -gravity South ^
    -background white ^
    -splice 0x80 ^
    -fill black ^
    -font DejaVu-Sans ^
    -pointsize 36 ^
    -kerning 1 ^
    -annotate +0+28 "%URL%" ^
    -resize 800x ^
    "%WSL_CWD%/qr_final.png"
if errorlevel 1 (
    echo ERROR: ImageMagick convert failed.
    pause
    exit /b 1
)

:: Open via explorer using the UNC path
explorer.exe "\\wsl.localhost\Ubuntu-24.04\home\mars\python\projects\quizmaster\quizmaster\qr_final.png"