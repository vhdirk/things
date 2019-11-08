/*!
 *  License:  Creative Commons Attribtion-NonCommercial-ShareAlike
 *  http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode
 * 
 *  Modified version of: https://www.thingiverse.com/thing:1190819
 *  Original Author: Jetty, 10th December, 2015
 *  Parametric AA Battery Box With Contacts
 * 
 * @author Dirk Van Haerenborgh <vhdirk@gmail.com>
 * @brief A simple parametric battery box with lid and place for a switch.
 */

// preview[view:north, tilt:top diagonal]

// Customizer parameters
part                            = "all";        // [holder:Holder, cover:Cover, lid: Lid, all:All Parts]
cells                           = 2;            // [1:50]
mounting_lugs                   = "sides";       // [topbottom, sides, none]
mounting_lug_screw_diameter     = 6.25;            // [1:0.1:9]
mounting_lug_thickness          = 6;            // [0.5:0.1:10]
center_channel_width            = 3.0;          // [0.2:0.1:7.0]
other_channel_width             = 2.5;          // [0.2:0.1:5.0]
cover_retainer_clearance        = 0.1;          // [0.0:0.05:0.3]
nozzle_diameter                 = 0.4;          // [0.05:0.05:0.7]
box_padding                     = 3.0;
cell_sidebar_width              = 1.5;                   

switch_compartiment             = true;
switch_plate_width              = 5.5;
switch_plate_length             = 24;
switch_plate_thickness          = 0.82;
switch_width                    = 6.3;
switch_length                   = 15.6;
switch_screw_diameter           = 2.0;
switch_screw_offset             = 2.0;
switch_position                 = "top";
switch_knob_width               = 3.0 + 1; // 1 mm extra for clearance
switch_knob_travel              = 10.2 + 1.5; // 2 * 1 mm extra for clearance

lid_bolt_diameter               = 3.0;
logo                            = true;

/* [Hidden] */
// DO NOT CHANGE THESE
AA_CELL_LENGTH                    = 50.5;     // 49.2 - 50.5mm nominal
AA_CELL_DIAMETER                  = 14.5;     // 13.5 - 14.5mm nominal
BOTTOM_THICKNESS                  = 3;
SIDE_THICKNESS                    = 0.5;
NEG_CONTACT_LENGTH                = 4.5;        // This is the length when the spring is compressed
POS_CONTACT_LENGTH                = 1.55;
CELL_BARREL_LENGTH                = AA_CELL_LENGTH + NEG_CONTACT_LENGTH + POS_CONTACT_LENGTH;
SINGLE_CELL_HOLDER_DIMENSIONS     = [AA_CELL_DIAMETER + SIDE_THICKNESS * 2,
                                     CELL_BARREL_LENGTH,
                                     AA_CELL_DIAMETER / 2 + BOTTOM_THICKNESS];
MULTI_CELL_HOLDER_DIMENSIONS      = [(SINGLE_CELL_HOLDER_DIMENSIONS[0] * cells + cell_sidebar_width * 2),
                                     SINGLE_CELL_HOLDER_DIMENSIONS[1],
                                     SINGLE_CELL_HOLDER_DIMENSIONS[2]];
TEXT_SIZE                         = 8;
TEXT_DEPTH                        = 1.20;
TEXT_OFFSET_POS_TOP               = [0, AA_CELL_LENGTH / 2 - 5, BOTTOM_THICKNESS];
TEXT_OFFSET_POS_BOTTOM            = [TEXT_OFFSET_POS_TOP[0], -TEXT_OFFSET_POS_TOP[1], TEXT_OFFSET_POS_TOP[2]];
CONTACT_DIMENSIONS                = [9.5, nozzle_diameter + 0.1, 13.9];
CONTACT_RETAINER_THICKNESS        = 0.82;
CONTACT_CLEARANCE                 = 7;
CONTACT_THICKNESS                 = 1.23;
CONTACT_RETAINER_DIMENSIONS       = [ SINGLE_CELL_HOLDER_DIMENSIONS[0],
                                      CONTACT_DIMENSIONS[1] + CONTACT_RETAINER_THICKNESS,
                                      CONTACT_DIMENSIONS[2]];
