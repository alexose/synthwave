use <threads.scad>

base_radius = 283 / 2; // inner diameter of 5 gallon bucket in mm

container_bottom_radius = 89 / 2;
container_top_radius = 112 / 2;
container_height = 135.3;

pump_mount_depth = 8;
pump_mount_height = container_height + 20;

rear_wall_height = 245;
rear_wall_width = 128;
rear_wall_thickness = 3;

electrode_holder_width = 14;
electrode_holder_height = 100;
electrode_holder_depth = 4;
electrode_holder_radius = 1;

distance_between_containers = 14;

default_screw_radius = 1;

$fn = 50;

render_base = 0;
render_base_no_lid = 0;
render_electrode_holder = 1;
render_pump_bracket = 0;
render_container_cover = 0;
render_back_cover = 0;
render_standoffs = 0;

if (render_base) base();
if (render_base_no_lid) base(false);
if (render_electrode_holder) {
    translate([0, -20]) electrode_holder(); 
    // clip();
}
if (render_pump_bracket) pump_bracket();
if (render_container_cover) container_cover();
if (render_back_cover) back_cover();
if (render_standoffs) pcb_standoffs();

module base(include_lid=true) {
    border_width = 10;
    dr = container_bottom_radius;
    bw = border_width;
    
    d = dr + bw * 2;
    r = 20;
        
    dist = dr + distance_between_containers;
    
    pw = 108;
    rw = 56;
    
    y = -3; // nudge forward
    
    // translate([dist, 0]) container();
    // translate([-dist, 0]) container();
    
    difference() {
        union() {
            if (include_lid) {
                lid();
            }
            translate([dist, y]) cylinder(30, r=dr+2, $fn = 140);
            translate([-dist, y]) cylinder(30, r=dr+2, $fn = 140);
            translate([pw, y]) mirror([0, 1, 0]) rotate([0, 0, 180]) pump_mount();
            translate([-pw, y]) pump_mount();
            translate([0, rw]) rear_wall();
            translate([pw + 4, 54.5, 107]) band(35);
            translate([-pw - 4, 54.5, 107]) mirror([1,0,0]) band(35);
        }
        
        a = 45;
        translate([dist, y, -5]) mirror([1, 0]) rotate([180, 180])  solenoid_funnel();
        translate([-dist, y, -5]) rotate([180, 180]) solenoid_funnel();
        translate([0, rw-2, 105]) rotate([90, 270, 0]) linear_extrude(1.2) text("synthwave", size=20, halign="center", valign="center", spacing=1.3);
    }

    module rear_wall() {
        h = rear_wall_height;
        o = rear_wall_thickness;
        w = rear_wall_width / 2;
        
        r = 1;
        w2 = 120;
        h2 = 60;
        
        difference() {
            rotate([90, 0]) rear_wall_polygon();
            translate([0, -1, 115]) rotate([-90, 0]) pcb_screw_holes();
            translate([-17, -1, 175]) rotate([-90, 0]) ph_meter_screw_holes();
            translate([0, -1, 55]) rotate([-90, 0]) ph_meter_screw_holes();
            translate([17, -1, 175]) rotate([-90, 0]) ph_meter_screw_holes();  
        }
        
        translate([0, 0, 175]) shelf();
        
        module rear_wall_cutouts() {
            r = 120;
            c = 35;
            h = 30;
            b = 80;
            $fn = 100;
            
            translate([r + c, 10, b]) rotate([90, 0]) cylinder(h, r=r);
            translate([-r - c, 10, b]) rotate([90, 0]) cylinder(h, r=r);
        }
        
        module rear_wall_holes() {
            r = 12/2;
            c = 48.3/2;
            h = 30;
            b = 205;
            $fn = 80;
            
            translate([r + c, 10, b]) rotate([90, 0]) cylinder(h, r=r);
            translate([-r - c, 10, b]) rotate([90, 0]) cylinder(h, r=r);
        }
    }
}

        
module rear_wall_polygon(height=1, offset=0, def=1) {
    h = rear_wall_height;
    w = rear_wall_width;
    t = rear_wall_thickness;
    
    hf = h / 32;
    wf = w / 24;
    
    // 24x32
    scale([1, 1, t]) 
    translate([-w/2, 0])
    linear_extrude(height)
    offset(r=offset)
    scale([wf, hf])
    if (def == 1){
        rear_wall_polygon_def();
    } else {
        rear_wall_polygon_def2();
    }
}

