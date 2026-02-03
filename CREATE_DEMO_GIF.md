# 📹 How to Create a Keploy Demo GIF

This guide explains how to create a visual demonstration GIF showing Keploy recording and replaying tests.

## What the GIF Should Show

Your GIF should demonstrate:
1. **Recording Phase** - Starting Keploy in record mode and making API calls
2. **Replay Phase** - Running the recorded tests
3. **Results** - Test output showing all tests passing

---

## 🛠️ Tools You'll Need

Choose one of these screen recording tools:

### Option 1: ScreenFlow (macOS - Recommended)
- Built-in macOS tool
- High quality
- Simple to use

### Option 2: OBS Studio (Cross-platform - Free)
- Works on Windows, macOS, Linux
- Free and open-source
- Download: https://obsproject.com/

### Option 3: SimpleScreenRecorder (Linux)
- Lightweight
- Built-in GIF conversion

### Option 4: ffmpeg (Command-line - All platforms)
- Powerful and fast
- Already available on most systems

---

## 📝 Step-by-Step Guide to Create the GIF

### Setup Phase

```bash
# 1. Navigate to backend directory
cd backend

# 2. Ensure MongoDB is running
sudo systemctl start mongod  # or use Docker

# 3. Clear old test data (optional)
rm -rf keploy/tests/* keploy/mocks/*

# 4. Install dependencies if needed
npm install
```

### Recording Phase (Duration: ~1 minute)

Follow these steps IN ORDER while recording:

**Step 1: Show file structure (5 seconds)**
```bash
ls -la keploy/
# Shows that keploy/ directory exists
```

**Step 2: Start Keploy recording (10 seconds)**
```bash
npm run keploy:record
```
Wait until you see:
```
🐰 Keploy: ... INFO  Generated config file...
```

**Step 3: Test API endpoints (30 seconds)**
Open another terminal and run:

```bash
# Test 1: Root endpoint (3 seconds)
curl http://localhost:5000/

# Test 2: Signup (5 seconds)
curl -X POST http://localhost:5000/api/signup \
  -H "Content-Type: application/json" \
  -d '{"email":"keploy@demo.com","password":"Demo123!"}'

# Test 3: Login (5 seconds)
curl -X POST http://localhost:5000/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"keploy@demo.com","password":"Demo123!"}'

# Test 4: Story generation (10 seconds)
curl -X POST http://localhost:5000/api/ai \
  -H "Content-Type: application/json" \
  -d '{"prompt":"Write a short story about an explorer","model":"llama3-8b-8192"}'

# Test 5: Image generation (7 seconds)
curl -X POST http://localhost:5000/api/image \
  -H "Content-Type: application/json" \
  -d '{"prompt":"A beautiful forest"}'
```

**Step 4: Stop recording (5 seconds)**
In the first terminal (Keploy recording), press `Ctrl+C`

You should see:
```
✅ Test cases recorded in ./keploy/tests/
```

**Step 5: Show recorded tests (10 seconds)**
```bash
ls -la keploy/tests/test-set-0/
# Shows all the recorded test files
```

### Playback Phase (Duration: ~1 minute)

**Step 6: Run the recorded tests (30 seconds)**
```bash
npm run keploy:test
```

Wait for test output showing:
```
✅ test-1-root.yaml: PASSED
✅ test-2-signup.yaml: PASSED
✅ test-3-login.yaml: PASSED
✅ test-4-ai-story.yaml: PASSED
✅ test-5-image.yaml: PASSED
```

**Step 7: Show test files (20 seconds)**
```bash
cat keploy/tests/test-set-0/test-1-root.yaml
# Shows the structure of recorded tests
```

---

## 🎬 Recording with OBS Studio

### Step 1: Download and Install
Download from https://obsproject.com/

### Step 2: Configure OBS
1. Click "+" in Sources → Add "Screen Capture"
2. Select your main display
3. Set resolution to 1920x1080 (or 1280x720 for smaller size)
4. Set FPS to 30

### Step 3: Start Recording
1. File → Settings → Output
2. Set output path to save directory
3. Click "Start Recording"
4. Follow the step-by-step guide above
5. Click "Stop Recording"

### Step 4: Convert to GIF (using ffmpeg)

```bash
# Install ffmpeg if needed
# macOS: brew install ffmpeg
# Ubuntu: sudo apt-get install ffmpeg
# Windows: choco install ffmpeg

# Convert MP4 to GIF
ffmpeg -i recording.mp4 -vf "fps=10,scale=1280:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" output.gif

# For smaller file size
ffmpeg -i recording.mp4 -vf "fps=5,scale=800:-1:flags=lanczos" -loop 0 output.gif
```