CONTACT_RETAINER_CORNER_RADIUS    = 3.0;
CONTACT_LUG_DIMENSIONS            = [3.2, CONTACT_DIMENSIONS[1], 8.7];
MOUNT_LUG_INSET                   = 12;
MOUNT_LUG_THICKNESS               = 4;
MOUNTING_LUG_SCALING              = 1;    
UNDERSIDE_CHANNELLING_THICKNESS   = BOTTOM_THICKNESS - 1;
LUG_VOID_LENGTH                   = (CONTACT_LUG_DIMENSIONS[2] - (BOTTOM_THICKNESS - UNDERSIDE_CHANNELLING_THICKNESS)) + 1;
LUG_VOID_WIDTH                    = CONTACT_LUG_DIMENSIONS[0] + 1;
COVER_THICKNESS                   = 3;
COVER_DIFFERENCE_DIMENSIONS       = [(MULTI_CELL_HOLDER_DIMENSIONS[0] + box_padding) * 2,
                                      MULTI_CELL_HOLDER_DIMENSIONS[1] * 2,
                                     (CONTACT_RETAINER_DIMENSIONS[2] + BOTTOM_THICKNESS) * 2];
HOLDER_COVER_SPACING              = 3;
COVER_RETAINER_DIAMETER           = 3;
COVER_RETAINER_OFFSET             = [ other_channel_width / 2 + COVER_RETAINER_DIAMETER / 2 + 1.25,
                                      SINGLE_CELL_HOLDER_DIMENSIONS[1] / 2 - (COVER_RETAINER_DIAMETER / 2 + 1),
                                      0];
COVER_RETAINER_HEIGHT             = UNDERSIDE_CHANNELLING_THICKNESS;
COVER_RETAINER_VERTICAL_CLEARANCE = 0.5;

SWITCH_COMPARTIMENT_WIDTH         = 10;

LID_BOLT_SPACE_WIDTH              = lid_bolt_diameter * 3;
LID_THICKNESS                     = 3;
BOX_DIMENSIONS                    = [(MULTI_CELL_HOLDER_DIMENSIONS[0] + box_padding),
                                     SINGLE_CELL_HOLDER_DIMENSIONS[1] + SWITCH_COMPARTIMENT_WIDTH + LID_BOLT_SPACE_WIDTH*2,
                                     AA_CELL_DIAMETER + BOTTOM_THICKNESS + 1];
COVER_DIMENSIONS                  = [ BOX_DIMENSIONS[0],
                                      BOX_DIMENSIONS[1],
                                      COVER_THICKNESS];
LID_DIMENSIONS                    = [ BOX_DIMENSIONS[0],
                                      BOX_DIMENSIONS[1],
                                      LID_THICKNESS];
SWITCH_COMPARTIMENT_WIDTH_MIDDLE  = (SWITCH_COMPARTIMENT_WIDTH*1.25 - switch_width)/2;

$fn = 80;
MANIFOLD_CORRECTION = 0.02;

use <./modules/roundedcube.scad>;
use <./modules/nutsnbolts.scad>;


if (part == "holder") {
  holder();
}

if (part == "cover") {
  translate([0, 0, COVER_THICKNESS])
    cover();
}

if (part == "lid") {
  lid();
}

if (part == "all") {
  all();
}



module coverRetainer()
{
  translate([0, 0, (COVER_RETAINER_HEIGHT-COVER_RETAINER_VERTICAL_CLEARANCE) / 2])
    cylinder(r=COVER_RETAINER_DIAMETER / 2, h=COVER_RETAINER_HEIGHT - COVER_RETAINER_VERTICAL_CLEARANCE/2, center=true);
}




module coverRetainerVoid()
{
  translate([0, 0, COVER_RETAINER_HEIGHT / 2 + MANIFOLD_CORRECTION])
    cylinder(r=(COVER_RETAINER_DIAMETER + cover_retainer_clearance) / 2, h=COVER_RETAINER_HEIGHT + MANIFOLD_CORRECTION * 2, center=true);
}



