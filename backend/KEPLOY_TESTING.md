# 🧪 Keploy Testing Guide for AI-StoryForge Backend

This guide explains how to use Keploy for automated API testing in the AI-StoryForge project.

## 📋 Table of Contents
- [What is Keploy?](#what-is-keploy)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Recording Test Cases](#recording-test-cases)
- [Running Tests](#running-tests)
- [Docker Setup](#docker-setup)
- [Understanding Test Results](#understanding-test-results)
- [Best Practices](#best-practices)

## 🎯 What is Keploy?

Keploy is an API testing toolkit that automatically generates test cases by recording actual API traffic. It captures:
- HTTP requests and responses
- Database queries and results
- External API calls
- And replays them as tests

## 📦 Installation

### Option 1: Native Installation (Linux/macOS)

```bash
# Install Keploy CLI
curl --silent --location "https://github.com/keploy/keploy/releases/latest/download/keploy_linux_amd64.tar.gz" | tar xz -C /tmp
sudo mkdir -p /usr/local/bin && sudo mv /tmp/keploy /usr/local/bin && keploy

# Verify installation
keploy --version
```

### Option 2: Using Docker

```bash
# Pull the Keploy Docker image
docker pull ghcr.io/keploy/keploy:latest
```

## 🚀 Quick Start

### 1. Set Up Environment Variables

Ensure your `.env` file in the backend directory has all required variables:

```env
# MongoDB
MONGO_URI=mongodb://localhost:27017/storyforge

# JWT
JWT_SECRET=your_jwt_secret_here

# API Keys
GROQ_API_KEY=your_groq_api_key
HUGGINGFACE_API_TOKEN=your_huggingface_token
REPLICATE_API_TOKEN=your_replicate_token
```

### 2. Start MongoDB

```bash
# Make sure MongoDB is running
sudo systemctl start mongod
# or using Docker
docker run -d -p 27017:27017 mongo:latest
```

## 📹 Recording Test Cases

### Method 1: Using npm scripts

```bash
cd backend

# Start recording mode
npm run keploy:record
```

### Method 2: Using Keploy CLI directly

```bash
cd backend

# Start Keploy in record mode
keploy record -c "node index.js"
```

### 3. Generate Traffic

Once recording, interact with your API to create test cases:

#### Test Signup
```bash
curl -X POST http://localhost:5000/api/signup \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "TestPass123"}'
```

#### Test Login
```bash
curl -X POST http://localhost:5000/api/login \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "TestPass123"}'
```

#### Test AI Story Generation
```bash
curl -X POST http://localhost:5000/api/ai \
  -H "Content-Type: application/json" \
  -d '{"prompt": "Write a short story about a brave knight", "model": "llama3-8b-8192"}'
```

#### Test Image Generation
```bash
curl -X POST http://localhost:5000/api/image \
  -H "Content-Type: application/json" \
  -d '{"prompt": "A magical castle in the clouds"}'
```

#### Test Root Endpoint
```bash
curl http://localhost:5000/
```

### 4. Stop Recording

Press `Ctrl+C` to stop recording. Test cases will be saved in `./keploy/tests/` directory.

## ✅ Running Tests

### Method 1: Using npm scripts

```bash
cd backend

# Run all recorded tests
npm run keploy:test

# Run tests with coverage
npm run keploy:test:coverage
```

### Method 2: Using Keploy CLI

```bash
cd backend

# Run tests
keploy test -c "node index.js" --delay 10

# Run specific test set
keploy test -c "node index.js" --test-set test-set-0

# Generate test report
keploy test -c "node index.js" --delay 10 --coverage
```

## 🐳 Docker Setup

### Running with Docker Compose

```bash
cd backend

# Start all services (MongoDB + Backend + Keploy)
docker-compose -f docker-compose.keploy.yml up -d

# View logs
docker-compose -f docker-compose.keploy.yml logs -f

# Stop services
docker-compose -f docker-compose.keploy.yml down
```

### Recording with Docker

```bash
# Set environment for recording
export KEPLOY_MODE=record

# Start services
docker-compose -f docker-compose.keploy.yml up

# Generate traffic (from another terminal)
# Run your curl commands as shown above

# Stop recording
docker-compose -f docker-compose.keploy.yml down
```

### Testing with Docker

```bash
# Set environment for testing
export KEPLOY_MODE=test

# Run tests
docker-compose -f docker-compose.keploy.yml up

# View results
docker-compose -f docker-compose.keploy.yml logs keploy
```

## 📊 Understanding Test Results

After running tests, Keploy provides a detailed report:

```
📊 Test Summary
┌─────────────────┬──────────┬──────────┬──────────┐
│   Test Set      │  Passed  │  Failed  │  Total   │
├─────────────────┼──────────┼──────────┼──────────┤
│  test-set-0     │    5     │    0     │    5     │
│  test-set-1     │    3     │    1     │    4     │
└─────────────────┴──────────┴──────────┴──────────┘

✅ Overall Result: 8/9 tests passed (88.89%)
```

### Test Structure

Test cases are stored in `./keploy/tests/` with this structure:

```
keploy/
├── tests/
│   ├── test-set-0/
│   │   ├── test-1.yaml
│   │   ├── test-2.yaml
│   │   └── ...
│   └── test-set-1/
│       ├── test-1.yaml
│       └── ...
└── mocks/
    ├── mock-1.yaml
    └── ...
```

Each test file contains:
- HTTP request (method, headers, body)
- Expected response (status, headers, body)
- Database queries/responses
- External API call mocks

## 🎯 Best Practices

### 1. **Organize Test Sets**
Group related tests together by creating different test sets:
```bash
keploy record -c "node index.js" --test-set auth-tests
keploy record -c "node index.js" --test-set ai-tests
keploy record -c "node index.js" --test-set image-tests
```

### 2. **Use Test Data Cleanup**
Before recording, ensure your database is in a clean state:
```bash
# Drop test database
mongo storyforge --eval "db.dropDatabase()"
```

### 3. **Mock External APIs**
Keploy automatically mocks external APIs (Groq, HuggingFace, Replicate) to:
- Speed up tests
- Avoid rate limits
- Ensure deterministic results

### 4. **Version Control**
Commit your test cases to git:
```bash
git add keploy/tests/
git commit -m "Add Keploy test cases for authentication"
```

### 5. **CI/CD Integration**
Add to your CI pipeline:
```yaml
# .github/workflows/test.yml
- name: Run Keploy Tests
  run: |
    npm run keploy:test
```

### 6. **Environment Isolation**
Use different MongoDB databases for recording vs testing:
```env
# For recording
MONGO_URI=mongodb://localhost:27017/storyforge_record

# For testing
MONGO_URI=mongodb://localhost:27017/storyforge_test
```

## 🔧 Configuration

The `keploy.yml` file contains all configuration:

```yaml
# Key settings
app:
  port: 5000              # Your app port
  
test:
  delay: 5                # Wait time before tests
  globalTimeout: 60       # Test timeout
  
path:
  testPath: "./keploy/tests"   # Test storage
  mockPath: "./keploy/mocks"   # Mock storage
```

## 🐛 Troubleshooting

### Issue: Tests Failing Due to Dynamic Data

**Solution:** Update `keploy.yml` to normalize dynamic fields:
```yaml
normalize:
  body:
    - "$.timestamp"
    - "$._id"
    - "$.token"
```

### Issue: External API Calls Not Mocked

**Solution:** Add the API to stubs in `keploy.yml`:
```yaml
stubs:
  - type: "http"
    name: "my-api"
    host: "api.example.com"
    port: 443
```

### Issue: Permission Denied (Linux)

**Solution:** Run with sudo or add capabilities:
```bash
sudo keploy record -c "node index.js"
```

## 📚 Additional Resources

- [Keploy Documentation](https://docs.keploy.io)
- [Keploy GitHub](https://github.com/keploy/keploy)
- [Keploy Discord Community](https://discord.gg/keploy)

## 🤝 Contributing

When adding new API endpoints:
1. Record new test cases
2. Run existing tests to ensure no regressions
3. Commit both code and test cases
4. Update this documentation if needed

---

Happy Testing! 🚀✨
