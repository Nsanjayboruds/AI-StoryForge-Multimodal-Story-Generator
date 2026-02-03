# AI-StoryForge: Multimodal Story Generator ✨📖🎨

An AI-powered multimodal story and image generator built using **React (frontend)** and **Node.js/Express (backend)** for generating unique, creative stories and illustrations from user prompts. Powered by Groq AI, HuggingFace Stable Diffusion, and MongoDB for user management.

**🔬 Testing with Keploy:** This project uses [Keploy](https://keploy.io) for automated API testing with built-in mocking of external APIs and database interactions.

---

## 🚀 Key Features

✨ **Story Generation**
- Generate unique, creative stories in seconds
- Powered by **Groq AI (LLaMA 3)** for ultra-fast inference
- Support for multiple story genres and styles

🎨 **Image Generation**
- Generate AI-powered illustrations
- Powered by **HuggingFace Stable Diffusion**
- Integrated with Replicate API

👤 **User Management**
- User registration and authentication (JWT)
- MongoDB database for persistent storage
- Secure password hashing with bcryptjs

🧪 **Automated Testing**
- Keploy integration for API testing
- Automatic test generation from API traffic
- Built-in mocking for external APIs
- MongoDB query recording and replay

---

## 🛠️ Tech Stack

### Frontend:
- **React** - UI framework
- **Vite** - Fast build tool
- **Tailwind CSS** - Styling

### Backend:
- **Node.js** - Runtime
- **Express v5.1.0** - Web framework
- **MongoDB** - Database
- **Groq AI API** - Story generation (LLaMA 3)
- **HuggingFace** - Image generation (Stable Diffusion)
- **JWT** - Authentication
- **bcryptjs** - Password hashing

### Testing:
- **Keploy 3.3.10** - API testing & mocking
- **Docker** - Containerization
- **Docker Compose** - Multi-service orchestration

---

## 📋 Prerequisites

- **Node.js** v18+ (verify with `node --version`)
- **MongoDB** running locally or connection string
- **npm** or **yarn** package manager
- **Keploy** (optional, for testing)

---

## ⚙️ Environment Setup

### 1. Create `.env` file in the backend directory:

```bash
cd backend
```

Create a `.env` file with:

```env
# MongoDB Configuration
MONGO_URI=mongodb://localhost:27017/storyforge

# JWT Configuration
JWT_SECRET=your_super_secret_jwt_key_change_this_in_production

# API Keys
GROQ_API_KEY=your_groq_api_key_here
HUGGINGFACE_API_TOKEN=your_huggingface_token_here
REPLICATE_API_TOKEN=your_replicate_token_here

# Server Configuration
PORT=5000
NODE_ENV=development
```

**⚠️ Important:** Get your API keys from:
- [Groq Console](https://console.groq.com) - Free LLaMA API access
- [HuggingFace](https://huggingface.co/settings/tokens) - Image generation
- [Replicate](https://replicate.com/account/api-tokens) - Alternative image generation

---

## 🚀 Quick Start

### Step 1: Start MongoDB

```bash
# Option A: If MongoDB is installed locally
sudo systemctl start mongod

# Option B: Using Docker
docker run -d -p 27017:27017 --name mongodb mongo:latest
```

### Step 2: Install Dependencies

```bash
# Install backend dependencies
cd backend
npm install

# Install frontend dependencies
cd ../frontend
npm install
```

### Step 3: Run Backend

```bash
cd backend
npm run dev
```

You should see:
```
✅ Connected to MongoDB
🚀 Server running on http://localhost:5000
```

### Step 4: Run Frontend

```bash
cd frontend
npm run dev
```

The app will be available at `http://localhost:5173`

---

## 🧪 Testing with Keploy

### What is Keploy?

Keploy is an automated API testing tool that:
- Records actual API traffic and converts it to test cases
- Automatically mocks external APIs (Groq, HuggingFace, Replicate)
- Records and replays MongoDB queries
- Generates test reports with coverage metrics

### Quick Setup

#### 1. Install Keploy

```bash
# For Linux/macOS
curl --silent --location "https://github.com/keploy/keploy/releases/latest/download/keploy_linux_amd64.tar.gz" | tar xz -C /tmp
sudo mkdir -p /usr/local/bin && sudo mv /tmp/keploy /usr/local/bin
keploy --version  # Should print: Keploy 3.3.10
```

#### 2. Verify Setup

```bash
cd backend
./test-keploy-setup.sh
```

You should see all checks passing ✅

#### 3. Record Test Cases

**Terminal 1 - Start Recording:**
```bash
cd backend
npm run keploy:record
```

**Terminal 2 - Generate Test Traffic:**
```bash
cd backend
./keploy-test.sh generate
```

Or manually test endpoints:
```bash
# Test root endpoint
curl http://localhost:5000/

# Test signup
curl -X POST http://localhost:5000/api/signup \
  -H "Content-Type: application/json" \
  -d '{"email":"demo@example.com","password":"Demo123!"}'

# Test login
curl -X POST http://localhost:5000/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"demo@example.com","password":"Demo123!"}'

# Test story generation
curl -X POST http://localhost:5000/api/ai \
  -H "Content-Type: application/json" \
  -d '{"prompt":"Write a short sci-fi story","model":"llama3-8b-8192"}'

# Test image generation
curl -X POST http://localhost:5000/api/image \
  -H "Content-Type: application/json" \
  -d '{"prompt":"A magical forest with glowing trees"}'
```

Press `Ctrl+C` in Terminal 1 to stop recording. Tests are saved in `backend/keploy/tests/`

#### 4. Run Tests

```bash
cd backend
npm run keploy:test
```

View results:
```
📊 Test Summary
✅ test-1-root.yaml: PASSED
✅ test-2-signup.yaml: PASSED
✅ test-3-login.yaml: PASSED
✅ test-4-ai-story.yaml: PASSED
✅ test-5-image.yaml: PASSED
```

#### 5. Run Tests with Coverage

```bash
cd backend
npm run keploy:test:coverage
```

---

## 📚 Available Commands

### Backend

```bash
cd backend

# Development (with auto-reload)
npm run dev

# Start production server
npm start

# Record Keploy tests
npm run keploy:record

# Run Keploy tests
npm run keploy:test

# Run tests with coverage report
npm run keploy:test:coverage
```

### Frontend

```bash
cd frontend

# Development server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview

# Run ESLint
npm run lint
```

---

## 📁 Project Structure

```
AI-StoryForge-Multimodal-Story-Generator/
├── backend/
│   ├── index.js                 # Main server file
│   ├── model/
│   │   └── User.js             # MongoDB User schema
│   ├── keploy/
│   │   ├── tests/              # Recorded test cases
│   │   │   └── test-set-0/
│   │   │       ├── test-1-root.yaml
│   │   │       ├── test-2-signup.yaml
│   │   │       ├── test-3-login.yaml
│   │   │       ├── test-4-ai-story.yaml
│   │   │       └── test-5-image.yaml
│   │   └── mocks/              # API mock responses
│   ├── keploy.yml              # Keploy configuration
│   ├── package.json
│   ├── .env                    # Environment variables (git ignored)
│   └── KEPLOY_TESTING.md       # Detailed Keploy guide
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   │   ├── Login.jsx
│   │   │   ├── Signup.jsx
│   │   │   ├── StoryGenerator.jsx
│   │   │   ├── ProtectedRoute.jsx
│   │   │   └── Navbar.jsx
│   │   ├── context/
│   │   │   └── AuthContext.jsx
│   │   ├── App.jsx
│   │   └── main.jsx
│   ├── package.json
│   └── vite.config.js
└── README.md
```

---

## 🔌 API Endpoints

### Authentication
- `POST /api/signup` - Register new user
- `POST /api/login` - User login, returns JWT token

### Story Generation
- `POST /api/ai` - Generate story
  - Request: `{"prompt": "your story prompt", "model": "llama3-8b-8192"}`
  - Response: `{"response": "generated story...", "usage": {...}}`

### Image Generation
- `POST /api/image` - Generate image
  - Request: `{"prompt": "your image description"}`
  - Response: `{"imageUrl": "data:image/png;base64,..."}`

### Health
- `GET /` - Server status check

---

## 🐛 Troubleshooting

### MongoDB Connection Error

```
❌ MongoDB connection error
```

**Solution:** Ensure MongoDB is running
```bash
# Start MongoDB
sudo systemctl start mongod

# Or using Docker
docker run -d -p 27017:27017 mongo:latest
```

### Keploy Recording Not Working

```
Error: Please check your firewall rules...
```

**Solution:** Run with elevated privileges
```bash
sudo keploy record -c "node index.js"
```

### API Key Errors

```
❌ GROQ_API_KEY is not configured
```

**Solution:** Add API keys to `.env` file
```bash
# Get keys from:
# - Groq: https://console.groq.com
# - HuggingFace: https://huggingface.co/settings/tokens
```

---

## 📖 Documentation

- **[Keploy Testing Guide](backend/KEPLOY_TESTING.md)** - Comprehensive testing documentation
- **[Keploy Official Docs](https://docs.keploy.io)** - Full Keploy documentation
- **[Groq API Docs](https://console.groq.com/docs)** - Groq API reference
- **[HuggingFace API Docs](https://huggingface.co/docs/inference-api) - Image generation**

---

## 🤝 Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### When adding new features:
- Write code following the existing patterns
- Record Keploy test cases for new endpoints
- Update documentation if needed
- Test with `npm run keploy:test`

---

## 📄 License

This project is open source and available under the MIT License.

---

## 🙏 Acknowledgments

- **Groq** - For the amazing LLaMA API
- **HuggingFace** - For image generation capabilities
- **Keploy** - For the automated testing framework
- **MongoDB** - For the database
- All contributors and users who support this project

---

## 💬 Questions or Feedback?

Feel free to open an issue or reach out on:
- GitHub Issues: [Create an issue](https://github.com/Nsanjayboruds/AI-StoryForge-Multimodal-Story-Generator/issues)
- GitHub Discussions: [Start a discussion](https://github.com/Nsanjayboruds/AI-StoryForge-Multimodal-Story-Generator/discussions)

Happy story generating! 🚀✨
