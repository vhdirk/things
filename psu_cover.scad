/*!
 * @author Dirk Van Haerenborgh <vhdirk@gmail.com>
 * @brief A cover for my 3D printer PSU
 */

// Units: mm.

include <MCAD/units.scad>
include <MCAD/2Dshapes.scad>
include <MCAD/regular_shapes.scad>
include <./lib/util.scad>
use <./lib/nutsnbolts.scad>;


DIMENSIONS = [114, 50, 50];

WALL_THICKNESS = 3.0;


PSU_DIMENSIONS = [114, 50];
PSU_RAIL_DIMENSIONS = [PSU_DIMENSIONS[0], 23, 17];

// offset off mount holes on sides
PSU_MOUNT_HOLES = [
  [-WALL_THICKNESS, 13, -6],
  [-WALL_THICKNESS, PSU_DIMENSIONS[1]-11.5, -6],
  [PSU_DIMENSIONS[0], 13.0, -6],
  [PSU_DIMENSIONS[0], PSU_DIMENSIONS[1]-11.5, -6]
];


SWITCH_SOCKET_PLATE_HULL = [48, 59, 2];


module xt60_body(grips=true){
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
}

module xt60_female_top(){
  translate([0.85, 0.85, 8])
    resize([14, 6, 8])
      xt60_body(grips=false);
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

module xt60_male_mount(){
	union(){
		cube([26,15,7.7]);
    xt60_male();
	}
}


// the holes for the IEC socket & switch
module switch_socket(){
  linear_extrude(2)
  polygon(points=[[10, 0], [38, 0], [48, 29.5], [38, 59], [10, 59], [0, 29.5]]);

  translate([4, 29.5, 0])
  rotate([180, 0, 0])
  hole_through("M3", l=10);

  translate([44, 29.5, 0])
  rotate([180, 0, 0])
  hole_through("M3", l=10);

  translate([0, 0, -2])
  linear_extrude(20)
  polygon(points=[[10, 5.75], [37.75, 5.75], [37.75, 46.75], [31.75, 53.25], [16, 53.25], [10, 46.75]]);
}

// places cylinders at the spots of the screw holes of the PSU itself,
// so they can be cut out
module psu_mount_holes(){
  for (h = PSU_MOUNT_HOLES){
    translate([-epsilon, 0, 0])
    translate(h)
      rotate([0, -90, 0]){
      hole_through("M3", l=WALL_THICKNESS + epsilon*2);
    };
  };
}



module psu(){
  //draw a bit of the PSU so we now where to keep space
  translate([0, 0, -20]) {
    cube([ PSU_DIMENSIONS[0],
           PSU_DIMENSIONS[1],
           20
      ], false);

      // draw the PSU contacts rail
      translate([0, PSU_DIMENSIONS[1]-PSU_RAIL_DIMENSIONS[1], -PSU_RAIL_DIMENSIONS[2]]) {
        cube(PSU_RAIL_DIMENSIONS, false);
      }
    }

    psu_mount_holes();
}


module enclosure() {

  difference() {

      union(){
      // the outer cube
      translate([ -WALL_THICKNESS, -WALL_THICKNESS, -WALL_THICKNESS]) {
          cube([
                  DIMENSIONS[0] + WALL_THICKNESS * 2.0,
                  DIMENSIONS[1] + WALL_THICKNESS * 2.0,
                  DIMENSIONS[2] + WALL_THICKNESS,
          ], false);
      }
    }

    // cut out the inner cube
    cube([
        DIMENSIONS[0],
        DIMENSIONS[1],
        DIMENSIONS[2] + epsilon,
    ], false);


    translate([0, 0, DIMENSIONS[2]]){
      color("silver")
      psu();
    }



  }

}





union(){
  enclosure();

  translate([DIMENSIONS[0] - SWITCH_SOCKET_PLATE_HULL[1], -WALL_THICKNESS-2, 0])
  rotate([-90, -90, 0])
  color("red")
  switch_socket();



  color("blue")
    translate([-20, -20, 0]) {
        xt60_male();
    }

  color("blue")
    translate([-40, -20, 0]) {
        xt60_female();
    }

}

