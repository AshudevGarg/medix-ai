#!/bin/bash
# Frontend startup script - sources .env and starts vite dev server

cd "$(dirname "$0")"

echo "📦 Loading frontend environment..."
if [ -f ".env" ]; then
  # Source the .env file
  . ./.env
  echo "✅ Environment loaded"
else
  echo "⚠️  Warning: .env file not found"
fi

echo "🚀 Starting Vite dev server..."
exec pnpm run dev
