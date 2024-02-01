// Modified Doctor Blade sheet
w = 250;
h = 160;
d = 0.24; // 240um

electrode_width = 20;
electrode_height = 100;

difference() {
    cube([w, h, d], true);
    
    // Loop to create multiple instances of the second cube
    for (x = [0 : 20+10 : 250]) {
        translate([x - w/2 + 20, 0, 0])
            cube([electrode_width, electrode_height, d+0.1], true);
    }
}
