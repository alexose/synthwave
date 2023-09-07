/*  Remaining TODO:

    1) Standardize screw holes for M3 + threaded inserts
    2) Brackets for breadboard
    3) Better shelf for vaccum pumps
    4) Strain relief
    5) Upside-down storage mode
    6) Maybe don't need top shelf
    
*/  

use <threads.scad>

base_radius = 283 / 2; // inner diameter of 5 gallon bucket in mm

container_bottom_radius = 89 / 2;
container_top_radius = 112 / 2;
container_height = 135.3;

pump_mount_depth = 10;
pump_mount_height = container_height + 20;

rear_wall_height = 250;
rear_wall_width = 128; // needs to accomodate two breadboards
rear_wall_thickness = 2;

electrode_holder_width = 20;
electrode_holder_height = 12;
electrode_holder_depth = 5;
electrode_holder_radius = 1;

distance_between_containers = 14;

$fn = 50;

// base();
// electrode_holder();
// breadboard_cover();
// pump_bracket();
// container_cover();
strain_relief();

module base() {
    border_width = 10;
    dr = container_bottom_radius;
    bw = border_width;
    
    d = dr + bw * 2;
    r = 20;
        
    dist = dr + distance_between_containers;
    
    pw = 105;
    rw = 56;
    
    y = -3; // nudge forward
    
    // translate([dist, 0]) container();
    // translate([-dist, 0]) container();
    
    difference() {
        a = 25;
        union() {
            lid();
            translate([dist, y]) cylinder(35, r=dr+2);
            translate([-dist, y]) cylinder(35, r=dr+2);
            rotate([0, 0, -a]) translate([pw, y]) mirror([0, 1, 0]) rotate([0, 0, 180 + a]) pump_mount();
            rotate([0, 0, a]) translate([-pw, y]) rotate([0, 0, a]) pump_mount();
            translate([0, rw]) rear_wall();
            translate([pw + 4, 54.5, 120]) band(35);
            translate([-pw - 4, 54.5, 120]) mirror([1,0,0]) band(35);

        }
        translate([dist, y]) solenoid_funnel();
        translate([-dist, y]) rotate([180, 180]) solenoid_funnel();
        translate([0, rw-2, 90]) rotate([90, 270, 0]) linear_extrude(1.2) text("synthwave", size=20, halign="center", valign="center");
        
    }

    module rear_wall() {
        h = rear_wall_height;
        o = rear_wall_thickness;
        w = rear_wall_width / 2;
        
        r = 1;
        w2 = 120;
        h2 = 60;
        
        difference() {
            hull() standoffs(h, w, o, r);
            translate([0, -1, 130]) rotate([-90, 0]) breadboard_cover_screw_holes();
        }
        
        // translate([pw, -2.5, 200]) band(100, -1);
        
        // Lower shelf
        translate([0, 0, 180]) difference() {
            shelf_brackets();
            d = 150;
            translate([-d/2, -18, 30]) rotate([0, 90]) cylinder(d, r=5);
        }
        
        // Upper shelf
        translate([0, 0, 220]) shelf_brackets(true);
    }
}

module lid() {
    br = base_radius; 
    h = 1;
    r = 8;
    
    difference() {
        cylinder(h, r=br);
        translate([130, 0, -20]) cylinder(100, r=5);
        translate([-130, 0, -20]) cylinder(100, r=5);
        translate([0, 61, -20]) cylinder(100, r=3.5);
    }
    
    
    scale([1, 1, 0.6]) difference() {
        rotate_extrude() {
            translate([br + 7, 0]) lid_cutout_shape();
        }
        rotate_extrude() {
            translate([br + 7, 0]) scale(0.8) lid_cutout_shape();
        }
    }
}

module top_shelf() {
    w = 80;
    h = 20;
    d = 1.6;
    r = 2;
    
    r2 = 5;
    r3 = 1.2;
    d2 = 58; // see shelf_brackets below
    d3 = 14 / 2;
    o = 3;
    a = 8;
    
    difference() {
        hull() standoffs(d,w,h,r);
        translate([a, 0]) cylinder(h, r=r2);
        translate([-a, 0]) cylinder(h, r=r2);
        translate([d2, d3 + o]) cylinder(100, r=r3);
        translate([d2, -d3 + o]) cylinder(100, r=r3);
        translate([-d2, d3 + o]) cylinder(100, r=r3);
        translate([-d2, -d3 + o]) cylinder(100, r=r3);
    }
}

