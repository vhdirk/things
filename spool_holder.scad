/*!
 * @author Dirk Van Haerenborgh <vhdirk@gmail.com>
 * @brief A horizontal spool holder.
 * inspired by
 * https://diyers.com.br/index.php/en/2018/07/02/graber-i3-horizontal-filament-spool-holder/
 */

// Units: mm.

include <MCAD/units.scad>
use <./lib/shapes.scad>;
use <./lib/nutsnbolts.scad>;

BASE_THICKNESS = 10;
FLAP_THICKNESS = 6;
FRAME_THICKNESS = 8;
FRAME_ANGLE = 64.75;
MAX_HEIGHT = 40;

PLATE_THICKNESS = 3;

BEARING_OUTER_DIA = 42;
BEARING_INNER_DIA = 25;
BEARING_HEIGHT = 11;

OVERHANG = 75;

CENTER_POLE_DIA = 2.4;

// max and min size of the spool holder diameter
HOLDER_MAX_DIA = 80;
HOLDER_MIN_DIA = 25;

// height of the holder
CONE_HEIGHT = 25;



$fn=360
;




// difference(){

//   #translate([21, 105, -2])
//   rotate([0, 0, 90])
//   import("tmp/LowerBase.stl");

//   // translate([-100, -100, 3+epsilon])
//   // cube([300, 300, 200]);
// }


module mount_base(){
  
  end_width = (BEARING_OUTER_DIA/2+4) * 2;

  translate([0, 0, -BASE_THICKNESS]){

    tri_offset = (end_width/2-1);

    translate([tri_offset, 20, 0])
    basic_triangle(OVERHANG-20, MAX_HEIGHT - tri_offset + FRAME_THICKNESS/2, BASE_THICKNESS);

    translate([-tri_offset-1, 20, 0])
    cube([(tri_offset+1)*2, OVERHANG-20, BASE_THICKNESS]);

    translate([-tri_offset, 20, 0])
    mirror([1,0,0])
    basic_triangle(OVERHANG-20, MAX_HEIGHT - tri_offset + FRAME_THICKNESS/2, BASE_THICKNESS);

    translate([-40-FRAME_THICKNESS/2, -FRAME_THICKNESS, 0])
    cube([80+FRAME_THICKNESS, 20 + FRAME_THICKNESS, BASE_THICKNESS]);

    translate([0, -FRAME_THICKNESS - FLAP_THICKNESS, 0])
    cube([40+FRAME_THICKNESS/2, 10, BASE_THICKNESS]);


    translate([0, OVERHANG, 0]){
      cylinder(BASE_THICKNESS*1.5, end_width/2, end_width/2);


      // cylinder(THICKNESS, 65, 65);
    }
  }
}


module mount_flap_y(height=40){
  
  length = OVERHANG + BEARING_OUTER_DIA/2;

  cube([FLAP_THICKNESS, length, MAX_HEIGHT]);

}

module mount_flap_x(){
  cube([20, FLAP_THICKNESS, MAX_HEIGHT]);

  translate([20, 0, 0])
  cube([20, FLAP_THICKNESS, 20]);

  translate([20, 0, 20])
  rotate([0, 0, -90])
  rotate([0, -90, 0])
  basic_triangle(20, MAX_HEIGHT-20, FLAP_THICKNESS);

}


module mount_flaps(){

    translate([FRAME_THICKNESS/2, 0, 0])
      mount_flap_y();
    
    translate([-FRAME_THICKNESS/2 - FLAP_THICKNESS, 0, 0])
      mount_flap_y();

    translate([FRAME_THICKNESS/2, 0, 0]){
      mount_flap_x();


      difference(){
        translate([0, -FLAP_THICKNESS - FRAME_THICKNESS, 0]) 
          mount_flap_x();

        // cut off bit of side for frame screw
        translate([-FRAME_THICKNESS/2, -FLAP_THICKNESS - FRAME_THICKNESS - epsilon, 31]) 
          rotate([90, 0, 0])
          cylinder(20, 6.1, 6.1, center=true);

      }
    }



    difference(){
      translate([-FRAME_THICKNESS/2, 0, 0])

      mirror([1, 0, 0])
      mount_flap_x();

      translate([-FRAME_THICKNESS-8.5, FLAP_THICKNESS/2-epsilon, 10])
      rotate([90, 0, 0])
      cylinder(r=1.5, h=FLAP_THICKNESS+4*epsilon, center=true);

      translate([-FRAME_THICKNESS-8.5-20, FLAP_THICKNESS/2-epsilon, 10])
      rotate([90, 0, 0])
      cylinder(r=1.5, h=FLAP_THICKNESS+4*epsilon, center=true);

    }



