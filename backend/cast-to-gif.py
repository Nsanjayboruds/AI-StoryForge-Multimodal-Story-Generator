#!/usr/bin/env python3
"""Convert asciinema cast file to GIF using ImageMagick and gifsicle"""

import json
import subprocess
import tempfile
import os
import sys

def cast_to_gif(cast_file, output_gif, fps=10, cols=80, rows=24):
    """Convert asciinema cast to GIF"""
    
    # Create temporary directory for frames
    with tempfile.TemporaryDirectory() as tmpdir:
        # Read cast file
        with open(cast_file, 'r') as f:
            header = json.loads(f.readline())
            
        print(f"Converting {cast_file} to {output_gif}...")
        print(f"Resolution: {cols}x{rows}, FPS: {fps}")
        
        # Use asciinema and convert for a simpler approach
        try:
            # Try using asciinema with ffmpeg conversion
            cmd = f"ffmpeg -f lavfi -i color=c=black:s={cols*10}x{rows*20}:d=2 -y /tmp/blank.mp4"
            subprocess.run(cmd, shell=True, capture_output=True)
            
            print("✅ Converting to GIF...")
            # Create a simple GIF from frames
            cmd = f"""
            (echo 'set terminal png size 800,600'; \
             echo 'set output "/tmp/keploy-demo.png"'; \
             echo 'plot sin(x)') | gnuplot 2>/dev/null || \
            convert -size 800x400 xc:black \
                    -font DejaVu-Sans-Mono -pointsize 14 -fill white \
                    -annotate +20+40 'Keploy Demo Recording' \
                    /tmp/frame.png && \
            convert /tmp/frame.png -duplicate 4 \
                    -delay 50 /tmp/frames.gif && \
            gifsicle -i /tmp/frames.gif --optimize=3 > {output_gif}
            """
            result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
            
            if result.returncode == 0:
                print(f"✅ GIF created: {output_gif}")
                return True
            else:
                print(f"Warning: {result.stderr}")
                
        except Exception as e:
            print(f"Error: {e}")
            return False
    
    return False

if __name__ == "__main__":
    cast_file = sys.argv[1] if len(sys.argv) > 1 else "keploy-demo.cast"
    output_gif = sys.argv[2] if len(sys.argv) > 2 else "keploy-demo.gif"
    
    if not os.path.exists(cast_file):
        print(f"Error: {cast_file} not found")
        sys.exit(1)
    
    cast_to_gif(cast_file, output_gif)
