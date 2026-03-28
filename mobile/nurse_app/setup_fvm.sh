#!/bin/bash
# Setup FVM and configure Flutter version for the project

echo "📦 Installing FVM globally..."

# Try npm install first
npm install -g fvm@latest 2>/dev/null || {
  echo "📥 Downloading FVM directly..."
  # Alternative: Use pubspec approach in a temporary directory
  mkdir -p ~/.fvm_install
  cd ~/.fvm_install
  dart pub global activate fvm
}

echo "✅ FVM installed"

# Navigate to mobile app
cd "$(dirname "$0")"
echo "🔧 Installing Flutter 3.41.6..."
fvm install 3.41.6

echo "📌 Setting Flutter version for this project..."
fvm use 3.41.6

# Verify version
echo "✅ Current Flutter version:"
$(fvm which flutter) --version

echo ""
echo "🎯 To use FVM-managed Flutter in this project:"
echo "   fvm flutter run"
echo ""
echo "Or configure your IDE to use: $(fvm which flutter)"
