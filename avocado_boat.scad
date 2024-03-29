/*!
 * @author Dirk Van Haerenborgh <vhdirk@gmail.com>
 * @brief A simple avocado floater.
 * Based on: https://www.thingiverse.com/thing:2774405
 */
// Units: mm.

outer_diameter = 70;
outer_radius = outer_diameter/2;

inner_diameter = 45;
inner_radius = inner_diameter/2;

fin_diameter = 15;
fin_radius = fin_diameter / 2;

// height of the main part (in mm)
body_height = 30;
base_height = 3;

// number of polygon sides
outer_sides = 6;

// thickness of the bowl (keep above 1.5 mm)
thickness = 2;

//////////////////////////////////////////////////////
// RENDERS

// base
linear_extrude( height = base_height ) {
    difference() {
        polyShape(sides=outer_sides,
                  radius=outer_radius,
                  solid="yes" );

        polyShape(sides=360,
            radius=inner_radius,
            solid="yes" );
    }
}

// body
union(){
    linear_extrude( height = body_height, slices = 2*(body_height) ) {
        polyShape(sides=outer_sides, 
                radius=outer_radius,
                solid="no" ); // change to yes for solid bowl
    }

    rotate([90, 0, 0])
    translate([-13, 8, outer_radius])
    linear_extrude(height=2, center=true, convexity=10)
    scale(0.175)
    import("hippo_segments1.svg");
}


linear_extrude( height = body_height, slices = 2*(body_height)  ) {
    polyShape(sides=360,
            radius=inner_radius,
            solid="no" );
}

// fins

intersection(){
    difference(){

        union(){
            translate([0,inner_radius])
                cylinder(h=body_height*0.8, r=fin_radius, $fn=360);
            
            rotate([0,0,120]) 
            translate([0,inner_radius])
                cylinder(h=body_height*0.8, r=fin_radius, $fn=360);

            rotate([0,0,-120]) 
            translate([0,inner_radius])
                cylinder(h=body_height*0.8, r=fin_radius, $fn=360);

        }

        union(){
            translate([0,0,(inner_radius+thickness/2)])
            sphere(r=inner_radius+thickness*1.6, $fn=360);


        }
    }

    cylinder(h=body_height, r=inner_radius+thickness*2);

}







//////////////////////////////////////////////////////
// MODULES

module polyShape(solid, sides, radius){
    difference(){
        // start with outer shape
        offset( r=5, $fn=48 )
            circle( r=radius, $fn=sides );
        
        // take away inner shape
        if (solid=="no"){
            offset( r=5-thickness, $fn=48 )
                circle( r=radius, $fn=sides );
        }
    }
}