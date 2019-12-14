/*!
 * @author Dirk Van Haerenborgh <vhdirk@gmail.com>
 * @brief XT60 connectors
 */

// Units: mm.

include <MCAD/units.scad>
include <util.scad>

XT60_LENGTH = 16;
XT60_WIDTH = 7.5;
XT60_BODY_HEIGHT = 8.0;
XT60_TOP_HEIGHT = 8.0;
XT60_HEIGHT = XT60_BODY_HEIGHT + XT60_TOP_HEIGHT;

module xt60_outer(height=XT60_BODY_HEIGHT){
  diag_side = 3.5;

  // the main connector body
  difference(){
    cube([XT60_LENGTH, XT60_WIDTH, height], false);

    translate([XT60_LENGTH, 0, height/2])
    rotate([0, 0, 45])
    cube([diag_side, diag_side, height+epsilon], true);

    translate([XT60_LENGTH, XT60_WIDTH, height/2])
    rotate([0, 0, 45])
    cube([diag_side, diag_side, height+epsilon], true);
  }
}


module xt60_body(grips=true, contacts=true){
  grip_offset_x = 1.85;
  grip_offset_z = 0.85;
  grip_length = 10;
  grip_width = 0.5;
  grip_height = 5.5;

  difference(){

    xt60_outer();

    if (grips){
      translate([grip_offset_x, 0, grip_offset_z])
      cube([grip_length, grip_width, grip_height], false);

      translate([grip_offset_x, XT60_WIDTH-grip_width, grip_offset_z])
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

module xt60_inner(height=8.0){
  resize([14, 6, height])
    xt60_outer();
}

module xt60_female_top(){
  difference(){
    translate([0.85, 0.85, 8.0])
      xt60_inner(8.0);
  
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
