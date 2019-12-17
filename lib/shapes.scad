include <MCAD/units.scad>;
use <MCAD/triangles.scad>;


module basic_triangle(o_len, a_len, depth, center=false)
{
    triangle(o_len, a_len, depth, center);
}


module pyramid(x, y, z=0, clip_height=0) {
  z = z ? z : sqrt(pow(x, 2) + pow(y, 2))/2; 
	mx = x/2;
	my = y/2;

  difference(){
    polyhedron(points = [
      [0,  0,  0],
      [x,  0,  0],
      [0,  y,  0],
      [x,  y,  0],
      [mx, my, z]
    ], faces = [
      [4, 1, 0],
      [4, 3, 1],
      [4, 2, 3],
      [4, 0, 2],
      //base
      [0, 1, 2],
      [2, 1, 3]
    ]);

    if (clip_height > 0){
        translate([0, 0, clip_height-epsilon])
          cube([x, y, z]);
    }
  }
}