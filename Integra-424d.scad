frHoleDia=94.0;           // Dayton Audio DMA58-8
frSpkDia=118.5;
frMountPatternDia=110.0;
frGrilleMountPatternDia=115.0;
frVolCuMM=1000 * 1000;

housingThickness=2;
baffleThickness=5;

baffleRoundRadius=5;
frSpkCupID=126.0-housingThickness*2; // + baffleRoundRadius*2;
backDepth=frVolCuMM / ((4*3.14159*(frSpkCupID/2)*(frSpkCupID/2))/2);

frSpkCupOD=frSpkCupID + housingThickness*2;

frameworkWidth=97.5;
frameworkHeight=226.1;
frameworkDepth=205.5;

m3InsertDepth=8;
m3InsertDia=4.2; // for M3 heat-set insert
m4InsertDepth=12;
m4InsertDia=5.2;

basketDepth=50;
crossoverShelfThickness=3;
crossoverShelfWidth=frSpkCupID;
crossoverShelfDepth=backDepth + frSpkCupID/2 - basketDepth + baffleThickness/2;

module term_hole_pattern() {
    for (i = [-1, 1]) {
        translate([19/2 * i, 0, 0]) cylinder(h=m4InsertDepth+1, d=5.5, $fn=32, center=true);
    }
}

module term_hole_support_pattern() {
    hull() {
        for (i = [-1, 1]) {
            translate([19/2 * i, 0, 0]) 
            cylinder(h=8, d=12, $fn=32, center=true);
        }
    }
}

module m4hole_pattern(n, diameter) {
    rotate([0, 0, (360/n)*2]) for (i = [0 : n-1]) {
        rotate([0, 0, (360/n) * i]) translate([diameter/2, 0, 0]) cylinder(h=m4InsertDepth+1, d=m4InsertDia, $fn=16, center=true);
    }
}

module m3hole_pattern(n, diameter) {
    rotate([0, 0, (360/n)*2]) for (i = [0 : n-1]) {
        rotate([0, 0, (360/n) * i]) translate([diameter/2, 0, 0]) cylinder(h=m3InsertDepth+1, d=m3InsertDia, $fn=16, center=true);
    }
}

module m4hole_support_pattern(n, diameter) {
    rotate([0, 0, (360/n)*2]) for (i = [0 : n-1]) {
        rotate([0, 0, (360/n) * i]) translate([diameter/2, 0, 0]) 
        cylinder(h=m4InsertDepth+housingThickness+1, d=m4InsertDia*2, $fn=32, center=true);
    }
}
module m3hole_support_pattern(n, diameter) {
    rotate([0, 0, (360/n)*2]) for (i = [0 : n-1]) {
        rotate([0, 0, (360/n) * i]) translate([diameter/2, 0, 0]) 
        cylinder(h=m3InsertDepth+housingThickness+1, d=m3InsertDia*2, $fn=32, center=true);
    }
}
module baffle() {
    difference() {
        union() {
            //cube([frSpkWidth, baffleThickness, baffleHeight], center=true);

            difference() {
                union() {
                    // front baffle
                    translate([0, 0, 0])
                        rotate([90, 0, 0]) cylinder(d=frSpkCupOD, h=baffleThickness, center=true, $fn=720);
                    difference() {
                        // housing ring
                        translate([0, -backDepth/2 - baffleThickness/2, 0])
                            rotate([90, 0, 0]) cylinder(d=frSpkCupOD, h=backDepth, center=true, $fn=720);
                        union() {
                            difference() {
                                translate([0, -backDepth/2 - baffleThickness/2, 0])
                                    rotate([90, 0, 0]) cylinder(d=frSpkCupID, h=backDepth, center=true, $fn=360);
                            }
                        }
                    }
                    // terminal hole supports on back
                    translate([0,-backDepth - baffleThickness - housingThickness - (frSpkCupOD - m4InsertDepth)/2, 0])
                    rotate([90, 0, 0]) term_hole_support_pattern();
                }
                
                // round edges of baffle
                /*
                translate([0, -baffleRoundRadius/2, 0]) rotate([-90, 0, 0]) rotate_extrude($fn=180) difference() {
                    translate([frSpkCupOD/2 - baffleRoundRadius, 0, 0])
                        rotate([0, 0, 0]) translate([baffleRoundRadius, baffleRoundRadius, 0]) square(baffleRoundRadius*2, center=true);
                    rotate([0, 0, 0]) translate([frSpkCupOD/2- baffleRoundRadius, 0, 0])
                        circle(baffleRoundRadius, $fn=128);
                        
                }*/
                
            }
            // cut off front of sphere
            translate([0, -backDepth + (baffleThickness)/-2, 0])
            difference() {
                sphere(d=frSpkCupOD, $fa=1, $fs=0.25);
                translate([0, frSpkCupOD/2, 0]) cube(frSpkCupOD, center=true);
            }

        }
        union() {
            translate([0,-backDepth + (baffleThickness)/-2, 0])
            difference() {
                sphere(d=frSpkCupID, $fa=1, $fs=0.25);
                union() {
                    // dent in back
                    translate([0,- frSpkCupID/2 + 8/2, 0]) cube([frSpkCupID, 8, frSpkCupID], center=true);
                    
                    translate([0, frSpkCupID/2, 0]) cube(frSpkCupID, center=true);
                    // crossover shelf
                    difference() {
                        translate([0, -(-backDepth + (crossoverShelfThickness)/-2) + crossoverShelfDepth/-2 - basketDepth, -14]) cube([crossoverShelfWidth, crossoverShelfDepth, crossoverShelfThickness], center=true);
                        union() {
                            translate([0, -(-backDepth + (crossoverShelfThickness)/-2) + crossoverShelfDepth/-2 - basketDepth, -14]) for(i = [-5 : 1 : 5]) translate([i*10 + 5, -13, 0]) cylinder(h=crossoverShelfThickness, d=5, center=true);
                            translate([0, -(-backDepth + (crossoverShelfThickness)/-2) + crossoverShelfDepth/-2 - basketDepth, -14]) for(i = [-5 : 1 : 5]) translate([i*10, -3, 0]) cylinder(h=crossoverShelfThickness, d=5, center=true);
                            translate([0, -(-backDepth + (crossoverShelfThickness)/-2) + crossoverShelfDepth/-2 - basketDepth, -14]) for(i = [-5 : 1 : 5]) translate([i*10 + 5, 8, 0]) cylinder(h=crossoverShelfThickness, d=5, center=true);
                            translate([0, -(-backDepth + (crossoverShelfThickness)/-2) + crossoverShelfDepth/-2 - basketDepth, -14]) for(i = [-5 : 1 : 5]) translate([i*10, 18, 0]) cylinder(h=crossoverShelfThickness, d=5, center=true);
                        }
                    }
                   // translate([0, (frameworkDepth)/-2, (frSpkCupID/2 + frameworkHeight)/-2]) cube([frameworkWidth+baffleThickness*2, frameworkDepth, frameworkHeight+baffleThickness*2], center=true);
                }
            }
            // flush mount recess
            //translate([0, (baffleThickness - frSpkCountersink)/2, baffleHeight/6])
            //cube([frSpkWidth, frSpkCountersink, frSpkHeight], center=true);
            
            translate([0,-backDepth + -baffleThickness - (frSpkCupOD - m4InsertDepth)/2, 0])
            rotate([90, 0, 0]) term_hole_pattern();
            
//            translate([0, (baffleThickness)/-2, frSpkCupOD/-2])
//            difference() {
                //sphere(d=frSpkCupOD, $fa=1, $fs=0.25);
//                union() {
//                                        translate([0, (frameworkDepth)/-2-baffleThickness, (frameworkHeight)/-2-baffleThickness]) cube([frameworkWidth, frameworkDepth, frameworkHeight], center=true);

                    //translate([0, 0, baffleThickness/2]) cylinder(d=frSpkCupOD-baffleThickness*2, h=baffleThickness, center=true, $fn=360);
//                }
//            }
        }
    }
}


