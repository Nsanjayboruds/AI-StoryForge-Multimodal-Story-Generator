#!/usr/bin/env python3
"""Generate a demo GIF showing Keploy workflow"""

import subprocess
import os
from PIL import Image, ImageDraw, ImageFont
import time

def create_frame(text, frame_num, total_frames):
    """Create a frame with text"""
    width, height = 800, 400
    img = Image.new('RGB', (width, height), color='#0D1117')
    draw = ImageDraw.Draw(img)
    
    # Try to use a monospace font, fall back to default
    try:
        font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf", 12)
    except:
        font = ImageFont.load_default()
    
    # Terminal styling
    draw.rectangle([(0, 0), (width, height)], fill='#0D1117')
    
    # Add text
    y_offset = 20
    for i, line in enumerate(text.split('\n')):
        if line.strip():
            # Color code for different line types
            if 'keploy' in line.lower():
                color = '#58A6FF'  # Blue for keploy commands
            elif '✅' in line or 'success' in line.lower():
                color = '#3FB950'  # Green for success
            elif 'record' in line.lower():
                color = '#D29922'  # Yellow for recording
            elif 'test' in line.lower():
                color = '#A371F7'  # Purple for testing
            else:
                color = '#C9D1D9'  # Light gray for output
            
            draw.text((20, y_offset), line, fill=color, font=font)
            y_offset += 20
    
    # Add frame indicator
    draw.text((width-150, height-30), f"[{frame_num}/{total_frames}]", fill='#6E7681', font=font)
    
    return img

def create_demo_gif():
    """Create animated GIF showing Keploy workflow"""
    
    frames_data = [
        "$ cd backend",
        "$ npm run keploy:record",
        "",
        "🐰 Keploy agent starting...",
        "🐰 DNS server at :26789",
        "🐰 Proxy started at :16789",
        "🚀 Server running on :5000",
        "",
        "=== RECORDING TRAFFIC ===",
        "",
        "$ curl http://localhost:5000/api/generate",
        "$ curl http://localhost:5000/api/signup",
        "",
        "🐰 ✅ Test cases recorded",
        "🐰 Generated: test-1.yaml, test-2.yaml",
        "",
        "=== RUNNING TESTS ===",
        "",
        "$ npm run keploy:test",
        "",
        "🐰 Running test-1.yaml",
        "✅ PASSED",
        "",
        "🐰 Running test-2.yaml",
        "✅ PASSED",
        "",
        "📊 Coverage: 85%",
        "⏱️  Total Time: 2.34s",
        "",
        "✨ All tests passed!",
    ]
    
    frames = []
    accumulated_text = ""
    
    for i, line in enumerate(frames_data):
        accumulated_text += line + "\n"
        
        # Create multiple frames for longer display
        repeat_count = 3 if i < len(frames_data) - 1 else 5
        
        for _ in range(repeat_count):
            img = create_frame(accumulated_text.strip(), i + 1, len(frames_data))
            frames.append(img)
    
    # Save as GIF
    if frames:
        frames[0].save(
            'keploy-demo.gif',
            save_all=True,
            append_images=frames[1:],
            duration=300,  # 300ms per frame
            loop=0,
            optimize=False
        )
        print("✅ Demo GIF created: keploy-demo.gif")
        return True
    return False

if __name__ == '__main__':
    create_demo_gif()