module container_cover() {

    container_top_upper_radius = 109 / 2;

    h1 = 3;
    h2 = 8;
    r1 = container_top_upper_radius;
    r2 = r1 + 5;
    r3 = 25/2;
    r4 = 30/2;
    
    d = distance_between_containers;
    a = r1*2 + d/2 + r3 + 8;
    
    scale([2, 1, 1]) cylinder(h1, r=r3);
    cover();
    mirror([1, 0, 0]) cover();
    
    module cover() {
        difference() {
            half();
            holes();
        }
    }
    
    module half() {
        translate([r1 + d/2, 0]) cylinder(h2, r1, r1-0.5);
        translate([r1 + d/2, 0]) cylinder(h1, r=r2);
        difference() {
            hull() {
                translate([r1 + d/2, 0]) cylinder(h1, r=r2/2);
                translate([a, 0]) cylinder(h1, r=r4);
            }
            translate([a, 0]) cylinder(h1, r=r3);
        }
    }
    
    module holes() {
        f = 2;
        w = electrode_holder_width + f;
        h = electrode_holder_height + f;
        d = electrode_holder_depth + f;
        r = electrode_holder_radius;
        
        o = r1 + d/2;
        translate([o + 30, 20]) cylinder(h*3, r=5); // tube holder
        translate([o + 30, -20]) cylinder(h*3, r=15/2); // pH probe holder
        translate([o, 0]) hull() standoffs(h, w, d, r);
    }
}

module lid_cutout_shape() {
polygon([[-8,0/*1:0,0,0,0*/] ,[-7.94,1.02] ,[-7.87,2.12] ,[-7.8,3.12] ,[-7.74,4.19] ,[-7.67,5.26] ,[-7.59,6.48] ,[-7.53,7.59] ,[-7.45,8.82] ,[-7.39,9.83] ,[-7.32,10.9] ,[-7.25,12.06] ,[-7.17,13.29] ,[-7.09,14.6],[-7,16/*1:-1,-16,6,4*/] ,[-6.09,16.54] ,[-5.15,16.97] ,[-4.2,17.3] ,[-3.05,17.57] ,[-1.9,17.73] ,[-0.77,17.78] ,[0.34,17.74] ,[1.4,17.63] ,[2.41,17.47] ,[3.51,17.23] ,[4.49,16.96] ,[5.45,16.64] ,[6.43,16.26],[7,16],[8,0/*1:0,0,0,0*/] ,[6.9,0] ,[5.85,0] ,[4.74,0] ,[3.71,0] ,[2.6,0] ,[1.43,0] ,[0.24,0] ,[-0.96,0] ,[-2.14,0] ,[-3.27,0] ,[-4.34,0] ,[-5.5,0] ,[-6.63,0] ,[-7.63,0]]);
}

module shelf_brackets(holes=false) {
    w = 10;
    d = 58; // Needs to be about 105mm apart to accomodate membrane contactor
    
    if (holes) {
        translate([d, 0]) shelf_bracket_with_holes();
        translate([-d, 0]) shelf_bracket_with_holes();
    } else {
        translate([d, 0]) shelf_bracket(w);
        translate([-d, 0]) shelf_bracket(w);
    }
    
    module shelf_bracket_with_holes() {
        difference() {
            shelf_bracket(w);
            translate([0, -8]) cylinder(100, r=0.8);
            translate([0, -22]) cylinder(100, r=0.8);
        }
    }
}

module pump_mount() {
    h = pump_mount_height;
    w = pump_mount_depth;
    d = 25;
    r = 3;

    difference() {
        hull() standoffs(h, w, d, r);
        translate([-15, 0, 130]) rotate([0,0,90]) pump_bracket_screw_holes();
        translate([-55, 18, 73]) rotate([0, 90, 0]) solenoid_screw_holes();
    }
}

module pump_bracket() {
    t = 1.6;
    h = 20;
    y = 22;
    r = 27.1 / 2;  // outer diameter of pump
    g = 5; // gap
    r1 = 1.5;
    o = 4;
    
    
    difference() {
        union() {
            translate([0, -r - t]) difference() {
                // translate([0, 5]) cube([t, h, h]);
                cylinder(h, r=r+t);
                cylinder(h, r=r);
            }
            translate([0, 0, h/2]) rotate([90, 0]) hull() standoffs(t, y, h/2, 2);
        }
        translate([-g/2, -10]) cube([g, h, h]);
        pump_bracket_screw_holes();
    }
}