module all()
{
  rotate([0, 0, 90])
  {
    lugs_translate_y = (mounting_lugs == "topbottom") ? 
                            (-((mounting_lug_screw_diameter * MOUNTING_LUG_SCALING * MOUNTING_LUG_SCALING) * 2 + 
                                (mounting_lug_screw_diameter * MOUNTING_LUG_SCALING) * 2))
                                                      : 0;
    
    translate([0, SINGLE_CELL_HOLDER_DIMENSIONS[1] / 2 -(lugs_translate_y - HOLDER_COVER_SPACING)/ 2, 0])
    {
      holder();
      translate([0,
                 -BOX_DIMENSIONS[1] - HOLDER_COVER_SPACING + lugs_translate_y,
                 0]){
        cover();
      
        translate([0,
                 -BOX_DIMENSIONS[1] - HOLDER_COVER_SPACING + lugs_translate_y,
                 0])
        lid();
      }
    }
  }
}



module holder()
{
  intersection(){
    difference() {

      union(){
        // The cells compartiment
        multipleCells(cells, mounting_lugs);

        // the switch compartiment
        translate([MULTI_CELL_HOLDER_DIMENSIONS[0]/2, MULTI_CELL_HOLDER_DIMENSIONS[1]/2, 0])
        switchCompartiment();
      }

      // carve away some of the underside?
      translate([0, 0, -COVER_DIFFERENCE_DIMENSIONS[2] / 2 + MANIFOLD_CORRECTION])
        cube(COVER_DIFFERENCE_DIMENSIONS, center=true);
      

      // the retainer holes for attaching the bottom cover
      translate([- (MULTI_CELL_HOLDER_DIMENSIONS[0] + box_padding) / 2, 0, 0])
        translate([box_padding, 0, 0,])
          for (c = [0:cells-1])
          {
            // Cover retainer voids
            translate([SINGLE_CELL_HOLDER_DIMENSIONS[0] / 2 + c * SINGLE_CELL_HOLDER_DIMENSIONS[0], 0, 0])
            translate(COVER_RETAINER_OFFSET)
              coverRetainerVoid();

            translate([SINGLE_CELL_HOLDER_DIMENSIONS[0] / 2 + c * SINGLE_CELL_HOLDER_DIMENSIONS[0], 0, 0])
            translate(- COVER_RETAINER_OFFSET)
              coverRetainerVoid();

            translate([SINGLE_CELL_HOLDER_DIMENSIONS[0] / 2 + c * SINGLE_CELL_HOLDER_DIMENSIONS[0], 0, 0])
            translate([-COVER_RETAINER_OFFSET[0], COVER_RETAINER_OFFSET[1], COVER_RETAINER_OFFSET[2]])
              coverRetainerVoid();

            translate([SINGLE_CELL_HOLDER_DIMENSIONS[0] / 2 + c * SINGLE_CELL_HOLDER_DIMENSIONS[0], 0, 0])
            translate([COVER_RETAINER_OFFSET[0], -COVER_RETAINER_OFFSET[1], COVER_RETAINER_OFFSET[2]])
              coverRetainerVoid();
          }
    }
  }


