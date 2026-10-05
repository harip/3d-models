# 3D Printing & Assembly Guide (Individual Single-Part Files)

Every component is now **separated into its own dedicated, numbered file**. 

Each file prints a **single object** (or matched pair) centered right in the middle of your print bed at **$Z = 0.00\text{ mm}$**. No crowded plates, no risk of a failure on one part ruining others, and **ZERO supports required** on any part!

---

## 🖨️ Step-by-Step Print Queue

| Step | File | What It Prints | Recommended Color | Slicer Infill | Est. Print Time |
| :---: | :--- | :--- | :--- | :---: | :---: |
| **01** | [`01_gondola_single_piece.scad`](file:///Users/lavanyat/Documents/Hari/Projects/3d-models/models/01_gondola_single_piece.scad) | Unified Gondola Cabin & Roof (1-Piece) | Festive Red / Alpine Green | 15–20% | ~25–35 min |
| **03** | [`03_hanger_arm.scad`](file:///Users/lavanyat/Documents/Hari/Projects/3d-models/models/03_hanger_arm.scad) | Flat C-Hanger Arm | Silver / Black / White | 100% | ~12–18 min |
| **04** | [`04_trolley_carriage.scad`](file:///Users/lavanyat/Documents/Hari/Projects/3d-models/models/04_trolley_carriage.scad) | Inverted U-Chassis | Black / Dark Gray | 30% | ~20–25 min |
| **05** | [`05_trolley_wheels_pair.scad`](file:///Users/lavanyat/Documents/Hari/Projects/3d-models/models/05_trolley_wheels_pair.scad) | Pair of Grooved Rollers | Gold / Yellow / Bronze | 100% | ~15–20 min |
| **06** | [`06_tower_head_station_a.scad`](file:///Users/lavanyat/Documents/Hari/Projects/3d-models/models/06_tower_head_station_a.scad) | Drive Tower Head A | Forest Green / Black | 30% | ~30–40 min |
| **07** | [`07_tower_head_station_b.scad`](file:///Users/lavanyat/Documents/Hari/Projects/3d-models/models/07_tower_head_station_b.scad) | Tension Tower Head B | Forest Green / Black | 30% | ~30–40 min |
| **08** | [`08_tower_sheaves_pair.scad`](file:///Users/lavanyat/Documents/Hari/Projects/3d-models/models/08_tower_sheaves_pair.scad) | Pair of 18mm Sheaves | Gold / Silver | 30% | ~30–40 min |
| **09** | [`09_tower_base.scad`](file:///Users/lavanyat/Documents/Hari/Projects/3d-models/models/09_tower_base.scad) | 36mm Baseplate *(Print 2x)* | Dark Slate / White | 20% | ~20–30 min each |

---

## 🛠️ Assembly Instructions

### 1. Vehicle Assembly (Steps 01 – 05)
1. **Trolley Rollers:** Drop two M3 locknuts into the captive hex pockets of the **Trolley Carriage** (`04`). Place the **2 Wheels** (`05`) into the channel and insert M3 $\times$ 16mm screws. Tighten until snug; check that wheels spin freely.
2. **Attach Hanger Arm:** Slide the lower tab of the **C-Hanger Arm** (`03`) into the top roof bracket slot of the **Unified Gondola Cabin** (`01`) and secure with an M3 $\times$ 16mm screw.

4. **Hang on Carriage:** Drop an M3 nut into the lower clevis of the **Trolley Carriage** (`04`). Slide the top eyelet of the **Hanger Arm** (`03`) into the fork and secure with an M3 $\times$ 16mm screw.

### 2. Towers & Rigging (Steps 06 – 09)
1. **Tower Masts:** Cut two standard **20 mm (or 3/4 inch)** wooden dowels or PVC pipes to your desired display height (e.g. 12–18 inches / 30–45 cm).
2. **Mount Heads & Bases:** Push the bottom of each mast into a **Tower Base** (`09`), and push **Station A** (`06`) and **Station B** (`07`) onto the tops.
3. **Mount Sheaves:** Bolt one 54mm **Sheave Wheel** (`08`) onto each tower head using M5 $\times$ 25mm bolts and locknuts.
4. **Rigging:** String 1.0–1.5mm monofilament or nylon-coated wire across the sheaves and thread through the gondola trolley.
5. **Tensioning:** Tighten the tensioning bolt on Station B until line sag disappears, and glide your gondola across!

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
