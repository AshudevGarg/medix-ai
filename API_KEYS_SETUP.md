# 🚀 Complete Setup Guide - Add API Keys

## Current Status ✅
- ✅ Backend structure ready
- ✅ Frontend ready  
- ✅ mprocs configured
- ❌ **API Keys needed** ← YOU ARE HERE

---

## 🔑 Step 1: Get API Keys (5 minutes)

### A. Gemini API Key
1. Go to: https://ai.google.dev/
2. Click "Get API Key" button
3. Select or create a Google Cloud project
4. Copy the API key

### B. Groq API Key  
1. Go to: https://groq.com/
2. Sign up or login
3. Navigate to "Keys" in your account settings
4. Create a new key and copy it

---

## ✏️ Step 2: Update .env Files

### Backend Environment (`backend/simple_backend/.env`)

Find this line:
```bash
export GEMINI_API_KEY=your_gemini_api_key_here
```

Replace with:
```bash
export GEMINI_API_KEY=sk-proj-xxxxxxxxxxxxxxxxxxxx
```

Find this line:
```bash
export GROQ_API_KEY=your_groq_api_key_here
```

Replace with:
```bash
export GROQ_API_KEY=gsk_xxxxxxxxxxxxxxxxxx
```

**Frontend is already configured** ✅
- File: `client/.env`
- Already points to: `http://172.22.171.18:8000`

---

## 🎯 Step 3: Start Development

### Option A: Using mprocs (Recommended)
```bash
mprocs
```

Both backend and frontend will start and auto-reload files.

### Option B: Manual Start

Backend:
```bash
cd backend/simple_backend
source .env
python3 -m uvicorn main:app --reload --port 8000
```

Frontend:  
```bash
cd client
source .env
pnpm run dev
```

---

## 🌐 Access Your App

After starting, you can access:

### Local Access
- **Frontend:** http://localhost:5173
- **Backend API:** http://localhost:8000
- **API Docs:** http://localhost:8000/docs

### Remote Access (from other devices)
- **Frontend:** http://172.22.171.18:5173
- **Backend API:** http://172.22.171.18:8000
- **API Docs:** http://172.22.171.18:8000/docs

---

## ✅ Verify Everything Works

### Check Backend is Running
```bash
# Should return API documentation
curl http://172.22.171.18:8000/docs
```

### Check Frontend is Running
```bash
# Should return the React app
curl http://localhost:5173
```

### Check Connection
The frontend should be able to connect to the backend API.

---

## 🎮 mprocs Quick Reference

| Key | Action |
|-----|--------|
| `q` | Quit all processes |
| `Q` | Force quit |
| `k` or `↑` | Previous process |
| `j` or `↓` | Next process |
| `s` | Start selected process |
| `x` | Stop selected process (send SIGTERM) |
| `X` | Force kill (send SIGKILL) |
| `r` | Restart selected process |
| `<C-a>` | Toggle between process list and output |
| `v` | Enter copy mode (copy terminal output) |

---

## 🐛 Troubleshooting

### Error: "GEMINI_API_KEY not found"
**Solution:** Add your actual API key to `backend/simple_backend/.env`

### Error: "Cannot connect to backend"
1. Check `.env` file has the correct IP: `172.22.171.18`
2. Restart mprocs with `q` then `mprocs` again
3. Verify backend is running (check mprocs output)

### Error: "vite not found" or "pnpm not found"
1. Make sure you ran: `pnpm install` in `client/` folder
2. Restart mprocs

### Ports already in use
- Backend: Change port in mprocs: `--port 8001`
- Frontend: Vite will auto-increment port if 5173 is busy

---

## 📁 File Structure

```
swasya-ai/
├── backend/simple_backend/
│   ├── .env                ← Add your API keys here! 🔑
│   ├── main.py
│   ├── requirements.txt
│   └── ...
├── client/
│   ├── .env               ← Pre-configured ✅
│   ├── src/
│   └── ...
├── mprocs.yaml           ← Configured ✅
└── ENV_SETUP.md          ← Full documentation
```

---

## ❓ Questions?

Check [ENV_SETUP.md](ENV_SETUP.md) for detailed environment configuration documentation.
