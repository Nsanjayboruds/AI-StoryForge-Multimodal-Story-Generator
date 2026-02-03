#!/bin/bash

echo "🎬 Recording Keploy Tests - Real API Calls"
echo "=========================================="
echo

cd /home/nishant-borude/Documents/s/AI-StoryForge-Multimodal-Story-Generator/backend

# Cache sudo credentials up-front (avoids background password prompt)
echo "Authenticating sudo..."
sudo -v

# Start Keploy recording with a fixed timer
echo "Starting Keploy in record mode (45s timer)..."
sudo -n keploy record -c "node index.js" --record-timer 45s --path "./keploy" &
KEPLOY_PID=$!

echo "Waiting for server to start (8 seconds)..."
sleep 8

echo ""
echo "Making real API calls..."
echo ""

# Test 1: Root endpoint
echo "1️⃣ Testing root endpoint..."
curl -s http://localhost:5000/
echo ""
sleep 2

# Test 2: Signup
echo "2️⃣ Testing signup..."
curl -s -X POST http://localhost:5000/api/signup \
  -H "Content-Type: application/json" \
  -d '{"email":"realuser@demo.com","password":"SecurePass123"}'
echo ""
sleep 2

# Test 3: Login
echo "3️⃣ Testing login..."
curl -s -X POST http://localhost:5000/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"realuser@demo.com","password":"SecurePass123"}'
echo ""
sleep 2

# Test 4: AI Story (if API key is configured)
echo "4️⃣ Testing AI story generation..."
curl -s -X POST http://localhost:5000/api/ai \
  -H "Content-Type: application/json" \
  -d '{"prompt":"Write a short story about a space explorer","model":"llama3-8b-8192"}' \
  | head -c 200
echo "..."
sleep 2

echo ""
echo ""
echo "✅ API calls complete!"
echo ""
echo "Waiting for Keploy to finish recording..."
wait $KEPLOY_PID
echo "Recording finished."
echo ""
echo "Check generated tests with:"
echo "  ls -la keploy/tests/"
echo "  ls -la keploy/mocks/"
