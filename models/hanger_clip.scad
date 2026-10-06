// ====================================================================
// Shared push-clip used by:
//   01 gondola roof socket, 03 hanger arm (both ends), 04 carriage socket.
// Include this file (include <hanger_clip.scad>;). It draws nothing itself.
// Change numbers ONLY here so all three parts stay matched.
// ====================================================================

// ---- Tuning (the only numbers you should ever need to touch) --------
clip_fit       = 0.20; // gap per side between neck and slot. Too tight? raise to 0.25-0.30
clip_catch     = 0.40; // how far each prong hooks past the slot edge (retention)
arm_th         = 4.0;  // hanger arm thickness (= print height of part 03)
arm_fit        = 0.25; // gap per side between arm thickness and slot

// ---- Clip shape -----------------------------------------------------
clip_neck_w    = 5.4;  // neck width (two 1.7 mm prongs + 2 mm slit)
clip_slit_w    = 2.0;  // slit that lets the prongs squeeze together
clip_lip       = 6.0;  // thickness of material the clip pushes through (01 and 04)
clip_gap       = 0.3;  // free play between head shoulder and lip
clip_head_flat = 1.0;  // straight part of the head before the 45-degree tip
clip_tip_w     = 3.4;  // width at the very tip

// ---- Derived (do not edit) ------------------------------------------
slot_w        = clip_neck_w + 2 * clip_fit;          // 5.8 slot, along arm face
slot_t        = arm_th + 2 * arm_fit;                // 4.5 slot, across arm thickness
clip_head_w   = slot_w + 2 * clip_catch;             // 6.6
clip_neck_len = clip_lip + clip_gap;                 // 6.3
clip_taper    = (clip_head_w - clip_tip_w) / 2;      // 45-degree lead-in
clip_len      = clip_neck_len + clip_head_flat + clip_taper;

// ---- Hanger arm (classic C shape) -----------------------------------
hanger_H      = 26.0;  // distance between the two stop faces (roof to carriage)
hanger_offset = 10.0;  // sideways offset of the vertical stem
hanger_bar    = 7.0;   // width of the arm's bars

// Clip outline, pointing -Y, its base (the stop face) on y = 0
module clip_2d() {
    translate([-clip_neck_w / 2, -clip_neck_len])
        square([clip_neck_w, clip_neck_len + 0.01]);
    polygon([
        [-clip_head_w / 2, -clip_neck_len],
        [ clip_head_w / 2, -clip_neck_len],
        [ clip_head_w / 2, -clip_neck_len - clip_head_flat],
        [ clip_tip_w / 2,  -clip_len],
        [-clip_tip_w / 2,  -clip_len],
        [-clip_head_w / 2, -clip_neck_len - clip_head_flat]
    ]);
}

// Slit between the prongs, with a round root to avoid cracking
module clip_slit_2d() {
    translate([-clip_slit_w / 2, -clip_len - 1])
        square([clip_slit_w, clip_len + 2]);
    translate([0, 1.0]) circle(d = clip_slit_w, $fn = 24);
}

// C-shaped arm body; lower stop face on y = 0, upper stop face on y = hanger_H
module hanger_body_2d() {
    offset(r = 2) offset(delta = -2)          // round outside corners
    offset(r = -1.5) offset(delta = 1.5)      // round inside corners
    union() {
        translate([-5, 0])
            square([hanger_offset + 3.5 + 5, hanger_bar]);
        translate([hanger_offset - 3.5, 0])
            square([7, hanger_H]);
        translate([-5, hanger_H - hanger_bar])
            square([hanger_offset + 3.5 + 5, hanger_bar]);
    }
}

module hanger_arm_2d() {
    difference() {
        union() {
            hanger_body_2d();
            clip_2d();                                          // bottom clip -> gondola
            translate([0, hanger_H]) mirror([0, 1]) clip_2d();  // top clip -> carriage
        }
        clip_slit_2d();
        translate([0, hanger_H]) mirror([0, 1]) clip_slit_2d();
    }
}

// Part 03 as printed: lying flat, arm_th tall
module hanger_arm_print() {
    linear_extrude(height = arm_th) hanger_arm_2d();
}

// Part 03 as installed: standing up, lower stop face on z = 0, thickness centred on y = 0
module hanger_arm_installed() {
    translate([0, arm_th / 2, 0]) rotate([90, 0, 0]) hanger_arm_print();
}

// Cutter for the receiving slot. Entry face on z = 0, slot runs toward +Z.
// 'lead' = 45-degree chamfer at the entry so the clip finds the slot.
module clip_socket_cut(depth, lead = 0.6) {
    translate([-slot_w / 2, -slot_t / 2, -1])
        cube([slot_w, slot_t, depth + 2]);
    hull() {
        translate([-slot_w / 2 - lead, -slot_t / 2 - lead, -1])
            cube([slot_w + 2 * lead, slot_t + 2 * lead, 1]);
        translate([-slot_w / 2, -slot_t / 2, lead])
            cube([slot_w, slot_t, 0.01]);
    }
}