  difference(){

    translate([-BOX_DIMENSIONS[0]/2, -(BOX_DIMENSIONS[1] - SWITCH_COMPARTIMENT_WIDTH) /2, 0])
    roundedcube([BOX_DIMENSIONS[0], BOX_DIMENSIONS[1], BOX_DIMENSIONS[2]], false, 1, "z");

    translate([0, SWITCH_COMPARTIMENT_WIDTH/2, (BOX_DIMENSIONS[2])/2])
    cube([MULTI_CELL_HOLDER_DIMENSIONS[0],
          MULTI_CELL_HOLDER_DIMENSIONS[1] + SWITCH_COMPARTIMENT_WIDTH,
          BOX_DIMENSIONS[2] + 2], center=true);


    // nut catches for lid bolts
    translate([-BOX_DIMENSIONS[0]/2, -(BOX_DIMENSIONS[1] - SWITCH_COMPARTIMENT_WIDTH) /2, BOTTOM_THICKNESS + UNDERSIDE_CHANNELLING_THICKNESS]){
      translate([LID_BOLT_SPACE_WIDTH/3*2, LID_BOLT_SPACE_WIDTH/2, 0]){
        nutcatch_parallel("M3", l=BOTTOM_THICKNESS*2);

        rotate([180, 0, 0])
        hole_through(name="M3", l=50);
      }

      translate([LID_BOLT_SPACE_WIDTH/3*2, BOX_DIMENSIONS[1] - LID_BOLT_SPACE_WIDTH/2, 0]){
        nutcatch_parallel("M3", l=BOTTOM_THICKNESS*2);

        rotate([180, 0, 0])
        hole_through(name="M3", l=50);
      }

      translate([BOX_DIMENSIONS[0] - LID_BOLT_SPACE_WIDTH/3*2, LID_BOLT_SPACE_WIDTH/2, 0]){
        nutcatch_parallel("M3", l=BOTTOM_THICKNESS*2);

        rotate([180, 0, 0])
        hole_through(name="M3", l=50);
      }

      translate([BOX_DIMENSIONS[0] - LID_BOLT_SPACE_WIDTH/3*2, BOX_DIMENSIONS[1] - LID_BOLT_SPACE_WIDTH/2, 0]){
        nutcatch_parallel("M3", l=BOTTOM_THICKNESS*2);

        rotate([180, 0, 0])
        hole_through(name="M3", l=50);
      }
    }

    // channel for wires
    translate([0, (BOX_DIMENSIONS[1] )/2, UNDERSIDE_CHANNELLING_THICKNESS/2])
    cube([center_channel_width,
        box_padding + LID_BOLT_SPACE_WIDTH,
        UNDERSIDE_CHANNELLING_THICKNESS], center=true);
  }
}


module switchCompartiment(){

  // using the dimensions of the switch here because my brain likes it that way
  rotate([0, 0, 90])
  {
    difference(){
      // the entire box of the switch
      cube([SWITCH_COMPARTIMENT_WIDTH, MULTI_CELL_HOLDER_DIMENSIONS[0], BOX_DIMENSIONS[2]], false);

      // the bottomside wire cutout
      translate([0, (SINGLE_CELL_HOLDER_DIMENSIONS[0] + cell_sidebar_width*2 - LUG_VOID_WIDTH)/2, 0])
      cube([SWITCH_COMPARTIMENT_WIDTH, SINGLE_CELL_HOLDER_DIMENSIONS[0]*(cells-1) + LUG_VOID_WIDTH, UNDERSIDE_CHANNELLING_THICKNESS], false);
      // set switch slightly off-center. looks nicer

      // switch cutout
      translate([SWITCH_COMPARTIMENT_WIDTH_MIDDLE, (MULTI_CELL_HOLDER_DIMENSIONS[0] - switch_length)/2, 0])
      cube([switch_width, switch_length, BOX_DIMENSIONS[2]+1], false);
  
      // switch plate cutout
      translate([SWITCH_COMPARTIMENT_WIDTH_MIDDLE - (switch_plate_width - switch_width)/2, (MULTI_CELL_HOLDER_DIMENSIONS[0] - switch_plate_length)/2, (BOX_DIMENSIONS[2] - switch_plate_thickness)])
      difference(){
        cube([switch_plate_width, switch_plate_length, BOX_DIMENSIONS[2]], false);
  
        translate([switch_plate_width/2, (switch_screw_offset + switch_screw_diameter)/2, 0])
        cylinder(h=switch_plate_thickness, r=switch_screw_diameter/2, center=true);


        translate([switch_plate_width/2, switch_plate_length - (switch_screw_offset + switch_screw_diameter)/2, 0])
        cylinder(h=switch_plate_thickness, r=switch_screw_diameter/2, center=true);
      }

    }

  }



}


