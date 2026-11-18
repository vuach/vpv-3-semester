/*
  EDC V2 INTERCHANGEABLE EDDY-CURRENT COILS / Ender-3
  Units: mm. Parametric experimental FDM design, NOT a certified probe.

  DESIGN INTENT:
  - Print universal_2x15 TWO times: leave one air-filled and insert
    a ferrite rod D2 x L15 into the second. External geometry identical.
  - Top blind socket fits the downward peg D5.8 x 5.8 on
    EDC_Ender3_probe_foot_V0 (fit must be verified on your machine).
  - Winding enamel wire PETV-2 D0.16 copper / approx. D0.19 insulated:
    ~15 turns/layer x 5 radial layers = 75 turns in 3.2 mm winding window.
  - The coil region is only ~7.5 mm across, compared to V1 D16 flange.
  - The ferrite end sits 0.3mm up from bottom flange when seated.
  - Both probes must be tested with the same standoff and windings.
  - FDM printer nozzle 0.4mm, layer 0.12mm suggested.

  Select `part` in Customizer then F6 and export STL.
*/

$fn=128;
part = "universal_2x15"; // [universal_2x15, universal_1p8x10, universal_2p2x10, socket_gauge, assembly_demo]

// Common external geometry for all probe variants:
flange_d = 7.5;
winding_d = 4.2;
bottom_flange_h = 0.9;
winding_h = 3.2;
shaft_d = 9.6;
shoulder_h = 2.7; // 45-degree print-friendly shoulder
probe_total_h = 28.0;

peg_socket_d = 6.15;   // mating peg has nominal diameter 5.8 mm
peg_socket_depth = 7.0;

core_d = 2.35;         // for ferrite rod D2.0 mm; check actual clearance
core_depth = 15.3;     // for rod length 15 mm, tip remains recessed 0.3 mm

wire_slot_w = 0.72;
wire_slot_depth = 0.45;
eps=0.04;

shoulder_z = bottom_flange_h + winding_h;
shaft_z = shoulder_z + shoulder_h;

assert(winding_d - core_d >= 1.55, "Too little winding wall thickness for 0.4 mm FDM nozzle");
assert(probe_total_h - peg_socket_depth > core_depth + 2.0,
       "Core bore and upper peg socket need >2mm separating wall");

module probe_bobbin(bore=2.35,bore_depth=15.3){
  difference(){
    union(){
      cylinder(d=flange_d,h=bottom_flange_h);
      translate([0,0,bottom_flange_h-eps])
        cylinder(d=winding_d,h=winding_h+2*eps);
      // Sloped winding stop -- printable upright without a large overhang.
      translate([0,0,shoulder_z-eps])
        cylinder(d1=winding_d,d2=shaft_d,h=shoulder_h+eps);
      translate([0,0,shaft_z-eps])
        cylinder(d=shaft_d,h=probe_total_h-shaft_z+eps);
    }
    // Blind ferrite insertion from below: same empty pocket on air probe.
    translate([0,0,-eps]) cylinder(d=bore,h=bore_depth+eps);
    // Socket for existing printed D5.8 peg, opens from top.
    translate([0,0,probe_total_h-peg_socket_depth])
       cylinder(d=peg_socket_d,h=peg_socket_depth+eps);
    // Two small, opposed wire escapes over the tapered shoulder.
    for(a=[0,180]) rotate([0,0,a])
       translate([winding_d/2-0.10,-wire_slot_w/2,shoulder_z-0.06])
          cube([shaft_d/2-winding_d/2+0.16,wire_slot_w,shoulder_h+0.12]);
    // External shallow grooves to tape the wires to the upper holder.
    for(a=[0,180]) rotate([0,0,a])
       translate([shaft_d/2-wire_slot_depth,-wire_slot_w/2,shaft_z])
          cube([wire_slot_depth+0.2,wire_slot_w,11.8]);
  }
}

module gauge() {
  // Two kinds of test holes: upper peg sockets and ferrite rod bores.
  // Print this BEFORE printing the two full probe bodies.
  difference(){
    union(){
      for(i=[0:2]) translate([i*16,0,0]) cylinder(d=12,h=5);
      for(i=[0:2]) translate([i*16,17,0]) cylinder(d=8,h=5);
    }
    for(i=[0:2])
      translate([i*16,0,-eps]) cylinder(d=5.95+i*0.20,h=5+2*eps);
    for(i=[0:2])
      translate([i*16,17,-eps]) cylinder(d=2.20+i*0.15,h=5+2*eps);
  }
}

module visual_coil() {
  // CAD visualization only, NOT for FDM printing.
  for(k=[0:4]) {
    translate([0,0,bottom_flange_h+0.14])
       color([0.84,0.42,0.12])
        difference(){
          cylinder(d=winding_d+0.19*(k*2+2),h=2.92);
          translate([0,0,-0.01]) cylinder(d=winding_d+0.19*(k*2+1),h=2.94);
        }
  }
}

if(part=="universal_2x15") probe_bobbin(core_d,core_depth);
else if(part=="universal_1p8x10") probe_bobbin(2.15,10.3);
else if(part=="universal_2p2x10") probe_bobbin(2.55,10.3);
else if(part=="socket_gauge") gauge();
else if(part=="assembly_demo") {
  translate([-15,0,0]) {
    color([0.80,0.83,0.86,0.8]) probe_bobbin(core_d,core_depth);
    visual_coil();
  }
  translate([15,0,0]) {
    color([0.80,0.83,0.86,0.8]) probe_bobbin(core_d,core_depth);
    visual_coil();
    // Ferrite drawn from below to show insertion position; not a print part.
    color([0.17,0.18,0.19]) translate([0,0,0.30])
      cylinder(d=2,h=15);
  }
}
