#!/bin/bash
# 🚀 Swasya AI - Complete Automated Setup
# This script does everything: IP detection + API key setup + dependency installation

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_ROOT"
SCRIPTS_DIR="$(cd "$(dirname "$0")" && pwd)"

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                                                               ║"
echo "║          🚀 Swasya AI - Complete Setup Script                ║"
echo "║                                                               ║"
echo "║  This script will:                                           ║"
echo "║  1. Detect your local IP                                    ║"
echo "║  2. Configure all environment files                         ║"
echo "║  3. Help you add API keys                                   ║"
echo "║  4. Install dependencies                                    ║"
echo "║                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# ===================================================================
# Step 1: Run IP Setup
# ===================================================================

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STEP 1️⃣  Automatic IP Configuration"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

bash "$SCRIPTS_DIR/setup-ip.sh"

if [ $? -ne 0 ]; then
  echo "❌ IP setup failed!"
  exit 1
fi

# ===================================================================
# Step 2: API Keys (Optional)
# ===================================================================

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STEP 2️⃣  API Keys Configuration"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

read -p "Do you have API keys ready? (y/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
  bash "$SCRIPTS_DIR/setup-keys.sh"
else
  echo ""
  echo "⏭️  Skipping API keys setup for now."
  echo "   You can add them later by running: bash scripts/setup-keys.sh"
  echo ""
fi

# ===================================================================
# Step 3: Install Dependencies
# ===================================================================

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STEP 3️⃣  Install Dependencies"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "📦 Checking frontend dependencies..."
if [ ! -d "client/node_modules" ]; then
  echo "   Installing frontend dependencies..."
  cd client
  pnpm install
  cd ..
  echo "   ✅ Frontend dependencies installed"
else
  echo "   ✅ Frontend dependencies already installed"
fi
echo ""

echo "📦 Checking backend dependencies..."
if [ ! -d "backend/simple_backend/venv" ]; then
  echo "   Creating Python virtual environment..."
  python3 -m venv backend/simple_backend/venv
  echo "   ✅ Virtual environment created"
else
  echo "   ✅ Virtual environment already exists"
fi
echo ""

# ===================================================================
# Step 4: Final Summary
# ===================================================================

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                                                               ║"
echo "║            ✅ Setup Complete!                                ║"
echo "║                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

echo "🎯 Next Steps:"
echo ""
echo "   1. Verify your IP configuration:"
echo "      cat client/.env"
echo ""
echo "   2. If you skipped API keys, add them:"
echo "      bash scripts/setup-keys.sh"
echo ""
echo "   3. Start development:"
echo "      mprocs"
echo ""
echo "📚 Useful commands:"
echo ""
echo "   • Reconfigure IP:      bash scripts/setup-ip.sh"
echo "   • Update API keys:     bash scripts/setup-keys.sh"
echo "   • View full docs:      cat API_KEYS_SETUP.md"
echo ""