module cover()
{
  translate([0, 0, COVER_THICKNESS/2.0])
    roundedcube(COVER_DIMENSIONS,
                  true,
                  1,
                  "z");

  // Cover retainers            
  translate([0, -SWITCH_COMPARTIMENT_WIDTH/2, COVER_THICKNESS])
    multipleCellsRetainersOnly(cells);
  
}




module lid()
{
  translate([0, 0, LID_THICKNESS/2])
  difference(){
      roundedcube(LID_DIMENSIONS,
                    true,
                    1,
                    "z");

    // holes for bolts
    translate([-BOX_DIMENSIONS[0]/2, -(BOX_DIMENSIONS[1]) /2, 0]){
      translate([LID_BOLT_SPACE_WIDTH/3*2, LID_BOLT_SPACE_WIDTH/2, LID_THICKNESS]){
        hole_through(name="M3", l=LID_THICKNESS*2);
      }

      translate([LID_BOLT_SPACE_WIDTH/3*2, BOX_DIMENSIONS[1] - LID_BOLT_SPACE_WIDTH/2, LID_THICKNESS]){
        hole_through(name="M3", l=LID_THICKNESS*2);
      }

      translate([BOX_DIMENSIONS[0] - LID_BOLT_SPACE_WIDTH/3*2, LID_BOLT_SPACE_WIDTH/2, LID_THICKNESS]){
        hole_through(name="M3", l=LID_THICKNESS*2);
      }

      translate([BOX_DIMENSIONS[0] - LID_BOLT_SPACE_WIDTH/3*2, BOX_DIMENSIONS[1] - LID_BOLT_SPACE_WIDTH/2, LID_THICKNESS]){
        hole_through(name="M3", l=LID_THICKNESS*2);
      }
    }

    // hole for switch travel
    translate([0, SINGLE_CELL_HOLDER_DIMENSIONS[1]/2 + SWITCH_COMPARTIMENT_WIDTH_MIDDLE - switch_knob_width/2, 0]){
      cube([switch_knob_travel, switch_knob_width, LID_THICKNESS*2], true);
    }
  }
  
  if (logo) {  
      translate([-BOX_DIMENSIONS[0]/2, -BOX_DIMENSIONS[1]/2, LID_THICKNESS])
      translate([(BOX_DIMENSIONS[0]*1.5 - BOX_DIMENSIONS[0])/2 - box_padding, LID_BOLT_SPACE_WIDTH, 0])
      linear_extrude(height=0.6, center=false, convexity=10)
      rotate([180, 0, 90])
      resize([BOX_DIMENSIONS[0]*1.55, 0, 0],auto=[true,true,false]) 
      import("hippo_segments1.svg");
      
  }


}


module coverPlateBlock()
{
  translate([0, 0, - COVER_THICKNESS / 2])
    cube([MULTI_CELL_HOLDER_DIMENSIONS[0] + box_padding,
          MULTI_CELL_HOLDER_DIMENSIONS[1] + SWITCH_COMPARTIMENT_WIDTH + box_padding * 2,
                 COVER_THICKNESS],
                 true);
}


module lugVoid()
{
  translate([0, -(LUG_VOID_LENGTH - LUG_VOID_WIDTH / 2) + MANIFOLD_CORRECTION, 0])
  {
    cylinder(r=LUG_VOID_WIDTH / 2, h=UNDERSIDE_CHANNELLING_THICKNESS, center=true);
    translate([0, (LUG_VOID_LENGTH - LUG_VOID_WIDTH / 2) / 2, 0])
      cube([LUG_VOID_WIDTH, LUG_VOID_LENGTH - LUG_VOID_WIDTH / 2, UNDERSIDE_CHANNELLING_THICKNESS], center=true);
  }
}



module horizontalChannel(width)
{
  cube([SINGLE_CELL_HOLDER_DIMENSIONS[0] + MANIFOLD_CORRECTION * 2,
        width,
        UNDERSIDE_CHANNELLING_THICKNESS], center=true);
}