    translate([-FRAME_THICKNESS/2, 25.5, 0]){
      // inverse flap

      length = OVERHANG-25.5 + BEARING_OUTER_DIA/2;
      height = length / sin(FRAME_ANGLE);

      difference(){
        translate([0, length, 0])
        rotate([180, 0, 0])
        rotate([0, 90, 0])
        basic_triangle(length, height, FRAME_THICKNESS);

        translate([-epsilon*2, 0, MAX_HEIGHT])
          cube([FRAME_THICKNESS+epsilon*4, length + epsilon, height + epsilon]);
      }
    }
}


module spool_base(){

  translate([21, 105, -THICKNESS]){

    difference(){
      cylinder(THICKNESS, 65, 65);

      translate([0, 0, -epsilon])
      cylinder(THICKNESS+2*epsilon, 21, 21);


    }

  }

}


module main(){

  difference(){
    union(){
      difference(){
        union(){
          mount_base();
          mount_flaps();
        }

        translate([0, OVERHANG, -BASE_THICKNESS-epsilon])
          cylinder(BEARING_HEIGHT/2 + 2*epsilon, BEARING_OUTER_DIA/2, BEARING_OUTER_DIA/2);
      }
      translate([0, OVERHANG, -BASE_THICKNESS])
        cylinder(BEARING_HEIGHT/2 + 2*epsilon, BEARING_INNER_DIA/2, BEARING_INNER_DIA/2);
    }

    translate([0, OVERHANG, -BASE_THICKNESS-epsilon])
      cylinder(BASE_THICKNESS + MAX_HEIGHT/2, CENTER_POLE_DIA/2, CENTER_POLE_DIA/2);

  }
}


module spool_plate(){

  difference(){
    union(){
      translate([0, 0, -PLATE_THICKNESS]){
        difference(){

          union(){
            // cylinder(BEARING_HEIGHT, 25, 25);

            cylinder(PLATE_THICKNESS, 65, 65);
          }

          translate([0, 0, -epsilon])
            cylinder(BEARING_HEIGHT/2 + 2*epsilon, BEARING_OUTER_DIA/2, BEARING_OUTER_DIA/2);
          
        }

        cylinder(BEARING_HEIGHT/2 + 2*epsilon, BEARING_INNER_DIA/2, BEARING_INNER_DIA/2);
      
      }

      spool_cone();

      translate([0, 0, CONE_HEIGHT])
      thread(HOLDER_MIN_DIA/2, 70, 6);
    }
    cylinder(100, CENTER_POLE_DIA/2+0.2, CENTER_POLE_DIA/2+0.2);
  }
}


module spool_cone(base_thickness = 0){
  difference(){

    union(){
      if (base_thickness > 0){
        cylinder(base_thickness, HOLDER_MAX_DIA/2, HOLDER_MAX_DIA/2);
      }

      // cone
      translate([0, 0, CONE_HEIGHT/2+ base_thickness])
        cylinder(r1 = HOLDER_MAX_DIA/2, r2 = HOLDER_MIN_DIA/2, h = CONE_HEIGHT, center=true);
    }
  

    // // cutout for the bearing underside
    // translate([0, 0, bearing_height/2-epsilon])
    //   cylinder(r=bearing_dia/2, h=bearing_height, center=true);

    // // cutout for the bearing topside
    // translate([0, 0, CONE_HEIGHT - bearing_height/2 + epsilon])
    //   cylinder(r=bearing_dia/2, h=bearing_height, center=true);

    // // the center rod 
    // translate([0, 0, CONE_HEIGHT/2])
    //   cylinder(r=rod_dia/2, h=CONE_HEIGHT, center=true);

    // material saving cutout
    translate([HOLDER_MAX_DIA/1.9, 0,0])
      cylinder(r=HOLDER_MAX_DIA/4, h=HOLDER_MAX_DIA, center=true);
    translate([-HOLDER_MAX_DIA/1.9, 0,0])
      cylinder(r=HOLDER_MAX_DIA/4, h=HOLDER_MAX_DIA, center=true);
    translate([0,HOLDER_MAX_DIA/1.9, 0])
      cylinder(r=HOLDER_MAX_DIA/4, h=HOLDER_MAX_DIA, center=true);
    translate([0,-HOLDER_MAX_DIA/1.9,0])
      cylinder(r=HOLDER_MAX_DIA/4, h=HOLDER_MAX_DIA, center=true);	
  }
}

module knob(){
  difference(){
    spool_cone(PLATE_THICKNESS);

    translate([0, 0, -epsilon])
    thread(HOLDER_MIN_DIA/2, 70, 6);

  }

}


main();

translate([0, -120, 0])
spool_plate();

translate([120, -120, 0])
knob();
