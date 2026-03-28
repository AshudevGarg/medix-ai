# 🚀 Swasya AI - Setup Scripts

All scripts are located in the `scripts/` folder for easy project configuration.

---

## 📋 Available Scripts

### 1. `setup-all.sh` ⭐ **START HERE**
**Complete automated setup in one command**

```bash
bash scripts/setup-all.sh
```

This runs everything:
- ✅ Auto-detects your local IP
- ✅ Configures all environment files
- ✅ Helps set up API keys
- ✅ Installs dependencies

**Use this first!**

---

### 2. `setup-ip.sh`
**Auto-detects IP and configures environment files**

```bash
bash scripts/setup-ip.sh
```

What it does:
- 🔍 Detects your local IP address automatically
- 📝 Updates `client/.env` with correct API URL
- 🔧 Updates `backend/.env` with CORS origins
- 📋 Shows configuration summary

**Use when:** IP changes or you need to reconfigure

---

### 3. `setup-keys.sh`
**Interactive API keys setup**

```bash
bash scripts/setup-keys.sh
```

What it does:
- 🔑 Prompts for your GEMINI_API_KEY
- 🔑 Prompts for your GROQ_API_KEY
- 💾 Securely saves them to `.env` file
- ✅ Verifies configuration

**Use when:** You have API keys ready

---

### 4. `setup-mobile-ip.sh`
**Configure Flutter mobile app IP**

```bash
bash scripts/setup-mobile-ip.sh
```

What it does:
- 📱 Auto-detects your local IP
- 🔧 Updates `mobile/nurse_app/lib/config.dart`
- ✅ Configures mobile app to connect to backend

**Use when:** Setting up the mobile app

**Note:** This is automatically called by `setup-ip.sh`

---

## 🎯 Quick Start (Recommended)

### First Time Setup

```bash
# 1. Run the complete setup
bash scripts/setup-all.sh

# 2. Start development
mprocs

# 3. Run mobile app (in separate terminal)
cd mobile/nurse_app
flutter run
```

Done! Backend, frontend, and mobile app configured automatically.

---

### If Something Changes

If your IP changes or you need to reconfigure:

```bash
# Re-run IP detection (updates all: backend, frontend, mobile)
bash scripts/setup-ip.sh

# Or just update mobile app
bash scripts/setup-mobile-ip.sh

# Or if you want to change just API keys
bash scripts/setup-keys.sh
```

---

## 🔧 How IP Detection Works

The scripts use multiple methods to find your IP:

1. **`hostname -I`** (Linux/WSL) - Most reliable
2. **`ipconfig`** (Windows) - Windows fallback
3. **`ifconfig`** (macOS/Linux) - macOS fallback
4. **`127.0.0.1`** - Localhost fallback

The script automatically picks the best method for your system.

---

## 📝 What Gets Updated

### `client/.env`
```bash
# Before
VITE_API_BASE_URL=http://172.22.171.18:8000

# After (if your IP is 192.168.1.5)
VITE_API_BASE_URL=http://192.168.1.5:8000
```

### `backend/simple_backend/.env`
```bash
# CORS origins updated with your IP
CORS_ORIGINS=http://localhost:5173,http://192.168.1.5:5173,...
```

---

## ⚠️ Important Notes

### API Keys are Not Auto-Filled
You must provide your own:
- **Gemini API Key:** https://ai.google.dev/
- **Groq API Key:** https://groq.com/

The scripts prompt for these or show where to add them manually.

### Environment Variables
All scripts export variables with `export` keyword, so they're automatically available to child processes.

### Backups
Scripts create `.bak` backups before modifying files. These are cleaned up automatically.

---

## 🐛 Troubleshooting

### "IP not detected correctly"
The script falls back to `127.0.0.1`. Check manually:
```bash
hostname -I        # Linux/WSL
ipconfig          # Windows
ifconfig          # macOS
```

Then edit `client/.env` manually with the correct IP.

### "Permission denied"
Make scripts executable:
```bash
chmod +x scripts/*.sh
```

### "API keys still show placeholder"
Run the keys setup again:
```bash
bash scripts/setup-keys.sh
```

---

## 📋 Files Modified by Scripts

| File | Modified By | Purpose |
|------|-------------|---------|
| `client/.env` | `setup-ip.sh` | Frontend API URL |
| `backend/simple_backend/.env` | `setup-ip.sh`, `setup-keys.sh` | Backend config & keys |
| `mobile/nurse_app/lib/config.dart` | `setup-ip.sh`, `setup-mobile-ip.sh` | Mobile app API URL |
| `client/node_modules/` | `setup-all.sh` | Dependencies |
| `backend/simple_backend/venv/` | `setup-all.sh` | Python environment |

---

## 📱 Mobile App Setup

For detailed mobile app configuration and usage, see [MOBILE_APP_SETUP.md](../MOBILE_APP_SETUP.md)

Key points:
- Mobile app auto-updates via `setup-ip.sh`
- For physical device: Uses detected IP
- For Android emulator: Change config to `10.0.2.2:8000`
- For iOS simulator: Change config to `localhost:8000`

---


## 🔗 Related Documentation

- **Full Setup Guide:** [API_KEYS_SETUP.md](../API_KEYS_SETUP.md)
- **Environment Variables:** [ENV_SETUP.md](../ENV_SETUP.md)
- **Main README:** [README.md](../README.md)

---

## 💡 Pro Tips

### Re-run setup without prompts
```bash
# Just IP setup
bash scripts/setup-ip.sh

# Just keys setup
bash scripts/setup-keys.sh
```

### Check current configuration
```bash
# View frontend config
cat client/.env

# View backend config
cat backend/simple_backend/.env
```

### Debug IP detection
```bash
# Add verbose output to scripts
bash -x scripts/setup-ip.sh
```

---

## 📞 Need Help?

1. Check error messages - they explain what went wrong
2. Review [API_KEYS_SETUP.md](../API_KEYS_SETUP.md) for detailed guide
3. Verify files exist:
   - `client/.env`
   - `backend/simple_backend/.env`

Happy coding! 🚀