module verticalChannel(width)
{
  cube([width,
        SINGLE_CELL_HOLDER_DIMENSIONS[1] - ( CONTACT_DIMENSIONS[1]) * 2,
        UNDERSIDE_CHANNELLING_THICKNESS], center=true);
}



module undersideTabsAndChanneling()
{
  translate([0, 0, UNDERSIDE_CHANNELLING_THICKNESS / 2 - MANIFOLD_CORRECTION]) {
    translate([0, SINGLE_CELL_HOLDER_DIMENSIONS[1] / 2 - CONTACT_DIMENSIONS[1], 0]) {
      lugVoid();
        
      // Lug Void Side Channel
      translate([0, -(LUG_VOID_LENGTH - (other_channel_width / 2 + LUG_VOID_WIDTH / 4)), 0])
        horizontalChannel(other_channel_width);
    }

    translate([0, -(SINGLE_CELL_HOLDER_DIMENSIONS[1] / 2 - CONTACT_DIMENSIONS[1]), 0]) {
      rotate([180, 0, 0])
        lugVoid();
      
      // Lug Void Side Channel
      translate([0, (LUG_VOID_LENGTH - (other_channel_width / 2 + LUG_VOID_WIDTH / 4)) , 0])
        horizontalChannel(other_channel_width);
    }
    
    // Center Channel
    horizontalChannel(center_channel_width);
    
    // Vertical Channel
    verticalChannel(other_channel_width);
  }
}



module mountingLug()
{
  translate([-mounting_lug_screw_diameter * MOUNTING_LUG_SCALING * MOUNTING_LUG_SCALING, 0, - COVER_THICKNESS])
    difference()
    {
      union()
      {
        cylinder(r=mounting_lug_screw_diameter * MOUNTING_LUG_SCALING, h=mounting_lug_thickness + COVER_THICKNESS);
        translate([0, -mounting_lug_screw_diameter * MOUNTING_LUG_SCALING, 0])
            cube([ mounting_lug_screw_diameter * MOUNTING_LUG_SCALING * MOUNTING_LUG_SCALING,
                    mounting_lug_screw_diameter * MOUNTING_LUG_SCALING * 2,
                    mounting_lug_thickness + COVER_THICKNESS]);

      }
      translate([0, 0, -MANIFOLD_CORRECTION])
        cylinder(r=mounting_lug_screw_diameter / 2, h=mounting_lug_thickness + COVER_THICKNESS + MANIFOLD_CORRECTION * 2);
    }
}


module multipleCells(cellCount, mounting_lugs)
{
  if (mounting_lugs == "sides")
  {
    translate([-(MULTI_CELL_HOLDER_DIMENSIONS[0] + box_padding) / 2, 0, 0])
    {
      translate([0, BOX_DIMENSIONS[1] / 2 - LID_BOLT_SPACE_WIDTH, 0])
        mountingLug();
      translate([0, -((BOX_DIMENSIONS[1] - LID_BOLT_SPACE_WIDTH) / 2 -(MOUNT_LUG_INSET + mounting_lug_screw_diameter)), 0])
        mountingLug();
    }

    translate([(MULTI_CELL_HOLDER_DIMENSIONS[0] + box_padding) / 2, 0, 0])
    {
      translate([0, BOX_DIMENSIONS[1] / 2 - LID_BOLT_SPACE_WIDTH, 0])
        rotate([0, 0, 180])
          mountingLug();
      translate([0, -((BOX_DIMENSIONS[1] - LID_BOLT_SPACE_WIDTH) / 2 - (MOUNT_LUG_INSET + mounting_lug_screw_diameter)), 0])
        rotate([0, 0, 180])
          mountingLug();
    }
  }
    