module rear_wall_polygon_def() {
    polygon([[2,0/*1:0,0,0,0*/] ,[3.07,0] ,[4.08,0] ,[5.13,0] ,[6.32,0] ,[7.36,0] ,[8.47,0] ,[9.62,0] ,[10.8,0] ,[12,0] ,[13.2,0] ,[14.38,0] ,[15.53,0] ,[16.64,0] ,[17.68,0] ,[18.88,0] ,[19.92,0] ,[20.93,0] ,[21.95,0],[22,0/*1:0,0,0,0*/] ,[21.5,0.87] ,[20.97,1.87] ,[20.53,2.77] ,[20.07,3.81] ,[19.6,4.96] ,[19.25,5.95] ,[18.92,6.99] ,[18.63,8.07] ,[18.39,9.18] ,[18.21,10.31] ,[18.11,11.45] ,[18.1,12.58] ,[18.19,13.71] ,[18.39,14.81] ,[18.72,15.87] ,[19.18,16.9] ,[19.8,17.87] ,[20.58,18.77] ,[21.53,19.6] ,[22.36,20.17] ,[23.31,20.69],[24,21/*1:-12,-5,0,5*/] ,[24,22.09] ,[24,23.16] ,[24,24.19],[24,25/*1:0,0,0,0*/] ,[22.9,25.16] ,[21.78,25.3] ,[20.71,25.42] ,[19.68,25.52] ,[18.54,25.61] ,[17.29,25.7] ,[16.23,25.76] ,[15.11,25.82] ,[13.93,25.86] ,[12.71,25.88] ,[11.45,25.89] ,[10.15,25.88] ,[8.81,25.84] ,[7.79,25.8] ,[6.76,25.75] ,[5.71,25.68] ,[4.65,25.59] ,[3.59,25.49] ,[2.52,25.36] ,[1.44,25.22] ,[0.36,25.06],[0,25/*1:12,2,0,-2*/] ,[0,23.99] ,[0,22.92] ,[0,21.82],[0,21/*1:0,5,12,-5*/] ,[1.02,20.52] ,[1.93,19.99] ,[2.97,19.2] ,[3.83,18.33] ,[4.53,17.39] ,[5.07,16.39] ,[5.46,15.34] ,[5.72,14.26] ,[5.87,13.15] ,[5.91,12.02] ,[5.85,10.88] ,[5.71,9.75] ,[5.5,8.63] ,[5.23,7.53] ,[4.92,6.47] ,[4.58,5.45] ,[4.21,4.49] ,[3.74,3.38] ,[3.29,2.39] ,[2.79,1.4] ,[2.27,0.45]]);
}

module rear_wall_polygon_def2() {
    polygon([[3,1/*1:0,0,0,0*/] ,[4.09,1] ,[5.23,1] ,[6.44,1] ,[7.59,1] ,[8.82,1] ,[9.86,1] ,[10.92,1] ,[12,1] ,[13.08,1] ,[14.14,1] ,[15.18,1] ,[16.41,1] ,[17.56,1] ,[18.58,1] ,[19.62,1] ,[20.67,1],[21,1/*1:0,0,0,0*/] ,[20.49,1.93] ,[20.01,2.91] ,[19.54,3.98] ,[19.14,5] ,[18.75,6.13] ,[18.46,7.09] ,[18.21,8.09] ,[18,9.13] ,[17.85,10.19] ,[17.77,11.26] ,[17.77,12.34] ,[17.86,13.41] ,[18.06,14.48] ,[18.37,15.51] ,[18.81,16.51] ,[19.39,17.47] ,[20.11,18.38] ,[21,19.22] ,[22.06,20] ,[22.98,20.52],[24,21/*1:-12,-5,0,5*/] ,[24,22.07] ,[24,23.07] ,[24,24.1],[24,24/*1:0,0,0,0*/] ,[22.9,24.16] ,[21.78,24.3] ,[20.71,24.42] ,[19.68,24.52] ,[18.54,24.61] ,[17.29,24.7] ,[16.23,24.76] ,[15.11,24.82] ,[13.93,24.86] ,[12.71,24.88] ,[11.45,24.89] ,[10.15,24.88] ,[8.81,24.84] ,[7.79,24.8] ,[6.76,24.75] ,[5.71,24.68] ,[4.65,24.59] ,[3.59,24.49] ,[2.52,24.36] ,[1.44,24.22] ,[0.36,24.06],[0,24/*1:12,2,0,-2*/] ,[0,22.98] ,[0,21.92],[0,21/*1:0,5,12,-5*/] ,[1.02,20.52] ,[1.94,20] ,[3,19.22] ,[3.89,18.38] ,[4.61,17.47] ,[5.19,16.51] ,[5.63,15.51] ,[5.94,14.48] ,[6.14,13.41] ,[6.23,12.34] ,[6.23,11.26] ,[6.15,10.19] ,[6,9.13] ,[5.79,8.09] ,[5.54,7.09] ,[5.25,6.13] ,[4.86,5] ,[4.46,3.98] ,[3.99,2.91] ,[3.51,1.93] ,[3.02,1.04]]);
}


