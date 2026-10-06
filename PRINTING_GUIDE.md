# 3D Printing & Assembly Guide (Individual Single-Part Files)

Every component is now **separated into its own dedicated, numbered file**. 

Each file prints a **single object** (or matched pair) centered right in the middle of your print bed at **$Z = 0.00\text{ mm}$**. No crowded plates, no risk of a failure on one part ruining others, and **ZERO supports required** on any part!

---

## 🖨️ Step-by-Step Print Queue

| Step | File | What It Prints | Recommended Color | Slicer Infill | Est. Print Time |
| :---: | :--- | :--- | :--- | :---: | :---: |
| **01** | [`01_gondola_single_piece.scad`](file:///Users/lavanyat/Documents/Hari/Projects/3d-models/models/01_gondola_single_piece.scad) | Unified Gondola Cabin & Roof (1-Piece) | Festive Red / Alpine Green | 15–20% | ~25–35 min |
| **03** | [`03_hanger_arm.scad`](file:///Users/lavanyat/Documents/Hari/Projects/3d-models/models/03_hanger_arm.scad) | Classic C-Hanger Arm (Heavy-Duty Barb Tabs) | Silver / Black / White | 100% | ~10–12 min |
| **04** | [`04_trolley_carriage.scad`](file:///Users/lavanyat/Documents/Hari/Projects/3d-models/models/04_trolley_carriage.scad) | Cable Glider Sled Runner (Barb-Lock Sockets) | Black / Dark Gray | 30% | ~8–12 min |

---

## 🛠️ Hardware-Free 100% Snap-In Assembly Instructions

### 1. Vehicle Assembly (Wedge Barb Snap-Fit)
1. **Snap Hanger into Glider Runner:** Take the **Classic C-Hanger Arm** (`03`) and push its top wedge arrow-head barb UP into the bottom slot of the **Cable Glider Runner** (`04`). The barbs flex inward and **CLICK** over internal locking shoulders!
2. **Snap Hanger onto Gondola Roof:** Push the bottom wedge arrow-head barb of the **C-Hanger Arm** (`03`) DOWN into the roof bracket of the **Gondola Cabin** (`01`). The barbs flex inward and **CLICK** over internal roof shoulders!
3. **Hang on Cable Line:** Snap the glider top head onto your cable line.
4. **ZERO tiny pegs, ZERO loose pins, ZERO screws, ZERO hardware required!**





### 2. Towers & Rigging (Steps 06 – 10)
1. **Tower Masts:** Plug the lower ends of the **3D-Printed Tower Masts** (`10`) (or wooden dowels) into the sockets on the **Tower Bases** (`09`).
2. **Mount Station Heads:** Snap **Tower Station A** (`06A`/`06B`) and **Tower Station B** (`07A`/`07B`) onto the top of the mast poles.
3. **Mount Sheaves:** Snap or bolt one **Sheave Wheel** (`08`) onto each tower head.
4. **Rigging:** String 1.0–1.5mm line across the sheaves and thread through the gondola trolley wheels!


---

## 🔩 Complete Fastener Checklist

| Location | Fastener | Nut | Purpose |
| :--- | :--- | :--- | :--- |
| **Trolley Wheels** | 2x M3 $\times$ 16mm | 2x M3 Locknut (Captive) | Roller axles |
| **Trolley &rarr; Hanger** | 1x M3 $\times$ 16mm | 1x M3 Locknut (Captive) | Top hanger pivot |
| **Roof &rarr; Hanger** | 1x M3 $\times$ 16mm | 1x M3 Locknut (Captive) | Bottom hanger lock |
| **Tower Sheaves** | 2x M5 $\times$ 25mm | 2x M5 Locknut | Sheave wheel axles |
| **Station B Tensioner** | 1x M4 $\times$ 35mm | (Threads directly) | Cable tension adjuster |

---

## 👁️ Visual 3D Preview
Open [`models/full_system_preview.scad`](file:///Volumes/Samsung%20990%201TB/Hari/gandola/models/full_system_preview.scad) in OpenSCAD and press **`F5`** anytime to view the complete setup assembled.
