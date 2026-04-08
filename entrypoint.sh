#!/bin/bash
# 🌿 Awesome-Phishing-Bot Entrypoint Script

set -e

echo "╔══════════════════════════════════════════════════════════════════════════════╗"
echo "║                    🌿 AWESOME-PHISHING-BOT v9.5.1                            ║"
echo "║                         Starting container...                                ║"
echo "╚══════════════════════════════════════════════════════════════════════════════╝"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    echo -e "${YELLOW}⚠️  Running as root user${NC}"
fi

# Create necessary directories if not exist
mkdir -p .awesome_bot/phishing_pages
mkdir -p .awesome_bot/phishing_templates
mkdir -p .awesome_bot/phishing_logs
mkdir -p .awesome_bot/captured_credentials
mkdir -p awesome_reports/graphics
mkdir -p .awesome_bot/ssh_keys
mkdir -p .awesome_bot/whatsapp_session

# Check if config exists
if [ ! -f .awesome_bot/config.json ]; then
    echo -e "${YELLOW}📝 Creating default configuration...${NC}"
    cat > .awesome_bot/config.json << 'EOF'
{
    "version": "9.5.1",
    "first_run": true,
    "auto_start_phishing": false,
    "default_port": 8080,
    "log_level": "INFO",
    "max_credentials_storage": 10000,
    "auto_report": true,
    "report_interval_hours": 24
}
EOF
fi

# Check dependencies
echo -e "${GREEN}🔍 Checking dependencies...${NC}"
python3 -c "import requests, psutil, matplotlib, paramiko" && \
    echo -e "${GREEN}✅ All core dependencies OK${NC}" || \
    echo -e "${RED}❌ Some dependencies missing${NC}"

# Display container info
echo -e "${GREEN}📊 Container Information:${NC}"
echo "  Hostname: $(hostname)"
echo "  IP Address: $(hostname -I | awk '{print $1}')"
echo "  Python Version: $(python3 --version)"
echo "  Alpine Version: $(cat /etc/alpine-release 2>/dev/null || echo 'Unknown')"

# Start the bot
echo -e "${GREEN}🚀 Starting Awesome-Phishing-Bot...${NC}"
echo ""

# Execute the main script
exec python3 awesome_phishing_bot.py "$@"