module lid() {
    br = base_radius; 
    h = 1;
    r = 8;
    d = 430;
    y = 10; // nudge forward
    
    translate([0, y]) difference() { 
        union() {
            difference() {
                cylinder(h, r=br);
                translate([115, -50, -20]) cylinder(100, r=5);
                translate([-115, -50, -20]) cylinder(100, r=5);
                translate([0, 47.5, -20]) cylinder(100, r=3.5);
            }
            
            $fn = 160;
            rotate_extrude() translate([br, 0]) lid_cutout_shape();
            
            // Anti flex bars
            w = br * 2 - 24;
            h = 1.6;
            d = 8;
            b = 70;
            n = 0;
            
            translate([0, b - n, d/2]) cube([w,h,d], center=true);
            translate([0, -b - n, d/2]) cube([w,h,d], center=true);
        }
        translate([0, -d/2]) cube([br*2, br*2, 40], center=true);
        translate([0, d/2]) cube([br*2, br*2, 40], center=true);
    }
}

module shelf(makeSquare=false, extraHoles=false) {
    difference() {
        translate([0, 0, -6]) shelf_brackets();
        d1 = 220;
        d2 = 220;
        d3 = 150;
        d4 = 100;
        z = 20;
        
        // translate([-d1/2, -17, z]) rotate([0, 90]) cylinder(d1, r=5);
        translate([-d2/2, -17, z]) rotate([0, 90]) cylinder(d2, r=6.5);
        translate([-d4/2, -17, z]) rotate([0, 90]) cylinder(d4, r=14);
    }
}


module shelf_brackets() {
    d = 67;

    translate([d, -2]) rotate([0, 0, 270]) vac_shelf_bracket();
    // mirror([1, 0, 0]) translate([d, -2]) rotate([0, 0, 270]) valve_shelf_bracket();
    mirror([1, 0, 0]) translate([d, -2]) rotate([0, 0, 270]) vac_shelf_bracket();
}

module vac_shelf_bracket() {
    t = 2;
    h = 40;
    w = 67;
    d = 10;
    o = -5;
    v = 5;
    
    difference() {
        hull() {
            translate([o - 0.7, -d/2 + 3, h]) scale(1.06)  vac_footprint(v);
            sphere(t);
        }
        translate([o + 0.6, -d/2 + 3, h+1]) vac_footprint(v);
    }
}

module valve_shelf_bracket() {
    t = 2;
    h = 40;
    w = 67;
    d = 10;
    o = -5;
    
    difference() {
        hull() {
            translate([o - 0.7, -d/2 + 3, h]) scale(1.06) valve_footprint(1);
            sphere(t);
        }
        translate([o + 15, -d/2 + 3, h]) rotate([0, 0, 0]) three_way_valve_mount();
    }
}

module vac_footprint(h) {
    x = 39;
    y = 63;
    z = h;
    r = 10;
    
    rotate([0, 0, 90]) translate([-x/2, -y+r*2]) hull() {
        cube([x, y-r, z]);
        translate([x-r, 0]) cylinder(z, r=r);
        translate([r, 0]) cylinder(z, r=r);
    }
}


module valve_footprint(h) {
    x = 39;
    y = 50;
    z = h;
    r = 10;
    
    rotate([0, 0, 90]) translate([-x/2, -y+r*2]) hull() {
        cube([x, y-r, z]);
        translate([x-r, 0]) cylinder(z, r=r);
        translate([r, 0]) cylinder(z, r=r);
    }
}
module container_cover() {

    container_top_upper_radius = 109 / 2;

