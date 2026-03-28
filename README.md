# Medix AI

**AI-Powered Healthcare Documentation System for Primary Health Centers**

Medix AI automates patient intake, documentation, and medical analysis to help nurses and doctors work more efficiently. Built for primary health centers to reduce paperwork and improve patient care.

---

## 📁 **Project Structure**

```
.
├── client/                      # React web dashboard
│   ├── src/
│   │   ├── pages/               # Dashboard, Admin, Landing
│   │   ├── components/          # Reusable UI components
│   │   └── utils/               # API helpers, utilities
│   └── package.json
│
├── backend/                     # FastAPI Python backend
│   ├── simple_backend/
│   │   ├── main.py              # Application entry point
│   │   ├── models.py            # Data models (Pydantic)
│   │   ├── routes/              # API endpoints
│   │   │   ├── queue.py
│   │   │   ├── patients.py
│   │   │   └── uploads.py
│   │   ├── utils/               # Utilities
│   │   │   ├── ai_services.py   # Gemini & Groq integration
│   │   │   └── storage.py       # File storage
│   │   └── app/
│   │       ├── services/        # Business logic
│   │       └── models/          # MongoDB schemas
│   ├── requirements.txt
│   └── .env                     # Add API keys here
│
├── mobile/                      # Flutter nurse mobile app
│   └── nurse_app/
│       ├── lib/
│       │   ├── main.dart        # App entry point
│       │   ├── config.dart      # API & app configuration
│       │   └── core/            # Constants, theme, utilities
│       └── pubspec.yaml
│
└── docs/                        # Documentation
    ├── API_DOCUMENTATION.md
    └── QUICK_REFERENCE.md
```

---

## ⚡ **Quick Start**

### **Prerequisites**
- Docker & Docker Compose
- Node.js 18+ (for frontend)
- Python 3.10+ (for backend)
- API Keys: Google Gemini, Groq

### **Setup (3 Steps)**

```bash
# 1. Clone repository
git clone https://github.com/yourusername/medix-ai.git
cd medix-ai

# 2. Add environment variables and API keys
cd backend
cp .env.example .env  
# Edit .env with your API keys

# 3. Run all services
npm run dev
```

Access the dashboard at `http://localhost:3000`

---

## 🏗️ **Core Components**

| Component | Purpose | Tech Stack |
|-----------|---------|-----------|
| **Frontend** | Doctor dashboard for patient management | React, Vite, TailwindCSS |
| **Mobile App** | Nurse interface for patient intake | Flutter |
| **Backend API** | Patient records & AI processing | FastAPI, Python |
| **AI Engine** | Document analysis, timelines | Gemini, Groq |

---

## ✨ **Key Features**

**🎙️ Medix Listen** - Record patient symptoms via mobile app with AI transcription

**📄 Medix Scan** - Extract medical data from documents using AI OCR

**🔄 Medix Sync** - Real-time patient data sync across all platforms

**🗺️ Medix Map** - Visualize health patterns and outbreaks by region

---

## 📁 **Project Structure**

---

## 🔧 **Configuration**

### **Backend (.env)**

```
# Google Gemini API
GEMINI_API_KEY=your_key_here

# Groq API
GROQ_API_KEY=your_key_here

# Database
MONGODB_URI=mongodb+srv://user:password@cluster.mongodb.net/medix

# Server
API_PORT=8000
API_HOST=0.0.0.0
ENVIRONMENT=development
```

### **Mobile App**

Edit `mobile/nurse_app/lib/config.dart`:
```dart
const String apiBaseUrl = 'http://192.168.1.xxx:8000';
const String appName = 'Medix AI';
```

---

## 🚀 **Running Services**

### **Start Backend**
```bash
cd backend/simple_backend
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
python main.py
```

Backend runs on: `http://localhost:8000`

### **Start Frontend**
```bash
cd client
npm install
npm run dev
```

Frontend runs on: `http://localhost:3000`

### **Run Mobile App**
```bash
cd mobile/nurse_app
flutter pub get
flutter run
```

---

## 📖 **API Endpoints**

| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | `/queue/add` | Add patient to queue |
| GET | `/queue` | Get current patient queue |
| GET | `/patients` | List all patients |
| POST | `/timeline/generate` | Generate AI medical timeline |
| POST | `/upload` | Upload documents |

**Full API docs:** [API_DOCUMENTATION.md](backend/docs/API_DOCUMENTATION.md)

---

## ⚠️ **Troubleshooting**

**Frontend can't connect to backend?**
```bash
# Check if backend is running
curl http://localhost:8000/queue

# If not responding, verify:
# 1. Backend started: python main.py
# 2. Port 8000 is not in use
# 3. API URL correct in client/src/utils/api.js
```

**API Keys Not Working?**
```bash
# Test API keys
cd backend
python test-api-keys.py

# Verify .env file:
# - GEMINI_API_KEY is set
# - GROQ_API_KEY is set
# - No extra spaces or quotes
```

**Mobile App Won't Connect?**
- Ensure backend IP is correct in `config.dart`
- Run `flutter pub get` to get dependencies
- Check mobile device is on same network as backend

---

## 🔄 **Development Workflow**

1. **Make changes** to frontend, backend, or mobile code
2. **Restart services** (auto-reload in dev mode)
3. **Test API** using provided endpoints
4. **Check logs** for errors

### **Running Tests**

```bash
# Backend tests
cd backend/simple_backend
python -m pytest

# Test API keys
python test-api-keys.py
```

---

## 📦 **Tech Stack Summary**

- **Frontend:** React 18, Vite, TailwindCSS, Leaflet
- **Mobile:** Flutter, Dart
- **Backend:** FastAPI, Python 3.10+, Uvicorn
- **Database:** MongoDB, JSON (fallback)
- **AI:** Google Gemini API, Groq LLaMA
- **Deployment:** Docker, AWS (optional)

---

## 📝 **Next Steps**

- [ ] Deploy backend to AWS / Docker
- [ ] Deploy frontend to Vercel
- [ ] Connect production MongoDB Atlas
- [ ] Set up user authentication (JWT)
- [ ] Add role-based access control
- [ ] Integrate ABHA digital health records
- [ ] Add multi-language support
- [ ] Set up CI/CD pipeline

---

## 💡 **Key Concepts**

**Patient Queue** - Central place where nurses manage patients waiting to see doctors

**Timeline** - AI-generated medical history showing symptom progression

**Doctor Dashboard** - Real-time interface for doctors to review patient information before consultation

**Outbreak Map** - Regional visualization of disease patterns to help with health monitoring

---

## 📞 **Support & Documentation**

- **API Guide:** [API_DOCUMENTATION.md](backend/docs/API_DOCUMENTATION.md)
- **Local Testing:** [LOCAL_TESTING_GUIDE.md](backend/LOCAL_TESTING_GUIDE.md)
- **Setup Issues:** Check [backend/README.md](backend/README.md)

---

**Built with ❤️ for better healthcare**

Last Updated: 2024
