#!/bin/bash
# Complete setup script for Swasya AI project
# Handles both frontend (pnpm) and backend (Python) setup

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
echo "🚀 Setting up Swasya AI Project"
echo "📁 Project root: $PROJECT_ROOT"
echo ""

# Backend setup
echo "📦 Backend Setup..."
cd "$PROJECT_ROOT/backend/simple_backend"

if [ ! -d "venv" ]; then
  echo "  Creating Python virtual environment..."
  python -m venv venv
fi

echo "  Activating venv..."
. venv/bin/activate

echo "  Installing Python dependencies..."
pip install --break-system-packages -q --upgrade pip setuptools wheel
pip install --break-system-packages -q -r requirements.txt
echo "  ✅ Backend ready"
echo ""

# Frontend setup
echo "📦 Frontend Setup..."
cd "$PROJECT_ROOT/client"

if [ ! -d "node_modules" ]; then
  echo "  Installing pnpm dependencies..."
  pnpm install
else
  echo "  node_modules already exists"
fi
echo "  ✅ Frontend ready"
echo ""

# Show summary
cd "$PROJECT_ROOT"
echo "═══════════════════════════════════════════"
echo "✅ Setup Complete!"
echo "═══════════════════════════════════════════"
echo ""
echo "🎯 To start development:"
echo "   mprocs"
echo ""
echo "📊 Processes will start:"
echo "   • backend:  FastAPI on http://localhost:8000"
echo "   • frontend: Vite dev server on http://localhost:5173"
echo "   • mobile:   Flutter (manual start with 's' key)"
echo ""
echo "🎮 mprocs controls:"
echo "   q        - Quit"
echo "   k/j      - Select process"
echo "   s        - Start process"
echo "   x        - Stop process"
echo "   C-a      - Toggle focus"
echo "   <C-a>: { c: All commands }"
