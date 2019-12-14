/*!
 * @author Dirk Van Haerenborgh <vhdirk@gmail.com>
 * @brief XT60 connectors
 */

// Units: mm.

include <MCAD/units.scad>
include <util.scad>

module xt60_body(grips=true, contacts=true){
  length = 16;
  width = 7.5;
  height = 8;

  diag_side = 3.5;

  grip_offset_x = 1.85;
  grip_offset_z = 0.85;
  grip_length = 10;
  grip_width = 0.5;
  grip_height = 5.5;

  // the main connector body
  difference(){
    cube([length, width, height], false);

    translate([length, 0, height/2])
    rotate([0, 0, 45])
    cube([diag_side, diag_side, height+epsilon], true);

    translate([length, width, height/2])
    rotate([0, 0, 45])
    cube([diag_side, diag_side, height+epsilon], true);

    if (grips){
      translate([grip_offset_x, 0, grip_offset_z])
      cube([grip_length, grip_width, grip_height], false);

      translate([grip_offset_x, width-grip_width, grip_offset_z])
      cube([grip_length, grip_width, grip_height], false);
    }
  }

  if (contacts) {
    translate([0, 0, -5])
      xt60_contacts(5);
  }

}

module xt60_contacts(height){
  translate([4.25, 3.75, height/2])
    cylinder(r=2, h=height, center=true);

  translate([11.75, 3.75, height/2])
    cylinder(r=2, h=height, center=true);
}

module xt60_female_top(){
  difference(){
    translate([0.85, 0.85, 8])
      resize([14, 6, 8])
        xt60_body(grips=false, contacts=false);
  
    translate([0, 0, 8]){
      xt60_contacts(9.25);
    }
  }
}


module xt60_female(){
  xt60_body();
  xt60_female_top();
}

module xt60_male_top(){
  difference(){
    translate([0, 0, 8])
      xt60_body(grips=false);

    translate([0, 0, epsilon])
      xt60_female_top();
  }
}

module xt60_male(){
  xt60_body();
  xt60_male_top();
}