difference() {
    union() {
        baffle();

        // flush mount recess backing
        //translate([0, (housingThickness)/-2, 0])
        //cube([frSpkDia+housingThickness, housingThickness, frSpkDia+housingThickness], center=true);
        // speaker hole supports
        translate([0, (baffleThickness + m4InsertDepth)/-2, 0])
        rotate([90, 0, 0]) rotate([0, 0, 45]) m4hole_support_pattern(4, frMountPatternDia);
        translate([0, (baffleThickness + m3InsertDepth)/-2, 0])
        rotate([90, 0, 0]) rotate([0, 0, 0]) m3hole_support_pattern(4, frGrilleMountPatternDia);
        
        // base
        difference() {
            translate([0, (20 + backDepth)/-2, frSpkCupOD/-2]) cube([frSpkCupOD/2, backDepth+20+baffleThickness, 10], center=true);
            /*
            minkowski() {
                sphere(r=0.2, $fn=64);
                translate([0, baffleThickness/2, frSpkCupOD/-2 - 3.5]) rotate([90, 0, 180]) 
                linear_extrude(0.5, center=true) text("Coaxial", 6, font="Arial Rounded MT Bold", halign="center");
            } */
        }
        
    }
    union() {
        // hole
        translate([0, 0, 0])
        rotate([90, 0, 0]) cylinder(d=frHoleDia, h=baffleThickness, center=true, $fn=360);
        // speaker mounting holes
        translate([0, (-baffleThickness + m4InsertDepth)/-2, 0])
        rotate([90, 0, 0]) rotate([0, 0, 45]) m4hole_pattern(4, frMountPatternDia);
        translate([0, (-baffleThickness + m3InsertDepth)/-2, 0])
        rotate([90, 0, 0]) rotate([0, 0, 0]) m3hole_pattern(4, frGrilleMountPatternDia);
        
        //translate([0, 0, 220]) cube(300, center=true);
    }
}

/*
translate([0, 150, 0]) intersection() {
    translate([0, 0, baffleHeight/6]) rotate([90, 0, 0]) cylinder(h=baffleRoundRadius, d=frSpkCupOD, $fn=180, center=true);
     difference() {
            translate([0, -baffleRoundRadius/2, baffleHeight/6]) rotate([90, 0, 0]) rotate_extrude($fn=180)
                translate([(frSpkCupOD)/2 - baffleRoundRadius, 0, 0]) circle(r=baffleRoundRadius, $fn=180);
        union() {
                translate([0, 0, baffleHeight/6]) rotate([90, 0, 0]) translate([0, 0, -baffleRoundRadius/2]) cylinder(h=baffleRoundRadius, d=frSpkCupOD - baffleRoundRadius*2, $fn=180, center=true);
                translate([0, -baffleRoundRadius, baffleHeight/6]) rotate([90, 0, 0]) cylinder(h=baffleRoundRadius, d=frSpkCupOD, $fn=180, center=true);
        }
    }
}

*/