/*!
 * @author Dirk Van Haerenborgh <vhdirk@gmail.com>
 * @brief A cover for my 3D printer PSU
 */

// Units: mm.

include <MCAD/units.scad>
use <MCAD/2Dshapes.scad>
use <MCAD/regular_shapes.scad>
include <MCAD/materials.scad>
use <MCAD/triangles.scad>
include <./lib/util.scad>
use <./lib/nutsnbolts.scad>;
use <./lib/fuseholder.scad>;
use <./lib/xt60.scad>;
use <./lib/shapes.scad>;

$fn=48;


WALL_THICKNESS = 3.0;
DIMENSIONS = [114, 50-WALL_THICKNESS, 60];


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
  translate([0, WALL_THICKNESS, -20]) {

    // main block
    cube([ PSU_DIMENSIONS[0],
           PSU_DIMENSIONS[1]+epsilon,
           20+epsilon
      ], false);


    // PSU flaps
    translate([0, 0, -PSU_RAIL_DIMENSIONS[2]]) {
      cube([ WALL_THICKNESS+epsilon,
          PSU_DIMENSIONS[1]+epsilon,
          PSU_RAIL_DIMENSIONS[2]+epsilon
        ], false);
    }

    // draw the PSU contacts rail
    translate([0, PSU_DIMENSIONS[1]-PSU_RAIL_DIMENSIONS[1], -PSU_RAIL_DIMENSIONS[2]]) {
      cube([ PSU_RAIL_DIMENSIONS[0],
          PSU_RAIL_DIMENSIONS[1]+epsilon,
          PSU_RAIL_DIMENSIONS[2]+epsilon
        ], false);
    }
  }

  psu_mount_holes();
}


module enclosure() {

  difference(){
    // the outer cube
    translate([ epsilon, -WALL_THICKNESS, -WALL_THICKNESS]) {
      cube([
          DIMENSIONS[0] + WALL_THICKNESS,
          DIMENSIONS[1] + WALL_THICKNESS * 2.0,
          DIMENSIONS[2] + WALL_THICKNESS,
        ], false);
      }

    // cut out the inner cube
    translate([ WALL_THICKNESS, 0, 0])
    cube([
      DIMENSIONS[0]-WALL_THICKNESS+epsilon,
      DIMENSIONS[1],
      DIMENSIONS[2] + epsilon,
    ], false);
  }

  // TODO: perhaps add a slanted edge in case the PSU is smaller than the cover
}

module xt60_mounts(num_connectors=2){
  translate([WALL_THICKNESS, DIMENSIONS[1]-19-WALL_THICKNESS, 11-WALL_THICKNESS-epsilon]) {

    for(c = [0:num_connectors-1]){
      translate([c*13.5, 0, 0])
      rotate([0, 180, -90])
      xt60_plate_mount(half=true);
    }
  }
}

module xt60_mounts_cutout(num_connectors=2){
  translate([WALL_THICKNESS, DIMENSIONS[1]-19-WALL_THICKNESS, -WALL_THICKNESS-epsilon]) {
    cube([num_connectors*13.5, 19, WALL_THICKNESS+epsilon*2]);
  }
}


module fuseholders_cutouts(num_fuses=3, thin=false){

  mid_height = 6.35;
  start_height = thin ? mid_height-2 : mid_height;
  end_height = 2;

  total_height = start_height + (num_fuses-1)*mid_height + end_height;


  // a slot where the fuse holder fits into
  translate([10.5, 26+epsilon, 0])
    rotate([0, 0, 180])
      cube([21, WALL_THICKNESS+2*epsilon, total_height], false);
  

  Hole_X_Offset = 9;     //Type 0 & 1 X Offset
  Hole_Y_Offset = 13;     //Type 0 & 1 Y Offset

  // cutouts for the bolts
  translate([Hole_X_Offset+3, Hole_Y_Offset, -WALL_THICKNESS-epsilon])
    rotate([0, 0, 180])
      cylinder(r=1.5, h=WALL_THICKNESS+2*epsilon);
  
  translate([-Hole_X_Offset-3, Hole_Y_Offset, -WALL_THICKNESS-epsilon])
    rotate([0, 0, 180])
      cylinder(r=1.5, h=WALL_THICKNESS+2*epsilon);
}


module fuseholders_cover(num_fuses=3){

  translate([-10.5-WALL_THICKNESS+0.5, -26 - 2*WALL_THICKNESS, -WALL_THICKNESS]){
    difference(){

      outer_length = 20 + 2*WALL_THICKNESS;
      outer_height = fuseholders_height(num_fuses)+2*WALL_THICKNESS;

      diagonal = 6*sqrt(2);
      union(){
        cube([outer_length, 6, outer_height]);

        // add some fancy slanted edges
        translate([-1.5, 4, outer_height/2])
        rotate([0, 0, 180])
        basic_triangle(6, 5, outer_height, true);

        translate([outer_length + 1.5, 4, outer_height/2])
        rotate([0, 0, -90])
        basic_triangle(5, 6, outer_height, true);

        translate([outer_length/2, 4, outer_height + 1.5])
        rotate([0, 0, -90])
        rotate([90, 0, 0])
        basic_triangle(5, 6, outer_length, true);

        translate([outer_length, 6, outer_height])
        rotate([90, 0, 0])
        cylinder(6,5,00,$fn=4);

        translate([0, 6, outer_height])
        rotate([90, 0, 0])
        cylinder(6,5,00,$fn=4);
      }
      
      translate([WALL_THICKNESS, -epsilon, WALL_THICKNESS])
      cube([20, 6+2*epsilon, fuseholders_height(3)]);
    }




  }

}


module main(){

  
  difference(){

    // the main enclosure
    enclosure();

    // cut out parts for fitting it on the psu
    translate([0, DIMENSIONS[1] - PSU_DIMENSIONS[1], DIMENSIONS[2]]){
      color(Aluminum)
      psu();
    }

    // cut out the holes for the main switch
    translate([DIMENSIONS[0] - SWITCH_SOCKET_PLATE_HULL[1], SWITCH_SOCKET_PLATE_HULL[0]-0.5, -WALL_THICKNESS-SWITCH_SOCKET_PLATE_HULL[2]])
    rotate([180, 180, 90])
    color("red")
    switch_socket();
  

    // cut out holes the fuseholder
    translate([15+WALL_THICKNESS, 26-WALL_THICKNESS, 0])
      rotate([0, 0, 180]){
      %fuseholders_stacked(3, thin=false);

      fuseholders_cutouts();
    }

    // open holes for xt60 connectors
    xt60_mounts_cutout();
  }

  // brackets for xt60 connectors
  color("blue"){
    xt60_mounts();
  }

  translate([15+WALL_THICKNESS, 26-WALL_THICKNESS, 0]){
    fuseholders_cover(3);
  }


}


main();