  translate([-MULTI_CELL_HOLDER_DIMENSIONS[0]/2 + box_padding/2, 0, 0]){
    for (c = [0:cellCount-1])
    {

      translate([SINGLE_CELL_HOLDER_DIMENSIONS[0] / 2 + c * SINGLE_CELL_HOLDER_DIMENSIONS[0], 0, 0]){
        singleCell(c);
      }
      
      if (mounting_lugs == "topbottom" && (c == 0 || c == (cellCount - 1)))
      {
        translate([SINGLE_CELL_HOLDER_DIMENSIONS[0] / 2 + c * SINGLE_CELL_HOLDER_DIMENSIONS[0], -SINGLE_CELL_HOLDER_DIMENSIONS[1] / 2, 0])
          rotate([0, 0, 90])
            mountingLug();
        translate([SINGLE_CELL_HOLDER_DIMENSIONS[0] / 2 + c * SINGLE_CELL_HOLDER_DIMENSIONS[0], SINGLE_CELL_HOLDER_DIMENSIONS[1] / 2, 0])
          rotate([0, 0, -90])
            mountingLug();
      }
    }
  }
  

  // Cover plate
  coverPlateBlock();
}



module multipleCellsRetainersOnly(cellCount)
{
  translate([- (MULTI_CELL_HOLDER_DIMENSIONS[0] + box_padding) / 2, 0, 0])
    translate([box_padding, 0, 0])
      for (c = [0:cellCount-1]){
        translate([SINGLE_CELL_HOLDER_DIMENSIONS[0] / 2 + c * SINGLE_CELL_HOLDER_DIMENSIONS[0], 0, 0])
          singleCellRetainersOnly();                
      }
}

module singleCell(index)
{
  difference()
  {
    union()
    {
      // The retainer blocks
      translate([0, 0, -MANIFOLD_CORRECTION])
      {
        translate([0, (SINGLE_CELL_HOLDER_DIMENSIONS[1] - CONTACT_RETAINER_DIMENSIONS[1]) / 2, 0])
          retainerBlock(CONTACT_RETAINER_DIMENSIONS, CONTACT_RETAINER_CORNER_RADIUS);
        translate([0, - (SINGLE_CELL_HOLDER_DIMENSIONS[1] - CONTACT_RETAINER_DIMENSIONS[1]) / 2, 0])
          retainerBlock(CONTACT_RETAINER_DIMENSIONS, CONTACT_RETAINER_CORNER_RADIUS);
      }
  
      difference()
      {
        x_offset = ((index == 0) ? -cell_sidebar_width : ((index == cells-1) ? cell_sidebar_width: 0));
        width = ((index > 0 && SINGLE_CELL_HOLDER_DIMENSIONS[0] < cells - 1) ? SINGLE_CELL_HOLDER_DIMENSIONS[0] : SINGLE_CELL_HOLDER_DIMENSIONS[0] + cell_sidebar_width*2);

        // The box for the cell
        translate([x_offset, 0, SINGLE_CELL_HOLDER_DIMENSIONS[2] / 2]){
          cube([width,
                SINGLE_CELL_HOLDER_DIMENSIONS[1], SINGLE_CELL_HOLDER_DIMENSIONS[2]], center=true);
        }
        // The cylinder cutout for the box
        translate([0, 0, AA_CELL_DIAMETER / 2 + BOTTOM_THICKNESS])
          rotate([-90, 0, 0])
            cylinder(r=AA_CELL_DIAMETER / 2, h=CELL_BARREL_LENGTH, center=true);

        // The cylinder cutout for fingers
        translate([x_offset, 0, AA_CELL_DIAMETER / 2 + BOTTOM_THICKNESS])
          rotate([0, 90, 0])
            cylinder(r=AA_CELL_DIAMETER / 2, h=width + MANIFOLD_CORRECTION * 2, center=true);
        
        // The positive mark text
        translate((index % 2 == 0) ? TEXT_OFFSET_POS_TOP : TEXT_OFFSET_POS_BOTTOM)
          linear_extrude(height=TEXT_DEPTH, center=true)
            text("+", font="Helvetica:Bold", valign="center", halign="center", size=TEXT_SIZE);
      }  
    }
      
    // The contact voids
    translate([0, 0, BOTTOM_THICKNESS])
    {
      translate([0, -(SINGLE_CELL_HOLDER_DIMENSIONS[1] / 2 ), 0])
        contact();

      translate([0, SINGLE_CELL_HOLDER_DIMENSIONS[1] / 2 , 0])
        rotate([0, 0, 180])
          contact();
    }


    
    // Underside tabs and channelling
    undersideTabsAndChanneling();
  }

