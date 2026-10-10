// ====================================================================
// 3D Printable Mountain Trees Variety Pack (Heights 3.0in to 4.0in)
// Botanically Accurate Alpine/Subalpine Species:
// 1. Colorado Blue Spruce (4.00 in / 101.60 mm) - Slate Blue-Green Tiered Cone
// 2. Mountain Hemlock    (3.80 in / 96.52 mm)  - Drooping Leader & Soft Boughs
// 3. Bristlecone Pine    (3.60 in / 91.44 mm)  - Gnarled Alpine Ridge Canopy
// 4. Ponderosa Pine      (3.40 in / 86.36 mm)  - High Clear Trunk Tufted Rosettes
// 5. Subalpine Fir       (3.20 in / 81.28 mm)  - Dense Narrow Spire Tiered Apex
// 6. Alpine Larch        (3.00 in / 76.20 mm)  - Feathery Golden-Green Needle Whorls
// 100% Supportless Manifold Solids for FDM 3D Printing (Zero Floating Geometry)
// ====================================================================

$fn = 30;

use <mountain_variety_pack_3to4in/01_colorado_blue_spruce_4.0in.scad>
use <mountain_variety_pack_3to4in/02_mountain_hemlock_3.8in.scad>
use <mountain_variety_pack_3to4in/03_bristlecone_pine_3.6in.scad>
use <mountain_variety_pack_3to4in/04_ponderosa_pine_3.4in.scad>
use <mountain_variety_pack_3to4in/05_subalpine_fir_3.2in.scad>
use <mountain_variety_pack_3to4in/06_alpine_larch_3.0in.scad>

// Master Layout: 2 rows of 3 trees spaced 65mm apart (fits standard build plate)
translate([-65, 35, 0])  colorado_blue_spruce_4_0in(101.60);
translate([0, 35, 0])    mountain_hemlock_3_8in(96.52);
translate([65, 35, 0])   bristlecone_pine_3_6in(91.44);

translate([-65, -35, 0]) ponderosa_pine_3_4in(86.36);
translate([0, -35, 0])   subalpine_fir_3_2in(81.28);
translate([65, -35, 0])  alpine_larch_3_0in(76.20);
