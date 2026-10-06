# 3D Printing & Assembly Guide (Individual Single-Part Files)

Every component is now **separated into its own dedicated, numbered file**. 

Each file prints a **single object** (or matched pair) centered right in the middle of your print bed at **$Z = 0.00\text{ mm}$**. No crowded plates, no risk of a failure on one part ruining others, and **ZERO supports required** on any part!

---

## 🖨️ Step-by-Step Print Queue

| Step | File | What It Prints | Recommended Color | Slicer Infill | Est. Print Time |
| :---: | :--- | :--- | :--- | :---: | :---: |
| **01** | [`01_gondola_single_piece.scad`](file:///Users/lavanyat/Documents/Hari/Projects/3d-models/models/01_gondola_single_piece.scad) | Unified Gondola Cabin & Roof (1-Piece) | Festive Red / Alpine Green | 15–20% | ~25–35 min |
| **03** | [`03_hanger_arm.scad`](file:///Users/lavanyat/Documents/Hari/Projects/3d-models/models/03_hanger_arm.scad) | Flat C-Hanger Arm | Silver / Black / White | 100% | ~12–18 min |
| **04** | [`04_trolley_carriage.scad`](file:///Users/lavanyat/Documents/Hari/Projects/3d-models/models/04_trolley_carriage.scad) | Alpine Cable Glider Runner (1-Piece, Wheel-Less) | Black / Dark Gray | 30% | ~8–12 min |
| **05** | [`05_trolley_wheels_pair.scad`](file:///Users/lavanyat/Documents/Hari/Projects/3d-models/models/05_trolley_wheels_pair.scad) | Pair of Heavy-Duty Assembly Pins | Black / Gray | 100% | ~5 min |

---

## 🛠️ Hardware-Free 3D Pin Assembly Instructions

### 1. Vehicle Assembly (Steps 01 – 05)
1. **Cable Glider Runner:** No wheels needed! The **Alpine Cable Glider Runner** (`04`) features a smooth, flared $45^\circ$ trumpet channel that glides directly along any cord or wire line.
2. **Attach Hanger Arm:** Slide the lower tab of the **C-Hanger Arm** (`03`) into the roof clevis bracket slot of the **Unified Gondola Cabin** (`01`) and insert a **3D-printed pin** (`05`).
3. **Hang Glider Carriage:** Slide the top eyelet of the **Hanger Arm** (`03`) into the lower clevis fork of the **Cable Glider Runner** (`04`) and insert the second **3D-printed pin** (`05`).


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
