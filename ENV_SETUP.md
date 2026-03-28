# Environment Configuration Guide

## 🔧 Overview

This project requires environment variables for both the backend and frontend to work properly.

**Local IP:** `172.22.171.18`

---

## 📋 Backend Environment (backend/simple_backend/.env)

### Required Variables

```bash
# AI API Keys (REQUIRED - Must be set)
GEMINI_API_KEY=your_gemini_api_key_here
GROQ_API_KEY=your_groq_api_key_here
```

Get these from:
- **Gemini API:** https://ai.google.dev/
- **Groq API:** https://groq.com/

### Optional Variables

```bash
# Database Configuration (defaults to Docker environment)
MONGODB_URL=mongodb://admin:phc2024@mongodb:27017/phc?authSource=admin

# Backend Server Configuration
BACKEND_HOST=0.0.0.0
BACKEND_PORT=8000

# CORS Configuration (Allowed Origins)
CORS_ORIGINS=http://localhost:5173,http://localhost:3000,http://172.22.171.18:5173,http://172.22.171.18:3000
```

---

## 🎨 Frontend Environment (client/.env)

### Required Variables

```bash
# API Endpoint - Points to the backend
VITE_API_BASE_URL=http://172.22.171.18:8000
```

This URL should match your backend's IP and port.

### Optional Variables

```bash
# Environment
VITE_NODE_ENV=development

# Feature Flags
VITE_ENABLE_MAP=true
VITE_ENABLE_TIMELINE=true
```

---

## 🚀 Quick Setup

### 1. Update Backend Environment

Edit `backend/simple_backend/.env`:

```bash
GEMINI_API_KEY=sk-xxx...  # Your Gemini API key
GROQ_API_KEY=xxx...       # Your Groq API key
```

### 2. Frontend is Pre-configured

The frontend `.env` already points to IP `172.22.171.18:8000`

### 3. Start Development

```bash
mprocs
```

Both processes will auto-load their `.env` files via:
```bash
set -a && source .env && set +a
```

---

## 📡 Connection Architecture

```
┌─────────────┐                    ┌──────────────┐
│  Frontend   │ HTTP/REST Request  │  Backend API │
│ :5173       │────────────────────│ :8000        │
│             │                    │              │
│ Vite Dev    │  172.22.171.18     │  FastAPI     │
│ Server      │                    │  + uvicorn   │
└─────────────┘                    └──────────────┘
       ↓                                   ↓
   Browser                      - Gemini AI (vision)
                                - Groq Whisper
                                - MongoDB
```

---

## ✅ Verify Setup

### Check Backend

```bash
# Backend API should respond
curl http://172.22.171.18:8000/docs

# Or in browser: http://172.22.171.18:8000/docs
```

### Check Frontend

```bash
# Frontend should be accessible
# Browser: http://localhost:5173

# Or from another machine:
# http://172.22.171.18:5173
```

---

## 🔄 Environment Variables in mprocs

When `mprocs` starts each process, it will:

**Backend:**
```bash
cd backend/simple_backend && \
set -a && source .env && set +a && \
python3 -m uvicorn main:app --reload --port 8000 --host 0.0.0.0
```

**Frontend:**
```bash
cd client && \
set -a && source .env && set +a && \
pnpm run dev
```

The `set -a` command exports all variables so they're available to the child process.

---

## 🐛 Troubleshooting

### "API key not found" error

**Solution:** Add keys to `backend/simple_backend/.env`

### Frontend can't reach backend

**Solution:** Check `VITE_API_BASE_URL` in `client/.env`
- Should be: `http://172.22.171.18:8000`
- Not `http://localhost:8000` from another machine

### Changes to .env not reflected

**Solution:** Restart mprocs processes
- Press `x` to stop process
- Press `s` to start it again

---

## 📝 .env File Locations

```
swasya-ai/
├── backend/simple_backend/
│   └── .env              ← Backend environment
└── client/
    └── .env              ← Frontend environment
```

Both files need to exist for `mprocs` to properly load the configuration.