    h1 = 1.6;
    h2 = 8;
    r1 = container_top_upper_radius;
    r2 = r1 + 2;
    r3 = 25/2;
    r4 = 30/2;
    $fn = 80;
    
    d = distance_between_containers;
    a = r1*2 + d/2 + r3 + 8;
    t = 1.2;
    
    fh = 15; // float sensor height, adjust this if you want different water levels
    
    cover();
    mirror([1, 0, 0]) cover();
    
    module cover() {
        difference() {
            union() {
                holes(1.2);
                half();
                translate([r1 + 30, 20]) cylinder(15, r=6);
            }
            scale([1, 1, 2]) holes();
            translate([r1 + 30, 20]) ScrewThread(8.6, 15, 1.1);
        }
    }
    
    
    
    module half() {
        difference() {
            translate([r1 + d/2, 0]) cylinder(h2, r1, r1-0.5);
            translate([r1 + d/2, 0]) cylinder(h2, r1 - t, r1-0.5 - t);
        }
        translate([r1 + d/2, 0]) cylinder(h1, r=r2);
    }
    
    module holes(t=0) {
        f = 1;
        w = electrode_holder_width + f;
        d = electrode_holder_depth + f;
        r = electrode_holder_radius;
        h = 10;
        
        o = r1 + d/2;
        // translate([o + 30, 20, 1]) cylinder(h, r=14.5/2 + t, $fn=6); // switch holder
        // translate([o + 30, 20]) cylinder(h, r=8.5/2 + t, $fn=80); // switch holder
        translate([o + 30, -20]) cylinder(h, r=13/2 + t, $fn=80); // pH probe holder
        
        $fn = 20;
        translate([o, 0]) hull() standoffs(h, w + t - r, d + t - r, r);
        translate([o, 0]) hull() standoffs(h, 9 - r + t, w + t - 11, r);
    }
}

module lid_cutout_shape() {
//polygon([[-8,0/*1:0,0,0,0*/] ,[-7.94,1.02] ,[-7.87,2.12] ,[-7.8,3.12] ,[-7.74,4.19] ,[-7.67,5.26] ,[-7.59,6.48] ,[-7.53,7.59] ,[-7.45,8.82] ,[-7.39,9.83] ,[-7.32,10.9] ,[-7.25,12.06] ,[-7.17,13.29] ,[-7.09,14.6],[-7,16/*1:-1,-16,6,4*/] ,[-6.09,16.54] ,[-5.15,16.97] ,[-4.2,17.3] ,[-3.05,17.57] ,[-1.9,17.73] ,[-0.77,17.78] ,[0.34,17.74] ,[1.4,17.63] ,[2.41,17.47] ,[3.51,17.23] ,[4.49,16.96] ,[5.45,16.64] ,[6.43,16.26],[7,16],[8,0/*1:0,0,0,0*/] ,[6.9,0] ,[5.85,0] ,[4.74,0] ,[3.71,0] ,[2.6,0] ,[1.43,0] ,[0.24,0] ,[-0.96,0] ,[-2.14,0] ,[-3.27,0] ,[-4.34,0] ,[-5.5,0] ,[-6.63,0] ,[-7.63,0]]);

    scale(0.7) polygon([[3,10],[14,10],[15,17],[17,17],[17,0],[15,0],[14,7],[3,7],[2,0],[0,0],[0,17],[2,17]]);

}

module pump_mount() {
    h = pump_mount_height;
    w = pump_mount_depth;
    d = 27;
    r = 3;

    difference() {
        hull() standoffs(h, w, d, r);
        translate([-8.5, 0, 115]) rotate([90, 0, 90]) three_way_valve_mount();
        translate([-8.5, 0, 50]) rotate([90, 0, 90]) three_way_valve_mount();
    }
}

module pump_bracket() {
    t = 1.6;
    h = 10;
    y = 22;
    r = 26.5 / 2;  // outer diameter of pump
    g = 8; // gap
    r1 = 1.5;
    o = 4;
    
    r2 = 50;
    
    intersection() {
        difference() {
            union() {
                translate([0, -r - t]) difference() {
                    $fn = 50;
                    // translate([0, 5]) cube([t, h, h]);
                    cylinder(h, r=r+t);
                    cylinder(h, r=r);
                }
                translate([0, r2 - t - 0.5]) difference() {
                    cylinder(h, r=r2, $fn=120);
                    cylinder(h, r=r2 - t, $fn=120);
                }
            }
            translate([-g/2, -10]) cube([g, h, h]);
            translate([0,3,h/2]) pump_bracket_screw_holes();
        }
        translate([0, -10]) cylinder(h, r=25);
    }
}

