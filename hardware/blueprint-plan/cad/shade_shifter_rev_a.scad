/* Shade Shifter Rev A — parametric fit/volume prototype, millimetres.
   Open in OpenSCAD, set `part`, press F6, then Export STL.
   Not certified eyewear and not suitable for prescription lens glazing. */
$fn = 64;
part = "assembly"; // front, left_temple, right_temple, left_diffuser, right_diffuser, assembly

lens_w = 55; lens_h = 39; bridge = 18; rim = 5.0; front_depth = 6;
corner_r = 8; temple_len = 145; temple_h = 9; temple_t = 5;
hinge_block = 8; channel_w = 3.2; channel_d = 2.0;
pod_len = 45; pod_h = 15; pod_t = 10;

module rounded_rect_2d(w,h,r) {
  offset(r=r) square([w-2*r,h-2*r],center=true);
}
module lens_rim() {
  difference() {
    linear_extrude(front_depth) rounded_rect_2d(lens_w+2*rim,lens_h+2*rim,corner_r+rim);
    translate([0,0,-0.1]) linear_extrude(front_depth+0.2) rounded_rect_2d(lens_w,lens_h,corner_r);
    // Rear-facing LED/light-guide channel; keep LEDs out of direct eye line.
    translate([0,0,front_depth-channel_d]) difference() {
      linear_extrude(channel_d+0.2) rounded_rect_2d(lens_w+rim,lens_h+rim,corner_r+rim/2);
      translate([0,0,-0.1]) linear_extrude(channel_d+0.4) rounded_rect_2d(lens_w+rim-channel_w*2,lens_h+rim-channel_w*2,corner_r);
    }
  }
}
module front() {
  spacing = lens_w + bridge;
  union() {
    translate([-spacing/2,0,0]) lens_rim();
    translate([ spacing/2,0,0]) lens_rim();
    translate([0,5,front_depth/2]) cube([bridge+6,8,front_depth],center=true);
    for (s=[-1,1]) translate([s*(spacing/2+lens_w/2+rim+hinge_block/2-1),0,front_depth/2])
      cube([hinge_block,12,front_depth],center=true);
  }
}
module temple(side=1) {
  difference() {
    union() {
      cube([temple_len,temple_t,temple_h]);
      translate([35,-(pod_t-temple_t)/2,-(pod_h-temple_h)/2]) cube([pod_len,pod_t,pod_h]);
    }
    // Cable tunnel, intentionally oversized for online SLS/MJF tolerances.
    translate([2,temple_t/2-1,temple_h/2-1]) cube([temple_len-4,2,2]);
    // Electronics pod cavity; lid is taped/screwed only after thermal validation.
    translate([38,-(pod_t-temple_t)/2+2,-(pod_h-temple_h)/2+2]) cube([pod_len-6,pod_t-4,pod_h-4]);
  }
}
module diffuser() {
  linear_extrude(0.9) difference() {
    rounded_rect_2d(lens_w+rim,lens_h+rim,corner_r+rim/2);
    rounded_rect_2d(lens_w+rim-channel_w*2,lens_h+rim-channel_w*2,corner_r);
  }
}
module assembly() {
  color("Black") front();
  spacing = lens_w + bridge;
  color("DimGray") translate([-spacing/2-lens_w/2-rim,0,front_depth]) rotate([0,90,0]) temple(-1);
  color("DimGray") mirror([1,0,0]) translate([-spacing/2-lens_w/2-rim,0,front_depth]) rotate([0,90,0]) temple(1);
  color([1,1,1,0.5]) translate([-spacing/2,0,front_depth+0.05]) diffuser();
  color([1,1,1,0.5]) translate([ spacing/2,0,front_depth+0.05]) diffuser();
}

if (part=="front") front();
else if (part=="left_temple") temple(-1);
else if (part=="right_temple") mirror([0,1,0]) temple(1);
else if (part=="left_diffuser" || part=="right_diffuser") diffuser();
else assembly();