  // The cylinder positive, visualizing a battery
  %translate([0, 0, AA_CELL_DIAMETER / 2 + BOTTOM_THICKNESS])
    rotate([-90, 0, 0])
      cylinder(r=AA_CELL_DIAMETER / 2, h=CELL_BARREL_LENGTH, center=true);
}



module singleCellRetainersOnly()
{
  // Cover retainers
  translate(COVER_RETAINER_OFFSET)
    coverRetainer();
  translate(- COVER_RETAINER_OFFSET)
    coverRetainer();
  translate([-COVER_RETAINER_OFFSET[0], COVER_RETAINER_OFFSET[1], COVER_RETAINER_OFFSET[2]])
    coverRetainer();
  translate([COVER_RETAINER_OFFSET[0], -COVER_RETAINER_OFFSET[1], COVER_RETAINER_OFFSET[2]])
    coverRetainer();
}



// Creates a retainer block, if corners="left", rounded corner is on the left
// if corners="right", rounded corner is on the right
// if corners="none", there are no rounded corners, it's rectangular

module retainerBlock(dimensions, radius)
{
  translate([0, 0, dimensions[2] / 2 + BOTTOM_THICKNESS])
    rotate([90, 0, 0])
      hull() {
        // Top Left corner
        translate([-dimensions[0] / 2 + radius, dimensions[1] / 2 - radius, 0]) {
          cube([radius * 2, radius * 2, dimensions[1]], center=true);
        }
        
        // Top Right corner
        translate([dimensions[0] / 2 - radius, dimensions[1] / 2 - radius, 0]) {
          cube([radius * 2, radius * 2, dimensions[1]], center=true);
        }
        
        // Bottom Corners
        translate([0, -(dimensions[2] / 2), 0]) {
          // Bottom left corner
          translate([-(dimensions[0] / 2 - radius), 0, 0])
            cube([radius * 2- radius, radius * 2, dimensions[1]], center=true);

          // Bottom right corner
          translate([(dimensions[0] / 2 - radius), 0, 0])
            cube([radius * 2- radius, radius * 2, dimensions[1]], center=true);
        }            
      }
}

    

module contact()
{
  translate([0, CONTACT_DIMENSIONS[1] / 2, 0]) {
    // Main plate
    translate([0, 0, CONTACT_DIMENSIONS[2] / 2])
      cube(CONTACT_DIMENSIONS, center=true);
    
    // Solder Lug
    translate([0, 0, -(CONTACT_LUG_DIMENSIONS[2] / 2 - MANIFOLD_CORRECTION)]) {
      cube(CONTACT_LUG_DIMENSIONS, center=true);
      //translate([0, (CONTACT_LUG_DIMENSIONS[2] - 1) / 2, CONTACT_LUG_DIMENSIONS[2] / 2 - 2 + CONTACT_LUG_DIMENSIONS[1] / 4 ])
      //  % cube([CONTACT_LUG_DIMENSIONS[0], CONTACT_LUG_DIMENSIONS[2] - 1, CONTACT_LUG_DIMENSIONS[1]], center=true);
    }

    // Contact and opening
    translate([0, CONTACT_THICKNESS / 2, CONTACT_DIMENSIONS[2] / 2])
      rotate([90, 0, 0]) {
        // Contact
        cylinder(r=CONTACT_CLEARANCE / 2, h=CONTACT_THICKNESS, center=true);
        
        // Contact opening
        translate([0, CONTACT_RETAINER_DIMENSIONS[1] / 4, 0])
          cube([CONTACT_CLEARANCE, CONTACT_RETAINER_DIMENSIONS[1] / 2, CONTACT_THICKNESS], center=true);
      }
  }
}