module pump_bracket_screw_holes(r=default_screw_radius) {
    o = 4;
    y = 21.5;
    
    translate([-y + o, 0]) rotate([90, 0]) cylinder(10, r=r);
    translate([y - o, 0]) rotate([90, 0]) cylinder(10, r=r);
}

module band(h=10, c=1) {
    r = 50;
    num = 90;
    w = 3;
    
    difference() {
        translate([-r, -r]) {
            for(i = [20:num - 1]) {
                hull() {
                    rotate([0,0,i]) translate([r, 0, i * 0.6 * c]) cube([w,w,h]);
                    rotate([0,0,i+1]) translate([r, 0, (i+1) * 0.6 * c]) cube([w,w,h]);
                }
            }
        }
        translate([-25, -13, 50]) rotate([0, 0, 150]) pump_bracket_screw_holes();
    }
    
}

module electrode_grip() {
    h = 20;
    r = 1;
    
    hull () {
        translate([2, 0]) cylinder(h, r=r);
        translate([-2, 0]) cylinder(h, r=r);
    }
    hull () {
        translate([2, 20]) cylinder(h, r=r);
        translate([-2, 20]) cylinder(h, r=r);
    }
}
    
module electrode_holder() {

    w = electrode_holder_width;
    h = electrode_holder_height;
    d = electrode_holder_depth;
    r = electrode_holder_radius;
    
    difference() {
        hull() standoffs(h-r, w-r, d, r);
        translate([0, d/2 + 1]) nickel_strip_cutout();
        translate([0, -d/2 - 1]) rotate([0, 0, 180]) nickel_strip_cutout();
    }
}

module nickel_strip_cutout() {
    d = 0.8;
    h = electrode_holder_height;
    w = 22;
    
    translate([0, 0, h/2 + 1]) {
        cube([w, d, h], center=true); // strip
        translate([0, d+1 / 2]) cube([w-4, d+1, h-1], center=true); // window 
        // translate([2, 0, -h/2 + 4]) cylinder(h, r=1.5); // make room for wire
        // translate([2, 5.2, -1.5]) sphere(r=7); // make room for solder blob
    }
}

module clip() {
    linear_extrude(15) clip_polygon2();
    /*
    difference() {
        linear_extrude(35) clip_polygon();
        translate([-10, 0, 5]) linear_extrude(25) clip_middle_polygon();
    }
    */
}

