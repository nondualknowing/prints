frHoleDia=50.0;           // Dayton Audio DMA58-8
frSpkWidth=57.0;
frSpkHeight=57.0;
frMountPatternDia=64.3;
frSpkCountersink=4.5;
frVolCuMM=570 * 1000;

housingThickness=2;
baffleThickness=5;

frSpkCupID=129.6;
frSpkCupOD=frSpkCupID + housingThickness*2;

baffleWidth=5*25.4;
baffleHeight=7*25.4;
baffleRoundRadius=5;

insertDepth=8;
insertDia=4.2; // for M3 heat-set insert

module term_hole_pattern() {
    for (i = [-1, 1]) {
        translate([19/2 * i, 0, 0]) cylinder(h=insertDepth+1, d=5.5, $fn=32, center=true);
    }
}

module term_hole_support_pattern() {
    for (i = [-1, 1]) {
        translate([19/2 * i, 0, 0]) 
        cylinder(h=insertDepth, d=5.5+housingThickness*1.6, $fn=32, center=true);
    }
}

module hole_pattern(n, diameter) {
    rotate([0, 0, (360/n)*2]) for (i = [0 : n-1]) {
        rotate([0, 0, (360/n) * i]) translate([diameter/2, 0, 0]) cylinder(h=insertDepth+1, d=insertDia, $fn=16, center=true);
    }
}

module hole_support_pattern(n, diameter) {
    rotate([0, 0, (360/n)*2]) for (i = [0 : n-1]) {
        rotate([0, 0, (360/n) * i]) translate([diameter/2, 0, 0]) 
        cylinder(h=insertDepth+housingThickness+1, d=insertDia+housingThickness*2, $fn=32, center=true);
    }
}
module baffle() {
    difference() {
        union() {
            //cube([frSpkWidth, baffleThickness, baffleHeight], center=true);

            difference() {
                translate([0, 0, baffleHeight/6])
                    rotate([90, 0, 0]) cylinder(d=frSpkCupOD, h=baffleThickness, center=true, $fn=360);
                translate([0, -baffleRoundRadius/2, baffleHeight/6]) rotate([-90, 0, 0]) rotate_extrude($fn=180) difference() {
                    translate([frSpkCupOD/2 - baffleRoundRadius+0.1, 0, 0])
                        rotate([0, 0, 0]) translate([baffleRoundRadius/2, baffleRoundRadius/2, 0]) square(baffleRoundRadius, center=true);
                    rotate([0, 0, 0]) translate([frSpkCupOD/2- baffleRoundRadius+0.1, 0, 0])
                        circle(baffleRoundRadius, $fn=64);
                }
            }
            translate([0, (baffleThickness)/-2, baffleHeight/6])
            difference() {
                sphere(d=frSpkCupOD, $fa=1, $fs=0.25);
                translate([0, frSpkCupOD/2, 0]) cube(frSpkCupOD, center=true);
            }
            translate([0, (baffleThickness + (5.5+housingThickness*1.6))/-2, baffleHeight/6 + (frSpkCupOD - insertDepth)/2])
            term_hole_support_pattern();
            translate([0, (baffleThickness)/-2, frSpkCupOD/-2])
            difference() {
                sphere(d=frSpkCupOD, $fa=1, $fs=0.25);
                union() {
                    translate([0, 0, frSpkCupOD/-2]) cube(frSpkCupOD, center=true);
                    translate([0, 0, baffleThickness/2]) cylinder(d=frSpkCupOD-baffleThickness*2, h=baffleThickness, center=true, $fn=360);
                }
            }
            
            
        }
        union() {
            translate([0, (baffleThickness)/-2, baffleHeight/6])
            difference() {
                sphere(d=frSpkCupID, $fa=1, $fs=0.25);
                translate([0, frSpkCupID/2, 0]) cube(frSpkCupID, center=true);
            }
            // flush mount recess
            translate([0, (baffleThickness - frSpkCountersink)/2, baffleHeight/6])
            cube([frSpkWidth, frSpkCountersink, frSpkHeight], center=true);
            
            translate([0, (baffleThickness + (5.5+housingThickness*1.6))/-2, baffleHeight/6 + (frSpkCupOD - insertDepth)/2])
            term_hole_pattern();
        }
    }
}

difference() {
    union() {
        baffle();

        // flush mount recess backing
        translate([0, (housingThickness + frSpkCountersink)/-2, baffleHeight/6])
        cube([frSpkWidth+housingThickness, housingThickness, frSpkHeight+housingThickness], center=true);
        // speaker hole supports
        translate([0, (baffleThickness + frSpkCountersink + insertDepth)/-2, baffleHeight/6])
        rotate([90, 0, 0]) rotate([0, 0, 45]) hole_support_pattern(4, frMountPatternDia);
    }
    union() {
        // hole
        translate([0, -frSpkCountersink, baffleHeight/6])
        rotate([90, 0, 0]) cylinder(d=frHoleDia, h=baffleThickness, center=true, $fn=360);
        // speaker mounting holes
        translate([0, (-baffleThickness + insertDepth)/-2 -frSpkCountersink, baffleHeight/6])
        rotate([90, 0, 0]) rotate([0, 0, 45]) hole_pattern(4, frMountPatternDia);
        
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