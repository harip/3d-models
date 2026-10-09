/*
    DOUGLAS-FIR / Pseudotsuga menziesii
    3-inch (76.2 mm) miniature — parametric botanical interpretation

    Units: millimeters. The stem starts at z=0 and the terminal leader
    finishes at z=76.2. Branches/needles are deliberately made more
    robust than a strictly-to-scale 50-foot tree, to survive miniature
    modelling and resin printing. This is a species-informed miniature,
    not a botanical scan or a dimensionally faithful 3D reconstruction.

    Distinctive features:
      - continuous upright leader and graduated, irregular whorls;
      - layered, slightly drooping, upturned spreading main branches;
      - alternate lateral branchlets, not uniform spiral cone shelves;
      - individual slender, spirally distributed, forward-canted needles;
      - optional pendant seed cones with projecting three-lobed bracts.

    For fine visualization: detail = "fine" (default).
    For sturdier, less complex output: detail = "print".
    Cones are off by default: a small juvenile usually lacks seed cones.
    No display base is added unless explicitly enabled.

    Change height_mm to resize height; crown_diameter_mm controls width independently.
    To get an STL: Open with OpenSCAD, F6 (Render), F7 (Export STL),
    or run `openscad -o Douglas_Fir_3in.stl Douglas_Fir_3in.scad`.
*/

// ----- Customize here -----
height_mm          = 76.2;        // exactly 3 inches by default
crown_diameter_mm  = 47.0;        // natural narrow-pyramidal juvenile habit
branch_tiers       = 16;          // irregular spaced branch levels
foliage_density    = 1.0;         // 0.5 to 1.5 recommended
seed               = 29;          // deterministic variation
// "fine": thinner individual needles; "print": sturdier, fewer needles
detail             = "print";
show_seed_cones    = false;       // optional species-diagnostic 3-lobed bracts
show_base          = true;        // robust bed adhesion base disc for 3D printing

// ----- Internal dimensions and math -----
H   = 76.2;
SF  = height_mm / H;
CROWN_RADIUS = crown_diameter_mm / (2 * SF);
IS_PRINT = detail == "print";
$fn = IS_PRINT ? 7 : 9;

function add(a,b) = [a[0]+b[0], a[1]+b[1], a[2]+b[2]];
function sub(a,b) = [a[0]-b[0], a[1]-b[1], a[2]-b[2]];
function mul(a,s) = [a[0]*s, a[1]*s, a[2]*s];
function unit(v) = mul(v, 1/max(norm(v), 0.000001));
function interp(a,b,t) = add(mul(a,1-t),mul(b,t));
function clamp(x,lo,hi) = max(lo,min(hi,x));
function rand1(x) = 0.5+0.5*sin(x*127.135 + seed*59.728 + 37.17*sin(x*11.61));
function stem_pos(z) = [
    0.24*(sin(z*5.4)-sin(0)),
    0.23*(sin(z*4.2 + 33)-sin(33)), z
];
function stem_radius(z) = 0.11+1.90*pow(clamp(1-z/H,0,1),1.35);
function tier_z(t) = 7.2 + (t/(branch_tiers-1))*63.0 + (rand1(t+19)-0.5)*0.9;
function count_at_tier(t) = (t%6==2) ? 4 : ((t%5==1) ? 6 : 5);
function branch_angle(t,k,n) = t*79.3 + k*360/n + 14*(rand1(t*31+k+123)-0.5);
function branch_length(z,key) =
    CROWN_RADIUS*pow(clamp((H-z)/H,0,1),0.80)*(0.90+0.17*rand1(key+731));
function radial(a,r) = [r*cos(a),r*sin(a),0];
function bpt(z,ang,len,u,key) =
    add(stem_pos(z), add(
        radial(ang+(rand1(key+40)-0.5)*6*u, len*u),
        [0,0,len*(-0.065*sin(180*u)+0.095*u*u)]
    ));