module clip_polygon() {
    polygon([[-15,2],[-2,2],[-2,4],[15,6],[15,2],[16,2],[16,0],[-16,0],[-60,-5],[-60,-3/*1:0,0,0,0*/] ,[-58.82,-2.86] ,[-57.76,-2.73] ,[-56.41,-2.57] ,[-55.22,-2.43] ,[-53.9,-2.27] ,[-52.47,-2.1] ,[-51.45,-1.98] ,[-50.39,-1.86] ,[-49.3,-1.73] ,[-48.17,-1.59] ,[-47.01,-1.45] ,[-45.82,-1.31] ,[-44.61,-1.17] ,[-43.38,-1.02] ,[-42.14,-0.87] ,[-40.89,-0.72] ,[-39.63,-0.57] ,[-38.37,-0.43] ,[-37.11,-0.28] ,[-35.86,-0.13] ,[-34.62,0.02] ,[-33.39,0.17] ,[-32.18,0.31] ,[-30.99,0.45] ,[-29.83,0.59] ,[-28.7,0.73] ,[-27.61,0.86] ,[-26.55,0.98] ,[-25.53,1.1] ,[-24.1,1.27] ,[-22.78,1.43] ,[-21.59,1.57] ,[-20.55,1.7] ,[-19.41,1.83] ,[-18.3,1.96],[-18,2/*1:0,0,0,0*/] ,[-17.14,2.65] ,[-16.31,3.38] ,[-15.49,4.2] ,[-14.78,5.03] ,[-14.1,5.96] ,[-13.5,7] ,[-13.1,7.93] ,[-12.82,8.91] ,[-12.68,9.94] ,[-12.71,11.02] ,[-12.94,12.13] ,[-13.39,13.26] ,[-13.94,14.19] ,[-14.65,15.13] ,[-15.56,16.08] ,[-16.38,16.8] ,[-17.31,17.52],[-18,18/*1:12,-8,-3,1*/] ,[-19.13,18.24] ,[-20.2,18.4] ,[-21.53,18.57] ,[-22.68,18.71] ,[-23.96,18.85] ,[-25.34,19] ,[-26.83,19.15] ,[-27.86,19.25] ,[-28.93,19.36] ,[-30.04,19.46] ,[-31.16,19.57] ,[-32.32,19.68] ,[-33.49,19.79] ,[-34.68,19.89] ,[-35.88,20] ,[-37.09,20.11] ,[-38.3,20.22] ,[-39.52,20.32] ,[-40.73,20.43] ,[-41.94,20.53] ,[-43.14,20.63] ,[-44.33,20.73] ,[-45.5,20.83] ,[-46.65,20.93] ,[-47.78,21.02] ,[-48.88,21.11] ,[-49.95,21.2] ,[-50.99,21.28] ,[-51.99,21.37] ,[-53.41,21.48] ,[-54.72,21.58] ,[-55.92,21.68] ,[-56.99,21.76] ,[-58.19,21.86] ,[-59.29,21.94],[-60,22],[-60,24],[-16,20],[16,20],[16,18],[15,18],[15,14],[-2,16/*1:0,0,0,0*/] ,[-2,17],[-2,18/*1:0,0,0,0*/] ,[-3.05,18] ,[-4.15,18] ,[-5.18,18] ,[-6.34,18] ,[-7.39,18] ,[-8.47,18] ,[-9.56,18] ,[-10.62,18] ,[-11.64,18] ,[-12.73,18] ,[-13.81,18] ,[-14.87,18],[-15,18/*1:2,0,10,-8*/] ,[-14.15,17.28] ,[-13.41,16.56] ,[-12.57,15.61] ,[-11.89,14.66] ,[-11.37,13.73] ,[-10.91,12.58] ,[-10.65,11.46] ,[-10.56,10.37] ,[-10.62,9.32] ,[-10.81,8.32] ,[-11.18,7.18] ,[-11.66,6.13] ,[-12.22,5.18] ,[-12.81,4.33] ,[-13.5,3.48] ,[-14.2,2.73] ,[-14.95,2.04]]);
}

