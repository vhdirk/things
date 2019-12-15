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


module mounting_lug(inner_radius, height, outer_radius=undef)
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
