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
use <./lib/xt60.scad>;


DIMENSIONS = [114, 50, 60];

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

module xt60_plate_mount(half=false){

  padding = 3.0;
  connector_height = (half ? 8 : 16);
  height = connector_height + padding;

	difference(){
    // make a box where these connectors should fit in
    cube([16 + 2*padding, 7.5 + 2*padding, height]);

    translate([padding, padding, 0]){
      // cut away the space for the connector itself
      translate([0, 0, padding-epsilon])
        xt60_outer(connector_height+epsilon*2);

      // cut away the bottom for the wires
      translate([0.85, 0.85, -1])
        xt60_inner(height=padding+1);
    }
	}

  // make 2 small ridges that snap in the connector grips
  translate([2.5 + padding, padding, 3 + padding]){
    cube([7, 0.5, 2]);
  }

  translate([2.5 + padding, padding + 7.5 - 0.5, 3 + padding]){
    cube([7, 0.5, 2]);
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

    // TODO: add a slanted edge in case the PSU is smaller than the cover
    


    translate([0, DIMENSIONS[1] - PSU_DIMENSIONS[1], DIMENSIONS[2]]){
      color("silver")
      psu();
    }



  }

}

module xt60_mounts(num_connectors=3){
  translate([0, DIMENSIONS[1]-19-WALL_THICKNESS, 11-WALL_THICKNESS-epsilon]) {

    for(c = [0:num_connectors-1]){
      translate([c*13.5, 0, 0])
      rotate([0, 180, -90])
      xt60_plate_mount(half=true);
    }
  }
}

module xt60_mounts_cutout(num_connectors=3){
  translate([0, DIMENSIONS[1]-19-WALL_THICKNESS, -WALL_THICKNESS-epsilon]) {
    cube([num_connectors*13.5, 19, WALL_THICKNESS+epsilon*2]);
  }
}




union(){

  difference(){
    enclosure();

    xt60_mounts_cutout();
  }

  translate([DIMENSIONS[0] - SWITCH_SOCKET_PLATE_HULL[1], SWITCH_SOCKET_PLATE_HULL[0]+WALL_THICKNESS/2, -WALL_THICKNESS-SWITCH_SOCKET_PLATE_HULL[2]])
  rotate([180, 180, 90])
  color("red")
  switch_socket();

  color("red"){
    xt60_mounts();
  }

}