module clip_polygon2() {
    polygon([[-15,5],[-2,5],[-2,7],[15,8],[15,4],[16,4],[16,3/*1:0,0,0,0*/] ,[14.92,3] ,[13.8,3] ,[12.67,3] ,[11.36,3] ,[10.26,3] ,[9.09,3] ,[7.85,3] ,[6.54,3] ,[5.19,3] ,[3.81,3] ,[2.39,3] ,[0.96,3] ,[-0.48,3] ,[-1.92,3] ,[-3.34,3] ,[-4.74,3] ,[-6.1,3] ,[-7.42,3] ,[-8.68,3] ,[-9.88,3] ,[-11,3] ,[-12.04,3] ,[-13.26,3] ,[-14.29,3] ,[-15.42,3],[-16,3/*1:0,0,0,0*/] ,[-17.01,2.79] ,[-18.04,2.58] ,[-19.02,2.38] ,[-20.16,2.15] ,[-21.45,1.88] ,[-22.87,1.59] ,[-23.89,1.39] ,[-24.95,1.17] ,[-26.06,0.94] ,[-27.21,0.71] ,[-28.4,0.46] ,[-29.61,0.22] ,[-30.86,-0.04] ,[-32.12,-0.3] ,[-33.41,-0.56] ,[-34.71,-0.83] ,[-36.02,-1.1] ,[-37.34,-1.37] ,[-38.66,-1.63] ,[-39.98,-1.9] ,[-41.29,-2.17] ,[-42.59,-2.44] ,[-43.88,-2.7] ,[-45.14,-2.96] ,[-46.39,-3.22] ,[-47.6,-3.46] ,[-48.79,-3.71] ,[-49.94,-3.94] ,[-51.05,-4.17] ,[-52.11,-4.39] ,[-53.12,-4.59] ,[-54.55,-4.88] ,[-55.84,-5.15] ,[-56.98,-5.38] ,[-57.96,-5.58] ,[-58.99,-5.79] ,[-59.99,-6],[-60,-6/*1:0,0,0,0*/] ,[-60,-5],[-60,-4/*1:0,0,0,0*/] ,[-58.82,-3.75] ,[-57.76,-3.52] ,[-56.77,-3.31] ,[-55.63,-3.06] ,[-54.36,-2.79] ,[-52.96,-2.49] ,[-51.97,-2.28] ,[-50.93,-2.06] ,[-49.85,-1.83] ,[-48.74,-1.59] ,[-47.59,-1.34] ,[-46.41,-1.09] ,[-45.22,-0.83] ,[-44,-0.57] ,[-42.76,-0.31] ,[-41.51,-0.04] ,[-40.26,0.23] ,[-39,0.5] ,[-37.74,0.77] ,[-36.49,1.04] ,[-35.24,1.31] ,[-34,1.57] ,[-32.78,1.83] ,[-31.59,2.09] ,[-30.41,2.34] ,[-29.26,2.59] ,[-28.15,2.83] ,[-27.07,3.06] ,[-26.03,3.28] ,[-25.04,3.49] ,[-23.64,3.79] ,[-22.37,4.06] ,[-21.23,4.31] ,[-20.24,4.52] ,[-19.18,4.75] ,[-18.2,4.96],[-18,5/*1:0,0,0,0*/] ,[-17.04,5.55] ,[-16.2,6.11] ,[-15.37,6.74] ,[-14.54,7.5] ,[-13.79,8.35] ,[-13.17,9.3] ,[-12.78,10.34] ,[-12.67,11.44] ,[-12.87,12.43] ,[-13.39,13.45] ,[-14.1,14.32] ,[-14.86,15.03] ,[-15.82,15.74] ,[-16.67,16.28] ,[-17.65,16.82],[-18,17/*1:12,-6,-3,1*/] ,[-19.13,17.31] ,[-20.2,17.56] ,[-21.53,17.87] ,[-22.68,18.13] ,[-23.96,18.42] ,[-25.34,18.72] ,[-26.32,18.94] ,[-27.34,19.16] ,[-28.39,19.38] ,[-29.48,19.62] ,[-30.6,19.86] ,[-31.74,20.1] ,[-32.9,20.35] ,[-34.08,20.6] ,[-35.27,20.85] ,[-36.48,21.11] ,[-37.69,21.36] ,[-38.91,21.62] ,[-40.12,21.88] ,[-41.34,22.13] ,[-42.54,22.38] ,[-43.74,22.63] ,[-44.92,22.88] ,[-46.08,23.12] ,[-47.22,23.36] ,[-48.34,23.59] ,[-49.42,23.82] ,[-50.48,24.03] ,[-51.49,24.25] ,[-52.95,24.55] ,[-54.3,24.82] ,[-55.53,25.08] ,[-56.65,25.31] ,[-57.91,25.57] ,[-58.9,25.78] ,[-59.9,25.98],[-60,26],[-60,28],[-16,19],[16,19],[16,18/*1:0,0,0,0*/],[15,18/*1:0,0,0,0*/] ,[15,16.98] ,[15,15.94] ,[15,14.91],[15,14/*1:0,0,0,0*/] ,[13.97,14.06] ,[12.89,14.12] ,[11.75,14.19] ,[10.67,14.25] ,[9.5,14.32] ,[8.27,14.4] ,[7.26,14.46] ,[6.25,14.51] ,[5.23,14.57] ,[4.23,14.63] ,[3.02,14.7] ,[1.89,14.77] ,[0.85,14.83] ,[-0.23,14.9] ,[-1.32,14.96],[-2,15/*1:0,0,0,0*/] ,[-2,16],[-2,17/*1:0,0,0,0*/] ,[-3.05,17] ,[-4.15,17] ,[-5.18,17] ,[-6.34,17] ,[-7.39,17] ,[-8.47,17] ,[-9.56,17] ,[-10.62,17] ,[-11.64,17] ,[-12.73,17] ,[-13.81,17] ,[-14.87,17],[-15,17/*1:2,0,9,-6*/] ,[-14,16.28] ,[-13.17,15.56] ,[-12.34,14.67] ,[-11.73,13.79] ,[-11.26,12.76] ,[-11.03,11.76] ,[-11.03,10.64] ,[-11.27,9.59] ,[-11.69,8.62] ,[-12.24,7.73] ,[-12.94,6.84] ,[-13.65,6.11] ,[-14.42,5.44]]);
}

