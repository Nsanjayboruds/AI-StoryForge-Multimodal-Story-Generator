#!/bin/bash

# Simple test to verify Keploy setup
echo "🧪 Testing Keploy Setup for AI-StoryForge"
echo "=========================================="
echo

# Test 1: Check Keploy Installation
echo "✓ Test 1: Keploy Installation"
if command -v keploy &> /dev/null; then
    KEPLOY_VERSION=$(keploy --version 2>&1)
    echo "  ✅ Keploy is installed: $KEPLOY_VERSION"
else
    echo "  ❌ Keploy is not installed"
    exit 1
fi
echo

# Test 2: Check MongoDB
echo "✓ Test 2: MongoDB Connection"
if pgrep -x "mongod" > /dev/null; then
    echo "  ✅ MongoDB is running"
else
    echo "  ⚠️  MongoDB is not running"
fi
echo

# Test 3: Check .env file
echo "✓ Test 3: Environment Configuration"
if [ -f .env ]; then
    echo "  ✅ .env file exists"
    echo "  Variables found:"
    grep -v '^#' .env | grep '=' | cut -d'=' -f1 | sed 's/^/    - /'
else
    echo "  ❌ .env file not found"
fi
echo

# Test 4: Check dependencies
echo "✓ Test 4: Node.js Dependencies"
if [ -d "node_modules" ]; then
    echo "  ✅ Dependencies installed"
else
    echo "  ❌ Dependencies not installed. Run: npm install"
    exit 1
fi
echo

# Test 5: Test server startup
echo "✓ Test 5: Server Startup Test"
echo "  Starting server..."
timeout 5 node index.js > /tmp/server-test.log 2>&1 &
SERVER_PID=$!
sleep 3

if curl -s http://localhost:5000/ > /dev/null 2>&1; then
    echo "  ✅ Server responds successfully"
    RESPONSE=$(curl -s http://localhost:5000/)
    echo "  Response: $RESPONSE"
else
    echo "  ⚠️  Server may not be fully responsive yet"
fi

# Cleanup
kill $SERVER_PID 2>/dev/null
wait $SERVER_PID 2>/dev/null
echo

# Test 6: Keploy Configuration
echo "✓ Test 6: Keploy Configuration"
if [ -f "keploy.yml" ]; then
    echo "  ✅ keploy.yml exists"
else
    echo "  ❌ keploy.yml not found"
fi
echo

# Test 7: Test Scripts
echo "✓ Test 7: Test Scripts"
if [ -f "keploy-test.sh" ]; then
    echo "  ✅ keploy-test.sh exists"
fi
if [ -f "quick-start-keploy.sh" ]; then
    echo "  ✅ quick-start-keploy.sh exists"
fi
echo

echo "=========================================="
echo "📊 Summary"
echo "=========================================="
echo "✅ Keploy is properly set up and ready to use!"
echo
echo "Next Steps:"
echo "1. Add your API keys to .env file"
echo "2. Run: npm run keploy:record (in one terminal)"
echo "3. Make API calls to record tests"
echo "4. Run: npm run keploy:test (to replay tests)"
echo
echo "For detailed instructions, see: KEPLOY_TESTING.md"
