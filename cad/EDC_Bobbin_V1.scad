// EDC-BOBBIN-V1 — dimensions in mm. Print with the lower flange on the bed.
$fn = 128;

barrel_diameter = 10;
flange_diameter = 16;
bore_diameter = 6.0; // Try 6.2 only after checking the actual pin and printer.
window_height = 4.10;
lower_flange_height = 0.80;
upper_flange_height = 1.20;
slot_width = 0.80;
lead_groove_depth = 0.35;

eps = 0.02;
barrel_radius = barrel_diameter / 2;
flange_radius = flange_diameter / 2;
upper_flange_z = lower_flange_height + window_height;
total_height = upper_flange_z + upper_flange_height;

assert(barrel_radius - lead_groove_depth > bore_diameter / 2,
       "Lead groove must leave material between the groove and the bore.");
assert(flange_diameter > barrel_diameter, "Flanges must extend beyond the barrel.");

module radial_slot(angle) {
    rotate([0, 0, angle])
        translate([barrel_radius - lead_groove_depth, -slot_width / 2, upper_flange_z])
            cube([flange_radius - barrel_radius + lead_groove_depth + eps,
                  slot_width, upper_flange_height + eps]);
}

difference() {
    union() {
        cylinder(d = flange_diameter, h = lower_flange_height);
        translate([0, 0, lower_flange_height - eps])
            cylinder(d = barrel_diameter, h = window_height + 2 * eps);
        translate([0, 0, upper_flange_z])
            cylinder(d = flange_diameter, h = upper_flange_height);
    }

    translate([0, 0, -eps])
        cylinder(d = bore_diameter, h = total_height + 2 * eps);

    // Start lead rises from the bottom of the winding window into the +X slot.
    translate([barrel_radius - lead_groove_depth, -slot_width / 2, lower_flange_height])
        cube([lead_groove_depth + eps, slot_width, window_height + eps]);

    radial_slot(0);
    radial_slot(180);
}
