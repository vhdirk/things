
include <MCAD/units.scad>
include <MCAD/2Dshapes.scad>
include <MCAD/regular_shapes.scad>
include <./modules/util.scad>
use <./modules/nutsnbolts.scad>;

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


module xt60(){
  union(){
    cube([13,8.3,7.7]);
    translate([13,0,0])
      rotate([0,0,45])
        cube([6,6,7.7]);
  }
}

module xt60_mount(){
	union(){
		cube([26,15,7.7]);
    xt60();
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
      color("gray")
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



    translate([0, 0, -WALL_THICKNESS - epsilon]) {
        xt60();
    }
}

