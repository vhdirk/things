/*!
 * @author Dirk Van Haerenborgh <vhdirk@gmail.com>
 * @brief LM2596 buck converter panel mount
 */

// Units: mm.

include <MCAD/units.scad>;
use <./shapes.scad>;

// Circuit dimensions
LM2596LED_PCB_DIMENSIONS = [56.2, 35.2, 1.2];

// offset from holes to the center
LM2596LED_HOLE_OFFSET = [25, 14.1];

// Display dimensions
LM2596LED_DISPLAY_DIMENSIONS = [22, 14];

// offset from origin of display to center of pcb 
LM2596LED_DISPLAY_OFFSET = [
  -LM2596LED_DISPLAY_DIMENSIONS[0]/2,
  LM2596LED_PCB_DIMENSIONS[1]/2 - LM2596LED_DISPLAY_DIMENSIONS[1],
  0
];

LM2596LED_DISPLAY_INSET=3;

// PCB columns
LM2596LED_COLUMN_OUTER_DIA=5.8;
LM2596LED_COLUMN_INNER_DIA=2.8;
LM2596LED_COLUMN_HEIGHT = 11.5;

LM2596LED_PANEL_PADDING = [8.9/2, 5.8/2];

// Lid/Box external dimensions
LM2596LED_PANEL_DIMENSIONS = [
  LM2596LED_PCB_DIMENSIONS[0] + LM2596LED_PANEL_PADDING[0]*2,
  LM2596LED_PCB_DIMENSIONS[1] + LM2596LED_PANEL_PADDING[1]*2
];


PANEL_THICKNESS = 1.5-epsilon; // wall thickness


module lm2596led_panel(thickness=PANEL_THICKNESS,
                       padding=LM2596LED_PANEL_PADDING){

  pyramid_pad = thickness*sqrt(2);


  panel_dimensions = [
    LM2596LED_PCB_DIMENSIONS[0] + padding[0]*2,
    LM2596LED_PCB_DIMENSIONS[1] + padding[1]*2
  ];


  // visualize pcb
  // translate([padding[0], padding[1], LM2596LED_COLUMN_HEIGHT])
  // %cube(LM2596LED_PCB_DIMENSIONS, false);

  difference(){

    
    union(){
      translate([0, 0, -thickness]){
        // base plate
        cube([panel_dimensions[0], panel_dimensions[1], thickness], false);
      }

      translate([panel_dimensions[0]/2, panel_dimensions[1]/2, -thickness]){
        // pyramid for voltage display
        translate([LM2596LED_DISPLAY_OFFSET[0] - pyramid_pad*3,
                   LM2596LED_DISPLAY_OFFSET[1] - pyramid_pad*2,
                   LM2596LED_DISPLAY_OFFSET[2] - epsilon])
          pyramid(LM2596LED_DISPLAY_DIMENSIONS[0] + pyramid_pad*6, 
                  LM2596LED_DISPLAY_DIMENSIONS[1] + pyramid_pad*4,
                  clip_height=thickness+LM2596LED_DISPLAY_INSET);
      

        translate([LM2596LED_DISPLAY_OFFSET[0] - thickness,
                   LM2596LED_DISPLAY_OFFSET[1] - thickness,
                   -thickness])
        cube([LM2596LED_DISPLAY_DIMENSIONS[0] + thickness*2, 
              LM2596LED_DISPLAY_DIMENSIONS[1] + thickness*2, 
              thickness + LM2596LED_DISPLAY_INSET], false);
      }
    }

    translate([-panel_dimensions[0], -panel_dimensions[1], -thickness*2])
    cube([panel_dimensions[0]*3, panel_dimensions[1]*3, thickness], false);


    // hole for voltage adjust
    translate([panel_dimensions[0]/2, panel_dimensions[1]/2, -thickness-epsilon]){

      translate([3, -LM2596LED_PCB_DIMENSIONS[1]/2 + 1.5, 0])
        cylinder(r=1.5, h=thickness + epsilon*2);

      // holes for buttons
      translate([0, LM2596LED_PCB_DIMENSIONS[1]/2 - 4.5, -epsilon*2]){
        translate([-16.8, 0, 0])
          cylinder(r=1.5, h=10);
        translate([ 16.8, 0, 0])
          cylinder(r=1.5, h=10);
      }

      // voltage display cutout
      translate([LM2596LED_DISPLAY_OFFSET[0] - pyramid_pad*1.5,
                LM2596LED_DISPLAY_OFFSET[1] - pyramid_pad,
                LM2596LED_DISPLAY_OFFSET[2] -thickness-epsilon*2])
        pyramid(LM2596LED_DISPLAY_DIMENSIONS[0] + pyramid_pad*3, 
                LM2596LED_DISPLAY_DIMENSIONS[1] + pyramid_pad*2);

      translate(LM2596LED_DISPLAY_OFFSET)
        cube([LM2596LED_DISPLAY_DIMENSIONS[0], 
              LM2596LED_DISPLAY_DIMENSIONS[1], 
              thickness+LM2596LED_DISPLAY_INSET]);
      }
  }


  // mount columns
  translate([panel_dimensions[0]/2, panel_dimensions[1]/2, 0]){
    translate([LM2596LED_HOLE_OFFSET[0], LM2596LED_HOLE_OFFSET[1], 0])
      mount_column(LM2596LED_COLUMN_INNER_DIA, LM2596LED_COLUMN_OUTER_DIA, LM2596LED_COLUMN_HEIGHT);
    translate([-LM2596LED_HOLE_OFFSET[0], LM2596LED_HOLE_OFFSET[1], 0])
      mount_column(LM2596LED_COLUMN_INNER_DIA, LM2596LED_COLUMN_OUTER_DIA, LM2596LED_COLUMN_HEIGHT);
    translate([LM2596LED_HOLE_OFFSET[0], -LM2596LED_HOLE_OFFSET[1], 0])
      mount_column(LM2596LED_COLUMN_INNER_DIA, LM2596LED_COLUMN_OUTER_DIA, LM2596LED_COLUMN_HEIGHT);
    translate([-LM2596LED_HOLE_OFFSET[0], -LM2596LED_HOLE_OFFSET[1], 0])
      mount_column(LM2596LED_COLUMN_INNER_DIA, LM2596LED_COLUMN_OUTER_DIA, LM2596LED_COLUMN_HEIGHT);
  }

}


// translate([-LM2596LED_PANEL_DIMENSIONS[0] / 2, -LM2596LED_PANEL_DIMENSIONS[1] / 2, 1.5]) 
// lm2596led_panel();



