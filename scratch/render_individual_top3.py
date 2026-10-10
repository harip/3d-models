import os
import subprocess

artifact_dir = "/Users/lavanyat/.gemini/antigravity-ide/brain/b6d63059-fcc2-4f58-9ee9-2a7dadcb769f"

targets = [
    ("01_colorado_blue_spruce_4.0in", "models/trees/accurate_mountain_pack/01_colorado_blue_spruce_4.0in.scad"),
    ("02_mountain_hemlock_3.8in", "models/trees/accurate_mountain_pack/02_mountain_hemlock_3.8in.scad"),
    ("03_bristlecone_pine_3.6in", "models/trees/accurate_mountain_pack/03_bristlecone_pine_3.6in.scad"),
]

for name, scad_path in targets:
    stl_dest = f"stls/trees/{name}.stl"
    png_dest = f"scratch/{name}_preview.png"
    
    print(f"Rendering STL for {name}...")
    res = subprocess.run(["openscad", "-o", stl_dest, scad_path], capture_output=True, text=True)
    print(f"  Result Code: {res.returncode}")
    print(f"  OpenSCAD log: {res.stderr.strip()}")
    
    print(f"Rendering high-res PNG preview for {name}...")
    subprocess.run(["openscad", "-o", png_dest, "--imgsize=1200,1200", "--colorscheme=Tomorrow", scad_path], capture_output=True, text=True)
    if os.path.exists(png_dest):
        subprocess.run(["cp", png_dest, f"{artifact_dir}/{name}_preview.png"])

print("Individual renders completed successfully!")
