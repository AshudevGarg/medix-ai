#!/bin/bash
# ✅ Swasya AI - Verification Script
# Checks if everything is configured correctly

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_ROOT"

echo "═══════════════════════════════════════════════════════════════"
echo "✅ Swasya AI - Configuration Verification"
echo "═══════════════════════════════════════════════════════════════"
echo ""

STATUS_OK=0
WARNINGS=0
ERRORS=0

# ===================================================================
# Check Backend Environment
# ===================================================================

echo "🔍 Checking backend configuration..."
echo ""

BACKEND_ENV="backend/simple_backend/.env"

if [ ! -f "$BACKEND_ENV" ]; then
  echo "❌ ERROR: $BACKEND_ENV not found!"
  ((ERRORS++))
else
  echo "✅ Found: $BACKEND_ENV"
  
  if grep -q "GEMINI_API_KEY=your_gemini_api_key_here" "$BACKEND_ENV" 2>/dev/null; then
    echo "⚠️  WARNING: GEMINI_API_KEY is placeholder value"
    ((WARNINGS++))
  elif grep -q "export GEMINI_API_KEY=" "$BACKEND_ENV"; then
    echo "✅ GEMINI_API_KEY: Configured"
  fi
  
  if grep -q "GROQ_API_KEY=your_groq_api_key_here" "$BACKEND_ENV" 2>/dev/null; then
    echo "⚠️  WARNING: GROQ_API_KEY is placeholder value"
    ((WARNINGS++))
  elif grep -q "export GROQ_API_KEY=" "$BACKEND_ENV"; then
    echo "✅ GROQ_API_KEY: Configured"
  fi
  
  if grep -q "CORS_ORIGINS=" "$BACKEND_ENV"; then
    CORS=$(grep "CORS_ORIGINS=" "$BACKEND_ENV" | cut -d= -f2)
    echo "✅ CORS_ORIGINS: $CORS"
  fi
fi

echo ""

# ===================================================================
# Check Frontend Environment
# ===================================================================

echo "🔍 Checking frontend configuration..."
echo ""

FRONTEND_ENV="client/.env"

if [ ! -f "$FRONTEND_ENV" ]; then
  echo "❌ ERROR: $FRONTEND_ENV not found!"
  ((ERRORS++))
else
  echo "✅ Found: $FRONTEND_ENV"
  
  if grep -q "VITE_API_BASE_URL=" "$FRONTEND_ENV"; then
    API_URL=$(grep "VITE_API_BASE_URL=" "$FRONTEND_ENV" | cut -d= -f2)
    echo "✅ VITE_API_BASE_URL: $API_URL"
  else
    echo "❌ ERROR: VITE_API_BASE_URL not found!"
    ((ERRORS++))
  fi
  
  if grep -q "VITE_NODE_ENV=" "$FRONTEND_ENV"; then
    NODE_ENV=$(grep "VITE_NODE_ENV=" "$FRONTEND_ENV" | cut -d= -f2)
    echo "✅ VITE_NODE_ENV: $NODE_ENV"
  fi
fi

echo ""

# ===================================================================
# Check Dependencies
# ===================================================================

echo "🔍 Checking dependencies..."
echo ""

if [ -d "client/node_modules" ]; then
  echo "✅ Frontend dependencies installed (node_modules found)"
else
  echo "❌ ERROR: Frontend dependencies not installed!"
  echo "   Run: pnpm install (in client/ folder)"
  ((ERRORS++))
fi

if [ -d "backend/simple_backend/venv" ]; then
  echo "✅ Backend venv created"
else
  echo "❌ ERROR: Backend venv not found!"
  echo "   Run: python3 -m venv backend/simple_backend/venv"
  ((ERRORS++))
fi

echo ""

# ===================================================================
# Check Tools
# ===================================================================

echo "🔍 Checking required tools..."
echo ""

if command -v mprocs &> /dev/null; then
  MPROCS_V=$(mprocs --version)
  echo "✅ mprocs: $MPROCS_V"
else
  echo "⚠️  WARNING: mprocs not found in PATH"
  ((WARNINGS++))
fi

if command -v pnpm &> /dev/null; then
  PNPM_V=$(pnpm --version)
  echo "✅ pnpm: $PNPM_V"
else
  echo "⚠️  WARNING: pnpm not found in PATH"
  ((WARNINGS++))
fi

if command -v python3 &> /dev/null; then
  PYTHON_V=$(python3 --version)
  echo "✅ python3: $PYTHON_V"
else
  echo "❌ ERROR: python3 not found!"
  ((ERRORS++))
fi

echo ""

# ===================================================================
# Final Summary
# ===================================================================

echo "═══════════════════════════════════════════════════════════════"
echo "📊 Verification Summary"
echo "═══════════════════════════════════════════════════════════════"
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
  echo "🎉 Everything is configured correctly!"
  echo ""
  echo "🚀 You can now run: mprocs"
  echo ""
elif [ $ERRORS -eq 0 ]; then
  echo "✅ All critical components are OK"
  echo "⚠️  $WARNINGS warning(s) - Review above"
  echo ""
  echo "🚀 You can run: mprocs (but check warnings first)"
  echo ""
else
  echo "❌ $ERRORS ERROR(S) found - Fix before running mprocs"
  echo "⚠️  $WARNINGS warning(s)"
  echo ""
  echo "Run: bash scripts/setup-all.sh (to fix errors)"
  echo ""
fi

# Return appropriate exit code
if [ $ERRORS -gt 0 ]; then
  exit 1
elif [ $WARNINGS -gt 0 ]; then
  exit 0
else
  exit 0
fi
