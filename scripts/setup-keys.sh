#!/bin/bash
# 🔑 Swasya AI - API Keys Setup Helper
# This script helps you add your API keys securely

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_ROOT"

echo "═══════════════════════════════════════════════════════════════"
echo "🔑 Swasya AI - API Keys Setup"
echo "═══════════════════════════════════════════════════════════════"
echo ""

BACKEND_ENV="backend/simple_backend/.env"

# Check if .env exists
if [ ! -f "$BACKEND_ENV" ]; then
  echo "❌ Error: $BACKEND_ENV not found!"
  echo "   Please run: scripts/setup-ip.sh first"
  exit 1
fi

echo "📋 This script will help you add your API keys."
echo ""
echo "You will need 2 API keys:"
echo ""
echo "1. GEMINI_API_KEY"
echo "   Get from: https://ai.google.dev/"
echo ""
echo "2. GROQ_API_KEY"
echo "   Get from: https://groq.com/"
echo ""

# Prompt for keys
read -p "Enter GEMINI_API_KEY (or press Enter to skip): " GEMINI_KEY
read -p "Enter GROQ_API_KEY (or press Enter to skip): " GROQ_KEY

echo ""
echo "⏳ Updating .env file..."

# Update GEMINI_API_KEY
if [ ! -z "$GEMINI_KEY" ]; then
  # Escape special characters in the key
  ESCAPED_GEMINI=$(printf '%s\n' "$GEMINI_KEY" | sed -e 's/[\/&]/\\&/g')
  sed -i.bak "s|export GEMINI_API_KEY=.*|export GEMINI_API_KEY=$ESCAPED_GEMINI|g" "$BACKEND_ENV"
  echo "   ✅ GEMINI_API_KEY updated"
fi

# Update GROQ_API_KEY
if [ ! -z "$GROQ_KEY" ]; then
  # Escape special characters in the key
  ESCAPED_GROQ=$(printf '%s\n' "$GROQ_KEY" | sed -e 's/[\/&]/\\&/g')
  sed -i.bak "s|export GROQ_API_KEY=.*|export GROQ_API_KEY=$ESCAPED_GROQ|g" "$BACKEND_ENV"
  echo "   ✅ GROQ_API_KEY updated"
fi

rm -f "$BACKEND_ENV.bak"

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "✅ API Keys Configured!"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "🚀 Ready to start development!"
echo ""
echo "   Run: mprocs"
echo ""