module pump_bracket_screw_holes(r=1.2) {
    h = 20;
    o = 4;
    y = 22;
    
    translate([-y + o, 0]) {
        translate([0, 0, h - o]) rotate([90, 0]) cylinder(10, r=r);
        translate([0, 0, o]) rotate([90, 0]) cylinder(10, r=r);
    }
    translate([y - o, 0]) {
        translate([0, 0, h - o]) rotate([90, 0]) cylinder(10, r=r);
        translate([0, 0, o]) rotate([90, 0]) cylinder(10, r=r);
    }
}

module band(h=10, c=1) {
    r = 50;
    num = 90;
    w = 3;
    
    difference() {
        translate([-r, -r]) {
            for(i = [0:num - 1]) {
                hull() {
                    rotate([0,0,i]) translate([r, 0, i * 0.6 * c]) cube([w,w,h]);
                    rotate([0,0,i+1]) translate([r, 0, (i+1) * 0.6 * c]) cube([w,w,h]);
                }
            }
        }
        translate([-30, -30, 45]) rotate([90, -35, 135]) solenoid_screw_holes(1);
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
        hull() standoffs(h, w, d, r);
        translate([0, d/2 + 1.75]) nickel_strip_cutout();
        translate([0, -d/2 - 1.75]) rotate([0, 0, 180]) nickel_strip_cutout();
    }
}

module nickel_strip_cutout() {
    d = 0.4;
    h = 12;
    w = 35;
    
    translate([0, 0, h/2 + 1]) {
        cube([w, d, h], center=true); // strip
        translate([0, d+1 / 2]) cube([w-2, d+1, h-1], center=true); // window 
        // translate([2, 0, -h/2 + 4]) cylinder(h, r=1.5); // make room for wire
        // translate([2, 5.2, -1.5]) sphere(r=7); // make room for solder blob
    }
}

module shelf_bracket(w) {
    w = w / 30;
    scale(30) translate([-w/2, 0]) rotate([0, -90, 180]) linear_extrude(w) polygon([[0,0],[1,0],[1,1]]);
}

module clip() {
    y1 = 6;
    y2 = 14;
    linear_extrude(35) polygon([[-15,2],[-2,2],[-2,4],[15,y1],[15,2],[16,2],[16,0],[-16,0],[-60,-5],[-60,-3],[-18,2/*1:0,0,0,0*/] ,[-17.21,2.65] ,[-16.45,3.38] ,[-15.7,4.2] ,[-15.05,5.03] ,[-14.42,5.96] ,[-13.87,7] ,[-13.45,8.12] ,[-13.21,9.11] ,[-13.11,10.15] ,[-13.18,11.24] ,[-13.43,12.35] ,[-13.89,13.49] ,[-14.42,14.43] ,[-15.12,15.37] ,[-16,16.32] ,[-16.78,17.04] ,[-17.68,17.76],[-18,18/*1:11,-8,-3,1*/] ,[-19.13,18.24] ,[-20.2,18.4] ,[-21.53,18.57] ,[-22.68,18.71] ,[-23.96,18.85] ,[-25.34,19] ,[-26.83,19.15] ,[-27.86,19.25] ,[-28.93,19.36] ,[-30.04,19.46] ,[-31.16,19.57] ,[-32.32,19.68] ,[-33.49,19.79] ,[-34.68,19.89] ,[-35.88,20] ,[-37.09,20.11] ,[-38.3,20.22] ,[-39.52,20.32] ,[-40.73,20.43] ,[-41.94,20.53] ,[-43.14,20.63] ,[-44.33,20.73] ,[-45.5,20.83] ,[-46.65,20.93] ,[-47.78,21.02] ,[-48.88,21.11] ,[-49.95,21.2] ,[-50.99,21.28] ,[-51.99,21.37] ,[-53.41,21.48] ,[-54.72,21.58] ,[-55.92,21.68] ,[-56.99,21.76] ,[-58.19,21.86] ,[-59.29,21.94],[-60,22],[-60,24],[-16,20],[16,20],[16,18],[15,18],[15,y2],[-2,16],[-2,18/*1:0,0,0,0*/] ,[-3.05,18] ,[-4.15,18] ,[-5.18,18] ,[-6.34,18] ,[-7.39,18] ,[-8.47,18] ,[-9.56,18] ,[-10.62,18] ,[-11.64,18] ,[-12.73,18] ,[-13.81,18] ,[-14.87,18],[-15,18/*1:2,0,10,-8*/] ,[-14.15,17.28] ,[-13.41,16.56] ,[-12.57,15.61] ,[-11.89,14.66] ,[-11.37,13.73] ,[-10.91,12.58] ,[-10.65,11.46] ,[-10.56,10.37] ,[-10.62,9.32] ,[-10.81,8.32] ,[-11.18,7.18] ,[-11.66,6.13] ,[-12.22,5.18] ,[-12.81,4.33] ,[-13.5,3.48] ,[-14.2,2.73] ,[-14.95,2.04]]);
}