module clip_middle_polygon() {
    polygon([[-32,9],[-32,11],[0,11],[0,9]]);
}

module container() {
    r1 = container_bottom_radius;
    r2 = container_top_radius;
    h = container_height;
    cylinder(h, r1, r2);
    // translate([0, 0, h]) cylinder(h, r2, r2);
}

module back_cover() {
    h = 5;
    d = 0; // offset from original
    
    t = 1.2;
    difference() {
        rear_wall_polygon(h, -d, 2);
        translate([0, 0, t]) rear_wall_polygon(h,-d-t, 2);
        translate([36, 80]) window(); // Somewhat tricky to line this up
        
        translate([x - 10, y - 3, 15]) rotate([-90, 0]) cylinder(20, r=3);
        translate([10, y - 3, 15]) rotate([-90, 0]) cylinder(20, r=3);
        translate([x/2, 0, 15]) rotate([-90, 0]) cylinder(20, r=3);
    }
    
    x = 102;
    y = 200;
    a = 20;
    
    translate([a, d+t + 7.5, 5]) screw_bracket();
    translate([x - a, d+t + 7.5, 5]) screw_bracket();
    translate([a, y+d+t - 13.5, 5]) rotate([0,0,180 + 5]) screw_bracket();
    translate([x - a, y+d+t - 13.5, 5])  rotate([0,0,180 - 5]) screw_bracket();
    
    
    
    module window() {
        cube([11, 22, t]);
    }
}


module solenoid_funnel() {
    h = 15;
    r1 = 15;
    r2 = container_bottom_radius;
    diameter = 21.336 + 0.5; // adding 0.5mm because otherwise it's very difficult to screw in the solenoids
    
    $fn = 100;
     
    translate([0, 0, h]) cylinder(h, r1, r2 - 2);
    translate([0, 0, h*2-4]) container();
    
    translate([0, 0, h]) rotate([180, 0]) ScrewThread(diameter, h, pitch=2.209);
    
    // Hole for drain line
    translate([0, 0, 20]) rotate([90, 0, 90-45]) cylinder(60, r=5);
    translate([0, 0, 20]) rotate([90, 0, 90+45]) cylinder(60, r=5);
    // english_thread(diameter=1.05, threads_per_inch=14, length=3/4, taper=1/16);
}

module standoffs(h, w, d, r) {
    translate([w-r, d-r]) cylinder(h, r, r);
    translate([w-r, -d+r]) cylinder(h, r, r);
    translate([-w+r, d-r]) cylinder(h, r, r);
    translate([-w+r, -d+r]) cylinder(h, r, r);
}

module screw_bracket() {
    w = 1;
    s = 10;
    o = 0;
    t = 1.2;
    
    
    translate([0,0,s]) rotate([0, 180]) difference() {
        scale(s) translate([w/2, 0, w]) rotate([0, 90, 180]) linear_extrude(w) polygon([[0,0],[1,0],[1,1]]);
        translate([0, -t, t]) scale([s-t*2, s, s]) translate([w/2, 0, w]) rotate([0, 90, 180]) linear_extrude(w) polygon([[0,0],[1,0],[1,1]]);
        translate([0, -s/2 + o]) cylinder(15, r=1);
    }
}

// Helps to separate the PCB from the shell
module pcb_standoffs() {
    h = 10;
    w = 5;
    d = 5;
    r1 = 1;
    r2 = 2;
    
    difference() {
        standoffs(h, w + r1, d + r1, r2);
        standoffs(h, w, d, r1);
    }
}

module pcb_screw_holes(r=default_screw_radius) {
    h = 20;
    x = 52.070 / 2;
    y = 97.790 / 2;
    
    standoffs(h, x+r, y+r, r);
}

module ph_meter_screw_holes(r=default_screw_radius) {
    h = 20;
    x = 25 / 2;
    
    translate([-x, 0]) cylinder(20, r=r);
    translate([x, 0]) cylinder(20, r=r);
}

module three_way_valve_screw_holes(r=default_screw_radius) {
    d = 38;
    translate([d/2, 0]) cylinder(20, r=r);
    translate([-d/2, 0]) cylinder(20, r=r);
}

module three_way_valve_mount() {
    w = 47/2;
    h = 3.2;
    d = 11/2;
    r = 1.3;
    distance_apart = 25;
  
    hull() standoffs(h, w, d, r);
    translate([0,0,-10 - h]) three_way_valve_screw_holes();    
}
