// ====================================================================
// [PRINT 08-B] Precision Axle Pin & Retaining End Cap Set
//
// Engineering Specifications:
// - Part 08C: 4.0mm shaft x 14.0mm length male axle pin with split barb tip
// - Part 08D: Retaining end cap disk with internal snap shoulder
// - Matched to 14.0mm Clevis span and 4.5mm sheave bore
// ====================================================================

use <08c_m5_axle_pin_only.scad>;
use <08d_m5_end_cap_only.scad>;

$fn = 50;

// Layout on Print Bed (Spaced side-by-side at Z = 0)
translate([-7.0, 0, 0])
    axle_pin();

translate([7.0, 0, 0])
    retaining_end_cap();
