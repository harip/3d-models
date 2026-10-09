// Master 6-Tree Mountain Variety Pack Layout (Spaced 45mm apart in 2x3 Grid)
// All trees FDM certified 100% supportless with 32mm breakaway base rafts

use <mountain_pack/01_colorado_blue_spruce_3.0in.scad>
use <mountain_pack/02_mountain_hemlock_2.8in.scad>
use <mountain_pack/03_ponderosa_pine_2.6in.scad>
use <mountain_pack/04_subalpine_fir_2.4in.scad>
use <mountain_pack/05_alpine_larch_2.2in.scad>
use <mountain_pack/06_mountain_cypress_2.0in.scad>

// Back Row (Left to Right):
translate([-45, 25, 0])  colorado_blue_spruce(76.2);       // 1. Colorado Blue Spruce (3.0 in)
translate([0, 25, 0])    mountain_hemlock(71.12);         // 2. Mountain Hemlock (2.8 in)
translate([45, 25, 0])   ponderosa_pine(66.04);           // 3. Ponderosa Pine (2.6 in)

// Front Row (Left to Right):
translate([-45, -25, 0]) subalpine_fir(60.96);            // 4. Subalpine Fir (2.4 in)
translate([0, -25, 0])   alpine_larch(55.88);             // 5. Alpine Larch (2.2 in)
translate([45, -25, 0])  mountain_cypress(50.80);         // 6. Mountain Cypress (2.0 in)
