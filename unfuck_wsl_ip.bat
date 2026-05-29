@echo off
:: Run as Administrator after each WSL2/PC restart

:: ── Admin check ───────────────────────────────────────────────
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Please right-click and "Run as Administrator"
    pause
    exit /b 1
)

:: ── WSL2 IP ───────────────────────────────────────────────────
echo Fetching WSL2 IP...
for /f "tokens=1" %%i in ('wsl hostname -I 2^>nul') do set WSL_IP=%%i

if not defined WSL_IP (
    echo ERROR: Could not get WSL2 IP. Is WSL running?
    echo Try: wsl --list --running
    pause
    exit /b 1
)
echo WSL2 IP: %WSL_IP%

:: ── Windows WiFi IP ───────────────────────────────────────────
echo Fetching Windows WiFi IP...
for /f %%i in ('powershell -NoProfile -Command "(Get-NetIPAddress -InterfaceAlias WiFi -AddressFamily IPv4).IPAddress"') do set WIN_IP=%%i
echo %WIN_IP%

:: ── Port proxy ────────────────────────────────────────────────
echo Updating port proxy...
netsh interface portproxy delete v4tov4 listenport=8080 listenaddress=0.0.0.0 >nul 2>&1
netsh interface portproxy add v4tov4 listenport=8080 listenaddress=0.0.0.0 connectport=8080 connectaddress=%WSL_IP%

:: ── Firewall ──────────────────────────────────────────────────
echo Updating firewall rule...
netsh advfirewall firewall delete rule name="WSL2 Port 8080" >nul 2>&1
netsh advfirewall firewall add rule name="WSL2 Port 8080" dir=in action=allow protocol=tcp localport=8080

:: ── Done ──────────────────────────────────────────────────────
echo.
echo Done!
echo   Proxy:  0.0.0.0:8080 --^> %WSL_IP%:8080
echo   Access: http://%WIN_IP%:8080
echo.
pause