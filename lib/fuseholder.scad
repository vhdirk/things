

//Remix of Stackable Fuseholder
//From: https://www.thingiverse.com/thing:1927820
//Which was originated
//From: https://www.thingiverse.com/thing:1787609
//Which was originated
//From: https://www.youmagine.com/designs/stackable-fuseholder#documents
//
//I like a little bigger holes than 3.0mm
//Also made the wings so I had 2.5mm plastic around the holes
//11/30/2016    By: David Bunch

// I want to have thinner start/end parts
// 15/dec/2019  By: Dirk Van Haerenborgh

include <util.scad>

//Source of Carfuse Model: http://www.thingiverse.com/thing:505360
// model of a standard car fuse - used to carve out e avity 
// (the argument eps gives an additional size increase for smooth insertion)

module car_fuse(eps=[0,0,0])
{
  rotate([90,0,0])
  union() {
    cubecxy([18.2,5,2]+eps);
    cubecxy([18.2,1.1,10.5]+eps);
    difference() {
      cubecxy([18.2,3.5,6]+eps);
      cubecxy([16,3.6,6.1]+eps);
    }
    cubecxy([16.5,2.8,12]+eps);
    cubecxy([6.5,3.6,12]+eps);
    difference() {
      cubecxy([15.2,1.0,18.5]+eps);
      cubecxy([3.8,1.2,18.6]+eps);
    }
  }
}

module fuseholder_base(height=2, mount_radius=1.5)
{
  // base shape
  translate([-10.25, 0, 0])
  cube([20.5, 26, height], false);

  Hole_X_Offset = 9;     //Type 0 & 1 X Offset
  Hole_Y_Offset = 13;     //Type 0 & 1 Y Offset

  // mount_lugs
  for (m = [1,-1]) {
    translate([m * Hole_X_Offset, Hole_Y_Offset, 0]) {
      rotate([0, 0, 90 + m*90])
      mounting_lug(mount_radius, height);
    }
  }
}

module fuseholder_fuse_cutout()
{
  translate([-1.25,2,1.6])
  rotate([0,-90,0])
  linear_extrude(height = 7.8, center = false, convexity = 10)
  polygon(points=[[0,0],[9.75,0],[9.75,22.5],[1.4,22.5],[1.4,13],[0,11.5]]);
}

module fuseholder_contact_cutout(length=1.5)
{
  translate([1.75,24.5,4.8])
    cube([6,length+epsilon,1.55+epsilon]);
}

module fuseholder_bottom_space()
{
  hull()
  {
    translate([1.25,2,-.01])
    cube([7.8,12.5,.01]);
    translate([1.25,2.5,.74])
    cube([7.8,11.5,.01]);
  }
}


module fuseholder_start(thin=false)
{
  difference()
  {
    height = thin ? 4.35 : 6.35;
    z_offset = thin ? -2 : 0;
    fuseholder_base(height=height);
    translate([0, 0, z_offset])
    for (m = [0,1])
    {
      mirror([m,0,0])
      {
        fuseholder_fuse_cutout();
        fuseholder_contact_cutout();
        hull()
        {
          translate([5.15,-1,4.5])
          rotate([-90,0,0])
          cylinder(d=3.4,h=10);
          translate([5.15,-1,4.5+5])
          rotate([-90,0,0])
          cylinder(d=3.4,h=10);
        }
      }
    }
//        translate([5,0,-2])
//        cube([100,100,100]);
//        translate([-97,0,-2])
//        cube([100,100,100]);
  }


}

module fuseholder_mid()
{
  difference()
  {
    fuseholder_base(6.35);
    fuseholder_bottom_space();
    for (m = [0,1])
    {
      mirror([m,0,0])
      {
        fuseholder_bottom_space();

        fuseholder_fuse_cutout();
        fuseholder_contact_cutout();

        hull()
        {
          translate([5.15,-1,4.5])
          rotate([-90,0,0])
          cylinder(d=3.4,h=10);
          translate([5.15,-1,4.5+5])
          rotate([-90,0,0])
          cylinder(d=3.4,h=10);
        }
      }
    }
  }
}
module fuseholder_end(wide=false)
{
  difference() {
    fuseholder_base(2.0);
    for (m = [0,1]) {
      mirror([m,0,0])
      {
        hull() {
          translate([1.25,2,-.01])
          cube([7.8,12.5,.01]);
          translate([1.25,2.5,.71])
          cube([7.8,11.5,.01]);
        }
      }
    }
  }
}


module test_fuseholder(){

  fuseholder_mid();

  translate([0,30,0]){
  fuseholder_start()
  %translate([0,38.1,5.4])
    color("red",.5)
      car_fuse(eps=[0.2,0.2,0]);
  }

  translate([0,-30,2])
  rotate([0,0,180])
  rotate([180,0,0])
  fuseholder_end();

}


module test_fuseholder_stacked(num_fuses=2, thin=false){
  
  $fn=48;

  mid_height = 6.35;
  start_height = thin ? mid_height-2 : mid_height;

  // fuseholder_start(thin);

  translate([0, 0, start_height]){
    for (f = [0:num_fuses-2]){
      translate([0, 0, mid_height*f])
        fuseholder_mid();
    }
  }

  // translate([0, 0, (num_fuses-1)*mid_height + start_height]){
  //   fuseholder_end();
  // }

}


test_fuseholder_stacked(3, thin=true);


