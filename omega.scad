h = 5;
w = 22;
d = 1;
o = 2.2;
r1 = 6;
r2 = 1;
b = 4.5; //vertical bump

$fn = 150;



translate([0, 0, h/2]) rotate([0, 90, 0]) difference() {
    union() {
        hull() standoffs(1, d, h, w);
        translate([0, 0, b]) rotate([90, 0, 90]) cylinder(h, r1+d, r1+d, center=true);
    }
    union() {
        translate([0, 0, b]) rotate([90, 0, 90]) cylinder(h, r1, r1, center=true);  
        translate([0, 0, -h]) cube([h, w, h*2], center=true);
        translate([0, w/2 - o]) cylinder(d, r2, r2);
        translate([0, -w/2 + o]) cylinder(d, r2, r2);
    }
}


module standoffs(r, depth, height, width) {
    $fn = 20;
    d = depth;
    x = height / 2 -r;
    y = width / 2 -r;
    
    union() { 
        translate([x, y]) cylinder(d, r, r);
        translate([x, -y]) cylinder(d, r, r);
        translate([-x, y]) cylinder(d, r, r);
        translate([-x, -y]) cylinder(d, r, r);
    }
}