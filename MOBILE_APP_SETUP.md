# 📱 Flutter Mobile App - IP Configuration Guide

## Overview

The Flutter mobile app now has **automatic IP configuration** integrated with your setup scripts. When you run `setup-ip.sh`, it automatically updates your mobile app to connect to the backend using the correct local IP address.

## Architecture

```
┌─────────────────────────────────────────────┐
│      setup-ip.sh (Master Setup)             │
├────────────┬────────────┬──────────────────┤
│            │            │                  │
Call         Call         Call               │
scripts      scripts      scripts             │
setup for    setup for    setup for          │
backend      frontend     mobile             │
│            │            │                  │
▼            ▼            ▼                  ▼
Backend      Frontend     Mobile App         All pointing
.env         .env         config.dart        to same IP!
Updated      Updated      Updated
```

## 🔧 Configuration Files

### 1. Mobile App Config (Auto-Updated)
**File:** `mobile/nurse_app/lib/config.dart`

```dart
static const String apiBaseUrl = 'http://172.22.171.18:8000';
```

**What it includes:**
- API Base URL (with autodetected IP)
- Patient endpoints
- Queue endpoints  
- Upload endpoints
- All other API references

### 2. Backend Configuration
**File:** `backend/simple_backend/.env`

```
GEMINI_API_KEY=...
GROQ_API_KEY=...
MONGODB_URL=: mongodb+srv://... (your MongoDB connection)
CORS_ORIGINS=http://192.168.1.228:5173,http://172.22.171.18:8000,...
```

### 3. Frontend Configuration  
**File:** `client/.env`

```
VITE_API_BASE_URL=http://172.22.171.18:8000
```

## 🚀 Setup Process

### Automatic Setup (Recommended)

```bash
# Run once to configure everything
bash scripts/setup-ip.sh

# This automatically:
# 1. Detects your local IP
# 2. Updates backend .env (CORS origins)
# 3. Updates frontend .env (API URL)
# 4. Updates mobile app config.dart (API URL)
```

### Manual Mobile Setup Only

If you just want to update the mobile app:

```bash
bash scripts/setup-mobile-ip.sh
```

## 🎯 IP Detection

The setup scripts use multiple methods to find your IP:

1. **Linux/WSL:** `hostname -I`
2. **macOS/Linux:** `ifconfig`
3. **Windows:** `ipconfig`
4. **Fallback:** `127.0.0.1` if all methods fail

**Detected IP is used for:**
- ✅ Backend CORS configuration
- ✅ Frontend API base URL
- ✅ Mobile app API base URL

## 📱 Running the Mobile App

### Prerequisites
- Flutter SDK installed
- Physical device or emulator running
- Backend server running on `http://{YOUR_IP}:8000`

### Development Device Types

**For Real Physical Device:**
- Uses detected IP (e.g., `http://172.22.171.18:8000`)
- Config already set correctly ✅

**For Android Emulator:**
- Change `config.dart` line 8 to:
  ```dart
  static const String apiBaseUrl = 'http://10.0.2.2:8000';
  ```

**For iOS Simulator:**
- Change `config.dart` line 8 to:
  ```dart
  static const String apiBaseUrl = 'http://localhost:8000';
  ```

### Start the App

```bash
cd mobile/nurse_app

# For physical device
flutter run -d <device_id>

# For emulator (auto-detected)
flutter run

# With hot reload
flutter run --hot
```

## ✅ Verification

### Check if Configuration is Correct

```bash
# View current mobile app config
cat mobile/nurse_app/lib/config.dart | grep apiBaseUrl

# View backend CORS (mobile should be in this list)
grep CORS_ORIGINS backend/simple_backend/.env

# View frontend config
cat client/.env | grep VITE_API_BASE_URL
```

### Test API Connection

Once app is running, test endpoints:

```bash
# Check if backend is accessible from mobile device
curl http://172.22.171.18:8000/patients

# Check API docs
curl http://172.22.171.18:8000/docs
```

## 🔄 When IP Changes

If you move to a different network or restart your computer:

```bash
# Re-run setup to detect new IP
bash scripts/setup-ip.sh

# Then in Flutter:
# 1. Restart app: `flutter run` + `R`
# 2. Or full rebuild: `flutter run --release`
```

## ⚠️ Troubleshooting

### Mobile App Can't Connect to Backend

**Problem:** `Connection refused` or `Failed to connect`

**Fixes:**
1. Check backend is running: `mprocs`
2. Verify IP in `config.dart` matches your network
3. For emulator, ensure using `10.0.2.2` not `127.0.0.1`
4. Check firewall allows port 8000

### IP Detection Failed

**Problem:** `Could not detect IP address`

**Fix:** Manually update `config.dart`:
```dart
static const String apiBaseUrl = 'http://<YOUR_IP>:8000';
```

Find your IP:
```bash
# Linux/WSL
hostname -I

# macOS
ifconfig | grep "inet "

# Windows
ipconfig
```

### Hot Reload Not Working

Add hot reload support by running:
```bash
flutter clean
flutter pub get
flutter run --hot
```

## 📚 Related Documentation

- [Backend Setup](../backend/README.md)
- [Frontend Setup](../client/README.md)
- [API Documentation](../docs/API_DOCUMENTATION.md)
- [Deployment Guide](../docs/DEPLOYMENT.md)

## 🎉 Complete Setup Checklist

- ✅ Run `bash scripts/setup-ip.sh`
- ✅ Verify API keys in `backend/simple_backend/.env`
- ✅ Start backend: `mprocs`
- ✅ Verify `mobile/nurse_app/lib/config.dart` has correct IP
- ✅ Build & run Flutter app: `flutter run`
- ✅ Test API calls from mobile app

## 💡 Tips

- **For development:** Use physical device on same WiFi as backend
- **For testing:** Use Android emulator with `10.0.2.2` special IP
- **For production:** Use domain name instead of IP in config
- **For debugging:** Enable logging in Flutter to see API calls

---

**Last Updated:** March 28, 2026  
**Version:** 3.0.0
