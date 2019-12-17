include <MCAD/units.scad>

module xor(){
  difference(){
    for(i = [0 : $children - 1])
      child(i);
      intersection_for(i = [0: $children -1])
        child(i);
  }
}

// a cube which is centered only on X and Y, not on Z
module cubecxy(size){
  translate([0,0,size[2]/2])cube(size,true);
}

// Hack to suppress warning from MCAD.
module test_square_pyramid() {}


module mount_lug(inner_radius, height, outer_radius=undef)
{
  outer_radius = outer_radius ? outer_radius : inner_radius * 2;

  translate([-outer_radius, 0, 0])
    difference() {
      union()  {
        cylinder(r=outer_radius, h=height);
        translate([0, -outer_radius, 0])
            cube([ outer_radius,
                    outer_radius*2,
                    height]);

      }
      translate([0, 0, -epsilon])
        cylinder(r=inner_radius, h=height + epsilon * 2);
    }
}


module mount_column(inner=2.8, outer=5.8, height=10, bottom=true) {
  difference() {
    cylinder(r=outer/2, h=height);

    offset = bottom ? 5 : 0;

    translate([0,0,offset]) cylinder(r=inner/2, h=height-offset+epsilon);
  }
}