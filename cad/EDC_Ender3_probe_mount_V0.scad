/*
EDC_Ender3_probe_mount_V0 — mechanical FIT-CHECK prototype for existing
nonstandard white fan shroud. Units: mm. Not a verified clearance model.

Meas. input (user): upper fan fastener centres 62.25 mm apart, M4;
nozzle tip approx. 100 mm below fasteners; nozzle x offset = 0;
nozzle offset along Y approx. 21 mm (sign remains to be checked).
The geometry is deliberately modular, with printed screw spacers and
an adjustable probe foot. The actual fastener plane and fan clearance MUST
be checked with the real printer before motorised travel.

Choose part in Customizer and export STL. Models oriented for FDM printing.
  mount          — front-plane lattice bracket, printable flat
  probe_foot     — adjustable L foot with downward plastic pin, printable
  spacer_10      — M4 spacer 10 mm
  spacer_20      — M4 spacer 20 mm
  spacer_30      — M4 spacer 30 mm
  gauge          — small test plate to verify the two mounting holes
  assembly       — not for printing; conceptual exploded layout
*/
$fn=80;
part = "mount"; // [mount,probe_foot,spacer_10,spacer_20,spacer_30,gauge,assembly]

screw_pitch = 62.25;
mount_hole_d = 4.6;
mount_t = 5;
arm_w = 9;
slot_centres_x = 14;
slot_d = 3.6;
slot_y_min = 80;
slot_y_max = 100;
probe_peg_d = 5.80; // fit-test with real Ø6 mm coil bore
probe_peg_len = 5.8;

eps=0.03;

module disc2(x,y,r){translate([x,y]) circle(r=r);}
module bar2(x1,y1,x2,y2,w){hull(){disc2(x1,y1,w/2);disc2(x2,y2,w/2);}}
module slot2(x,y1,y2,d){hull(){disc2(x,y1,d/2);disc2(x,y2,d/2);}}
module rounded_plate2(x1,y1,x2,y2,r){hull(){for(x=[x1+r,x2-r])for(y=[y1+r,y2-r]) disc2(x,y,r);}}

module bracket_shape2(){
    union(){
        // Narrow ears near the upper two M4 screws.
        for (x=[-screw_pitch/2,screw_pitch/2])
            rounded_plate2(x-9,-11,x+9,13,4);
        // Lattice perimeter: open window for the front cooling fan.
        bar2(-screw_pitch/2,0,-37,52,arm_w);
        bar2(-37,52,-37,106,arm_w);
        bar2(screw_pitch/2,0,48,52,arm_w);
        bar2(48,52,48,106,arm_w);
        bar2(-37,106,48,106,10);
        // Right lower tab, with paired vertical slots for sensor foot.
        rounded_plate2(33,74,67,121,5);
        // Corner stiffener between right arm and lower tab.
        hull(){disc2(48,76,5);disc2(61,88,5);disc2(48,99,5);}
    }
}

module mount_bracket(){
    difference(){
        linear_extrude(height=mount_t) bracket_shape2();
        for(x=[-screw_pitch/2,screw_pitch/2])
            translate([x,0,-eps]) cylinder(d=mount_hole_d,h=mount_t+2*eps);
        for(x=[50-slot_centres_x/2,50+slot_centres_x/2])
            translate([0,0,-eps]) linear_extrude(height=mount_t+2*eps)
                slot2(x,slot_y_min,slot_y_max,slot_d);
    }
}

module gauge(){
    difference(){
        linear_extrude(height=3)
            hull(){disc2(-screw_pitch/2,0,7.5);disc2(screw_pitch/2,0,7.5);}
        for(x=[-screw_pitch/2,screw_pitch/2])
            translate([x,0,-eps]) cylinder(d=mount_hole_d,h=3+2*eps);
    }
}

module gusset(xstart, width){
    // yz triangular web from vertical flange to horizontal shelf.
    translate([xstart,0,0]) rotate([90,0,90])
        linear_extrude(height=width)
            polygon([[5,5],[5,22],[24,5]]);
}

module probe_foot_assembled(){
    difference(){
        union(){
            // Vertical adjustable foot: X width 30, Z height 30.
            translate([-15,0,0]) cube([30,5,30]);
            // Horizontal forward ledge. Coil is UNDER the ledge.
            translate([-12,5,0]) cube([24,28,5]);
            // Paired longitudinal gussets (can be simplified if needed).
            // YZ triangle as an extruded polygon in local yz plane.
            for(x=[-12,9])
                translate([x,0,0])
                    rotate([0,90,0])
                        linear_extrude(height=3)
                            polygon([[0,5],[0,22],[-22,5]]);
            // Downward pin. Print pin slightly undersize for bore d=6 mm.
            translate([0,25,-probe_peg_len])
                cylinder(d=probe_peg_d,h=probe_peg_len+eps);
        }
        // Pair of horizontal screw holes: M3 with washers and nuts; z=10.
        for (x=[-slot_centres_x/2,slot_centres_x/2])
            translate([x,-eps,10]) rotate([-90,0,0])
                cylinder(d=3.5,h=5+2*eps);
        // Cable tie passage at rear upper edge (not above pin).
        translate([-2.2,-eps,23]) cube([4.4,5+eps,3]);
    }
}

module spacer(h=20){
    difference(){cylinder(d=11,h=h);translate([0,0,-eps])cylinder(d=4.6,h=h+2*eps);}
}

if (part == "mount") mount_bracket();
else if(part=="probe_foot"){
    // Lay the vertical mounting flange on the bed; supports may be needed
    // under the horizontal pin depending on slicer and material.
    translate([0,30,0]) rotate([90,0,0]) probe_foot_assembled();
}
else if(part=="spacer_10") spacer(10);
else if(part=="spacer_20") spacer(20);
else if(part=="spacer_30") spacer(30);
else if(part=="gauge") gauge();
else if(part=="assembly"){
    color("silver") mount_bracket();
    color("orange") translate([50,97,mount_t+3])
         // diagrammatic orientation only
         rotate([90,0,0]) probe_foot_assembled();
}