---

## 🖥️ Recording with ffmpeg Directly

### Capture Screen and Convert to GIF

```bash
# Record screen for 120 seconds at 30 fps
ffmpeg -f x11grab -i :0 -t 120 -r 30 -s 1920x1080 output.mp4

# Convert to GIF (smaller file)
ffmpeg -i output.mp4 -vf "fps=10,scale=1280:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 keploy-demo.gif
```

---

## 📊 GIF Specifications

**Recommended settings:**
- **Resolution:** 1280x720 (or 1920x1080 for clearer text)
- **Frame Rate:** 10-15 fps (balances quality and file size)
- **Duration:** 2-3 minutes
- **File Size:** 10-50 MB (GIFs can be large)

**For faster GIF (smaller file):**
```bash
ffmpeg -i recording.mp4 -vf "fps=5,scale=800:-1" -loop 0 keploy-demo.gif
```

---

## 💡 Tips for a Great GIF

1. **Clear Text** - Use large terminal font (size 14-16)
2. **Zoom In** - Use terminal zoom to make commands visible
   ```bash
   # In most terminals
   Ctrl + Plus (+) to zoom in
   ```

3. **Add Terminal Title** - Show what you're doing
   ```bash
   echo "=== Keploy Recording Demo ===" 
   ```

4. **Slow Down Commands** - Add pauses between commands
   ```bash
   sleep 2  # Pause for 2 seconds
   ```

5. **Use Colors** - Terminal with syntax highlighting helps
   ```bash
   # Example with colors
   echo "🎉 Recording started..."
   ```

---

## 🚀 Quick Command to Generate GIF from Recording

Once you have an MP4 file:

```bash
# High quality (larger file)
ffmpeg -i recording.mp4 -vf "fps=15,scale=1280:-1:flags=lanczos" -loop 0 keploy-demo.gif

# Medium quality (balanced)
ffmpeg -i recording.mp4 -vf "fps=10,scale=1024:-1:flags=lanczos" -loop 0 keploy-demo.gif

# Small size (faster load)
ffmpeg -i recording.mp4 -vf "fps=5,scale=800:-1:flags=lanczos" -loop 0 keploy-demo.gif
```

---

## 📍 Where to Place the GIF

Add the GIF to your repository:

```bash
# Create directory for assets
mkdir -p assets/demos

# Move your GIF
mv keploy-demo.gif assets/demos/

# Add to README.md
# In your README, add:
![Keploy Recording and Replay Demo](assets/demos/keploy-demo.gif)
```

---

## 🎥 Example GIF Narration (for reference)

If adding voiceover (optional), here's what to say:

---

**[0:00-0:15]** Recording Phase Intro
> "This demo shows Keploy in action. We'll record API traffic and then replay it as automated tests."

**[0:15-0:30]** Starting Recording
> "First, we start Keploy in record mode. It will capture all HTTP traffic to our backend."

**[0:30-1:15]** Making API Calls
> "Now we make API requests: user signup, login, AI story generation, and image generation."

**[1:15-1:30]** Stopping Recording
> "We stop the recording. Keploy has saved all test cases as YAML files."

**[1:30-2:00]** Replay Phase
> "Now we run the recorded tests. Keploy automatically replays the exact same API calls and verifies responses."

**[2:00-2:15]** Results
> "All tests pass! This demonstrates how Keploy eliminates manual test writing while providing automated coverage."

---

## ✅ Checklist Before Sharing

- [ ] GIF shows recording phase clearly
- [ ] GIF shows replay phase clearly
- [ ] All tests pass in the GIF
- [ ] Terminal text is readable
- [ ] File size is reasonable (<50MB)
- [ ] GIF loops smoothly
- [ ] Added to README with caption
- [ ] Commented code for clarity

---

## 🎁 Use Your GIF

Once created, share it in:
- README.md (showing how Keploy works)
- Slack message to Keploy team
- GitHub pull request (in the description)
- Blog post about your implementation
- Twitter/LinkedIn posts about Keploy

---

Need help? Check out:
- [OBS Studio Guide](https://obsproject.com/wiki/)
- [ffmpeg Documentation](https://ffmpeg.org/documentation.html)
- [Keploy Official Docs](https://docs.keploy.io)
