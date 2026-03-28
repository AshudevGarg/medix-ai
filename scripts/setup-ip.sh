#!/bin/bash
# 🔧 Swasya AI - Automatic IP Configuration Setup Script
# This script detects your local IP and configures all necessary files

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_ROOT"

echo "═══════════════════════════════════════════════════════════════"
echo "🔧 Swasya AI - Automatic IP Configuration"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# ═══════════════════════════════════════════════════════════════════
# Step 1: Detect Local IP
# ═══════════════════════════════════════════════════════════════════

echo "📡 Detecting local IP address..."

# Try multiple methods to get IP
get_ip() {
  # Method 1: hostname -I (Linux/WSL)
  if command -v hostname &> /dev/null; then
    local ip=$(hostname -I 2>/dev/null | awk '{print $1}')
    if [ ! -z "$ip" ] && [ ! "$ip" = "127.0.0.1" ]; then
      echo "$ip"
      return 0
    fi
  fi
  
  # Method 2: ipconfig (Windows)
  if command -v ipconfig &> /dev/null; then
    local ip=$(ipconfig | grep -i "IPv4 Address" | head -1 | awk -F: '{print $2}' | xargs)
    if [ ! -z "$ip" ] && [ ! "$ip" = "127.0.0.1" ]; then
      echo "$ip"
      return 0
    fi
  fi
  
  # Method 3: ifconfig (macOS/Linux)
  if command -v ifconfig &> /dev/null; then
    local ip=$(ifconfig | grep -i "inet " | grep -v "127.0.0.1" | head -1 | awk '{print $2}')
    if [ ! -z "$ip" ]; then
      echo "$ip"
      return 0
    fi
  fi
  
  # Fallback to localhost
  echo "127.0.0.1"
}

LOCAL_IP=$(get_ip)
echo "✅ Local IP detected: $LOCAL_IP"
echo ""

# ═══════════════════════════════════════════════════════════════════
# Step 2: Create/Update .env Files
# ═══════════════════════════════════════════════════════════════════

echo "📝 Configuring environment files..."
echo ""

# Backend .env
BACKEND_ENV="backend/simple_backend/.env"
if [ -f "$BACKEND_ENV" ]; then
  echo "   ✅ Found: $BACKEND_ENV"
  # The backend doesn't need IP for itself, just ensure API keys are there
  if grep -q "GEMINI_API_KEY=your_gemini_api_key_here" "$BACKEND_ENV"; then
    echo "   ⚠️  Placeholder API keys still present - Remember to add real keys!"
  fi
else
  echo "   ❌ Not found: $BACKEND_ENV"
  exit 1
fi
echo ""

# Frontend .env
FRONTEND_ENV="client/.env"
echo "   Updating: $FRONTEND_ENV"
if [ ! -f "$FRONTEND_ENV" ]; then
  # Create if doesn't exist
  cat > "$FRONTEND_ENV" << EOF
# Frontend Environment Configuration

# API Configuration
export VITE_API_BASE_URL=http://localhost:8000
export VITE_NODE_ENV=development

# Feature Flags
export VITE_ENABLE_MAP=true
export VITE_ENABLE_TIMELINE=true
EOF
  echo "   ✅ Created new $FRONTEND_ENV"
else
  # Update existing
  if grep -q "VITE_API_BASE_URL=" "$FRONTEND_ENV"; then
    # Replace the URL with new IP
    sed -i.bak "s|VITE_API_BASE_URL=.*|VITE_API_BASE_URL=http://localhost:8000|g" "$FRONTEND_ENV"
    echo "   ✅ Updated $FRONTEND_ENV"
    rm -f "$FRONTEND_ENV.bak"
  else
    echo "   ⚠️  Could not find VITE_API_BASE_URL in $FRONTEND_ENV"
  fi
fi
echo ""

# ═══════════════════════════════════════════════════════════════════
# Step 3: Update Mobile App Configuration
# ═══════════════════════════════════════════════════════════════════

echo "📱 Updating Flutter mobile app configuration..."
FLUTTER_SCRIPT="$PROJECT_ROOT/scripts/setup-mobile-ip.sh"
if [ -f "$FLUTTER_SCRIPT" ]; then
  bash "$FLUTTER_SCRIPT"
else
  echo "   ⚠️  Mobile setup script not found, skipping..."
fi
echo ""

# ═══════════════════════════════════════════════════════════════════
# Step 4: Update Any Other References
# ═══════════════════════════════════════════════════════════════════

echo "🔍 Searching for other IP references..."
echo ""

# Check CORS origins in backend .env
if grep -q "CORS_ORIGINS=" "$BACKEND_ENV"; then
  echo "   ✅ Found CORS_ORIGINS in backend .env"
  # Update CORS to include new IP
  sed -i.bak "s|http://172\.[0-9.]*:5173|http://$LOCAL_IP:5173|g" "$BACKEND_ENV"
  sed -i.bak "s|http://172\.[0-9.]*:3000|http://$LOCAL_IP:3000|g" "$BACKEND_ENV"
  sed -i.bak "s|http://172\.[0-9.]*:8000|http://$LOCAL_IP:8000|g" "$BACKEND_ENV"
  rm -f "$BACKEND_ENV.bak"
fi
echo ""

# ═══════════════════════════════════════════════════════════════════
# Step 5: Display Configuration Summary
# ═══════════════════════════════════════════════════════════════════

echo "═══════════════════════════════════════════════════════════════"
echo "✅ Configuration Complete!"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "🌐 Your Local IP: $LOCAL_IP"
echo ""
echo "📋 Updated Files:"
echo ""
echo "   📄 client/.env"
echo "      → VITE_API_BASE_URL=http://localhost:8000"
echo ""
echo "   📄 backend/simple_backend/.env"
echo "      → CORS origins updated"
echo ""
echo "   📱 mobile/nurse_app/lib/config.dart"
echo "      → API Base URL updated"
echo ""

echo "🎯 Access Points:"
echo ""
echo "   Local Machine:"
echo "   • Frontend:  http://localhost:5173"
echo "   • Backend:   http://localhost:8000"
echo "   • API Docs:  http://localhost:8000/docs"
echo ""
echo "   Remote Access (from other devices):"
echo "   • Frontend:  http://$LOCAL_IP:5173"
echo "   • Backend:   http://$LOCAL_IP:8000"
echo "   • API Docs:  http://$LOCAL_IP:8000/docs"
echo "   • Mobile:    Configured to connect to http://$LOCAL_IP:8000"
echo ""

echo "⚠️  IMPORTANT: Add Your API Keys!"
echo ""
echo "   Edit: backend/simple_backend/.env"
echo ""
echo "   Add these (get from Google AI & Groq):"
echo "   • GEMINI_API_KEY=your_actual_key"
echo "   • GROQ_API_KEY=your_actual_key"
echo ""

echo "🚀 Ready to Start Development!"
echo ""
echo "   Run: mprocs"
echo ""
echo "═══════════════════════════════════════════════════════════════"