// A polyhedral stem/branch segment, with slight axial overlap to ensure
// adjacent limbs and needles form a connected solid during STL export.
module tapered_link(a,b,r0,r1,overlap=0.08,facets=7) {
    d = sub(b,a);
    len = norm(d);
    dn = unit(d);
    if (len > 0.00001) {
        translate(sub(a,mul(dn,overlap)))
            rotate(a=acos(clamp(dn[2],-1,1)), v=[-dn[1],dn[0],0])
                cylinder(h=len+overlap*2,
                         r1=max(r0,0.006),r2=max(r1,0.006),$fn=facets);
    }
}

// Fir needles are narrow and somewhat flattened, rather than stiff radial
// spruce spines. At 1:~200 scale, renderable needle thickness is necessarily
// exaggerated. Radial distribution is biased to a gentle horizontal spray.
module needle_set(a,b,key,stem_radius_at_base=0.18,is_main=false) {
    v = sub(b,a);
    len = norm(v);
    along = unit(v);
    side = unit(cross(along,[0,0,1]));
    up = unit(cross(side,along));
    n0 = is_main ? 1.05 : 3.25;
    n = max(4,ceil(len*n0*foliage_density*(IS_PRINT?0.48:1.0)));
    for (i=[0:n-1]) {
        t = (i+0.42)/n;
        p = interp(a,b,t);
        ph = 137.508*i + 29.5*rand1(key) + key*13.7;
        spread = unit(add(mul(side,cos(ph)), mul(up,0.78*sin(ph)+0.20)));
        direction = unit(add(mul(spread,0.91),mul(along,0.42)));
        nz = p[2];
        needle_len = (IS_PRINT?1.46:1.93) *
            (0.69 + 0.34*(1 - nz/H)) * (0.86+0.27*rand1(key+i*1.91));
        base = add(p,mul(spread,stem_radius_at_base*0.39));
        tip_raw = add(base,mul(direction,needle_len));
        // Never let the finest needle overshoot the specified total height.
        tip = [tip_raw[0],tip_raw[1],min(H-0.18,tip_raw[2])];
        color([0.115+0.055*rand1(i+key),0.43+0.11*rand1(key+i*3),0.16])
            tapered_link(base,tip,IS_PRINT?0.22:0.115,
                          IS_PRINT?0.055:0.012,0.025,IS_PRINT?4:3);
    }
}

module side_shoot(z,ang,L,main_key,j,nshoot) {
    t = 0.19+(j+0.35)*(0.76/nshoot);
    base = bpt(z,ang,L,t,main_key);
    sgn = (j%2==0) ? 1:-1;
    sa = ang+sgn*(44+18*rand1(main_key*17+j+5));
    slen = L*(0.23+0.055*rand1(main_key+j+35))*
        pow(max(0,sin(180*t)),0.58);
    end = add(base,add(radial(sa,slen), [0,0,slen*(0.035+0.11*rand1(j+main_key))]));
    // A small brown woody axis extends into the parent branch.
    color([0.29,0.23,0.16])
        tapered_link(base,end,IS_PRINT?0.20:0.135,0.065,0.13,6);
    needle_set(base,end,main_key*73+j*3+15,IS_PRINT?0.20:0.135,false);
    // Tertiary offsets create feathery, irregular sprays on outer branchlets.
    if (!IS_PRINT && slen > 2.8)
        for (q=[0:1]) {
            fb = interp(base,end,0.49+q*0.23);
            fa = sa + (q==0?-68:67);
            fl = slen*(q==0?0.32:0.22);
            fe = add(fb, add(radial(fa,fl),[0,0,0.16*fl]));
            color([0.31,0.27,0.18])
                tapered_link(fb,fe,0.092,0.045,0.075,5);
            needle_set(fb,fe,main_key*157+j*19+q*5+301,0.08,false);
        }
}