module container() {
    r1 = container_bottom_radius;
    r2 = container_top_radius;
    h = container_height;
    cylinder(h, r1, r2);
    // translate([0, 0, h]) cylinder(h, r2, r2);
}

// translate([100, 0]) solenoid_funnel();

module solenoid_funnel() {
    h = 15;
    r1 = 15;
    r2 = container_bottom_radius;
     
    translate([0, 0, h]) cylinder(h, r1, r2 - 2);
    translate([0, 0, h*2-4]) container();
    
    translate([0, 0, h]) rotate([180, 0]) ScrewThread(26.670, h, pitch=1.814);
    
    // Hole for drain line
    translate([0, 0, 20]) rotate([90, 0, 90]) cylinder(100, r=5);
    
    // english_thread(diameter=1.05, threads_per_inch=14, length=3/4, taper=1/16);
}

module standoffs(h, w, d, r) {
    translate([w-r, d-r]) cylinder(h, r, r);
    translate([w-r, -d+r]) cylinder(h, r, r);
    translate([-w+r, d-r]) cylinder(h, r, r);
    translate([-w+r, -d+r]) cylinder(h, r, r);
}

module screw_brackets(h, w, d) {
    translate([w, d]) rotate([180, 180]) screw_bracket();
    translate([w, -d]) screw_bracket();
    translate([-w, d]) rotate([180, 180]) screw_bracket();
    translate([-w, -d]) screw_bracket();
}

module breadboard_cover() {
    f = 3; // fit tolerance
    t = 1.6; // wall thickness
    h = 30;
    r = 2;
    
    x = 55 + f;
    y = (165 + f) / 2;
    
    difference() {
        union() {
            hull() standoffs(h, x+t/2, y+t/2, r);
            translate([0, 0, h]) mirror([0,0,1]) screw_brackets(h, x/2, y+t/2);
        }
        translate([0, 0, t]) hull() standoffs(h, x, y, r);
        translate([0, 0, h - 22]) breadboard_cover_screw_holes(5);
        translate([0, 0, h - 10]) breadboard_cover_screw_holes();
        hull() {
            translate([0, y + 5, h]) rotate([90, 90]) cylinder(y*2 + 10, r=6);
            translate([0, y + 5, h - 12]) rotate([90, 90]) cylinder(y*2 + 10, r=6);
        }
    }

}

module screw_bracket() {
    w = 1;
    scale(15) translate([w/2, 0, w]) rotate([0, 90, 180]) linear_extrude(w) polygon([[0,0],[1,0],[1,1]]);
}

module breadboard_cover_screw_holes(r=1.2) {
    f = 3; // fit tolerance
    t = 1.6; // wall thickness
    h = 20;
    x = 55 + f;
    y = (165 + f) / 2;
    
    standoffs(h, x/2 + r, y + 8 + r, r);
}

module solenoid_screw_holes(r=0.8) {
    d = 38;
    
    translate([d/2, 0]) cylinder(50, r=r);
    translate([-d/2, 0]) cylinder(50, r=r);
}

module strain_relief() {
    h = 15;
    
    difference() {
        linear_extrude(h) scale([0.8, 1, 1]) polygon([[-32,0],[-32,7],[32,7],[32,0],[40,0],[40,-2],[30,-2],[30,5],[-30,5],[-30,-2],[-40,-2],[-40,0]]);
         translate([0, 10, 99]) rotate([90, 0]) breadboard_cover_screw_holes(r=1.4);
      }


}