module main_branch(t,k,n) {
    z = tier_z(t) + (rand1(t*17+k+88)-0.5)*0.65;
    ang = branch_angle(t,k,n);
    key = t*41+k*13+1;
    L = branch_length(z,key);
    // The first point lies inside the bole; three gently curved segments.
    p0 = bpt(z,ang,0.50,0,key);
    p1 = bpt(z,ang,L,0.36,key);
    p2 = bpt(z,ang,L,0.72,key);
    p3 = bpt(z,ang,L,1.00,key);
    r = (0.19+0.46*pow(L/CROWN_RADIUS,0.77));
    color([0.30,0.245,0.18]) {
        tapered_link(p0,p1,r,r*0.68,0.13,8);
        tapered_link(p1,p2,r*0.71,r*0.36,0.12,7);
        tapered_link(p2,p3,r*0.39,0.085,0.10,6);
    }
    // Needles primarily clothe younger 2/3 of each main branch.
    needle_set(interp(p1,p2,0.19),p2,key+430,r*0.41,true);
    needle_set(p2,p3,key+907,0.12,true);
    nshoot = max(3,round(3+10*L/CROWN_RADIUS));
    for (j=[0:nshoot-1])
        side_shoot(z,ang,L,key,j,nshoot);
    // The smaller reddish, pointed end bud is recognizable on close views.
    if (!IS_PRINT && L>6) {
        tip = add(p3,[0,0,0.45]);
        color([0.49,0.23,0.11]) tapered_link(p3,tip,0.14,0.01,0.06,5);
    }
}

module central_leader() {
    for (q=[0:23]) {
        z0=q*H/24;
        z1=(q+1)*H/24;
        color([0.35,0.27,0.20])
            tapered_link(stem_pos(z0),stem_pos(z1),
                         stem_radius(z0),stem_radius(z1),0,11);
    }
    // A few short leaders/needles below the true apex.
    for (j=[0:6]) {
        z=70.6+j*0.67;
        a=stem_pos(z);
        angle=j*137.508;
        b=add(a,radial(angle,1.6*(1-z/H)));
        needle_set(a,add(b,[0,0,0.40]),543+j,0.12,false);
    }
}

// Diagnostic downturned female cone. The three prongs of each bract are
// designed as a central point and two spreading projections. Cones are
// visually enlarged and OFF by default (true-size miniature cones vanish).
module hanging_cone(anchor,scale=1) {
    color([0.46,0.27,0.15])
        tapered_link(anchor,add(anchor,[0,0,-0.35*scale]),
                     0.16*scale,0.11*scale,0.05,6);
    translate(add(anchor,[0,0,-1.20*scale])) {
        color([0.47,0.29,0.17])
            scale([0.49*scale,0.49*scale,0.96*scale]) sphere($fn=11);
        for (q=[0:3],m=[0:4]) {
            az=m*72+q*33;
            z=0.52*scale-q*0.34*scale;
            collar=[0.35*scale*cos(az),0.35*scale*sin(az),z];
            color([0.61,0.39,0.23]) {
                tapered_link(collar,add(collar,[0,0,-0.46*scale]),
                             0.095*scale,0.012*scale,0,4);
                tapered_link(collar,add(collar,
                    [0.28*scale*cos(az+26),0.28*scale*sin(az+26),-0.25*scale]),
                    0.085*scale,0.012*scale,0,4);
                tapered_link(collar,add(collar,
                    [0.28*scale*cos(az-26),0.28*scale*sin(az-26),-0.25*scale]),
                    0.085*scale,0.012*scale,0,4);
            }
        }
    }
}

module optional_cones() {
    for (t=[3,6,9,11],k=[0:1]) {
        n=count_at_tier(t);
        z=tier_z(t);
        ang=branch_angle(t,k*2,n);
        L=branch_length(z,t*41+k*26+1);
        a=bpt(z,ang,L,0.77,t*41+k*26+1);
        hanging_cone(a,0.91+0.13*rand1(t+k));
    }
}

module whole_tree() {
    union() {
        central_leader();
        for (t=[0:branch_tiers-1]) {
            n=count_at_tier(t);
            for (k=[0:n-1]) main_branch(t,k,n);
        }
        if (show_seed_cones) optional_cones();
        if (show_base)
            color([0.27,0.24,0.19]) {
                union() {
                    // Thin 0.45mm breakaway wide base disc (32mm diameter) for bed adhesion
                    cylinder(h=0.45, r=16.0, center=false, $fn=48);
                    // Flared transition collar for solid trunk anchor
                    cylinder(h=1.2, r1=6.0, r2=2.8, center=false, $fn=32);
                }
            }
    }
}

// A single scale transform keeps exactly 76.2 mm height at default settings.
// Geometry extends no lower than z=0 and the leader ends at z=H.
scale([SF,SF,SF]) whole_tree();
