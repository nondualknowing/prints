//subHoleDia=120.5;   // Tang Band W5-1138SM
//subSpkDia=158;
//subMountPatternDia=145.0;
//subSpkCountersink=4.0;

subHoleDia=127.0;   // Epique E150HE-44
subSpkDia=155;
subMountPatternDia=140;
subSpkCountersink=5.5;

prHoleDia=127.0;          // Epique E150HE-PR
prSpkDia=155;
prMountPatternDia=140;
prSpkCountersink=5.5;

housingThickness=10;
flangeThickness=4;
ribThickness=5;
ribDepth=12 + housingThickness;

boxWidth=240;
boxHeight=max(subSpkDia, prSpkDia) + housingThickness*2;
boxDepth=boxHeight+40;
bumperHeight=20;

insertDepth=12;
insertDia=5.2; // for M4 heat-set insert

innerBoxWidth=boxWidth - housingThickness*2;
innerBoxHeight=boxHeight - housingThickness*2;
innerBoxDepth=boxDepth - housingThickness*2;

            
module box_shape(boxWidth, boxDepth, boxHeight) {
    difference() {
        rotate([0, 0, 0]) cube([boxWidth, boxDepth, boxHeight], center=true);
        difference() {
            cube([boxWidth*2, boxDepth*2, boxHeight*2], center=true);
            union() {
                hull() {
                    translate([0, -(max(boxHeight, boxDepth) - min(boxHeight, boxDepth))/2, 0]) rotate([0, 90, 0]) cylinder(h=boxWidth, d=min(boxHeight, boxDepth), center=true, $fn=360);
                    translate([0, +(max(boxHeight, boxDepth) - min(boxHeight, boxDepth))/2, 0]) rotate([0, 90, 0]) cylinder(h=boxWidth, d=min(boxHeight, boxDepth), center=true, $fn=360);
                    translate([0, 0, boxHeight/-4]) cube([boxWidth, boxDepth, boxHeight/2], center=true);
                }
            }
        }
    }
}

module speaker_cutout(dia,depth) {
    cylinder(h=depth, d=dia, center=true, $fn=180);
}

module hole_pattern(n, diameter) {
    rotate([0, 0, (360/n)*2]) for (i = [0 : n-1]) {
        rotate([0, 0, (360/n) * i]) translate([diameter/2, 0, 0]) cylinder(h=insertDepth+1, d=insertDia, $fn=16, center=true);
    }
}

module hole_support_pattern(n, diameter, id, od) {
    rotate([0, 0, (360/n)*2]) for (i = [0 : n-1]) {
        rotate([0, 0, (360/n) * i]) translate([diameter/2, 0, 0]) 
        cylinder(h=insertDepth+housingThickness, d=insertDia+5*2, $fn=32, center=true);
    }
    // reinforcing rib to prevent speaker mounting ring from bowing between the screws
    difference() {
        cylinder(h=ribDepth/3, d=diameter+ribThickness, $fn=180, center=true);
        cylinder(h=ribDepth/3, d=diameter-ribThickness, $fn=180, center=true);
    }
    // ring of reinforcing ribs
    ribCount=floor(((3.14159*id)/15)/n)*n;
    ribLength=(od-id+housingThickness)/2;
    rotate([0, 0, (360/ribCount)*2]) for (i = [0 : ribCount-1]) {
        rotate([0, 0, (360/ribCount) * i]) translate([(ribLength + id)/2, 0, 0]) 
        cube([ribLength, 1.5, ribDepth], center=true);
    }
}

module base_support_pattern(diameter) {
    outDiameter = min(boxWidth, boxDepth);
    ribDepth=bumperHeight + housingThickness/2;
    // reinforcing rib to prevent speaker mounting ring from bowing between the screws
    translate([0, 0, (ribDepth - ribDepth/2)/3*2]) difference() {
        cylinder(h=ribDepth/3, d=(diameter+outDiameter)/2+ribThickness, $fn=180, center=true);
        cylinder(h=ribDepth/3, d=(diameter+outDiameter)/2-ribThickness, $fn=180, center=true);
    }
    // ring of reinforcing ribs
    ribCount=floor((3.14159*outDiameter)/15);
    rotate([0, 0, (360/ribCount)*2]) for (i = [0 : ribCount-1]) {
        ribLength=(outDiameter - diameter)/2;
        rotate([0, 0, (360/ribCount) * i]) translate([(ribLength + diameter)/2, 0, 0]) 
        cube([ribLength, 2, ribDepth], center=true);
    }
}

module term_hole_pattern() {
    for (i = [-1, 1]) {
        translate([19/2 * i, 0, 0]) cylinder(h=insertDepth+1, d=5.5, $fn=32, center=true);
    }
}

module term_hole_support_pattern() {
    for (i = [-1, 1]) {
        translate([19/2 * i, 0, 0]) 
        cylinder(h=insertDepth, d=5.5+housingThickness, $fn=32, center=true);
    }
}

module logo() {
    // "logo"
    stripeHeight=27;
    stripeOffset=13;
    stripeSpacing=22;
    stripeCount=10;

    translate([0, (boxDepth - 0.5)/2, (boxHeight)/-2 + 10]) rotate([90, 0, 0]) linear_extrude(height = 0.5, center=true) {
        for(i = [floor(stripeCount/-2) : floor(stripeCount/2)]) {
            translate([stripeSpacing*i, 0, 0]) polygon(points=[[-stripeOffset, 0], [0, stripeHeight], [stripeOffset,stripeHeight], [0,0]]);
        }
        //text("test", size = 12, font = "Ariel Black");
    }            
}

module feet(offset) {
    bumperDiameter=34 - housingThickness/2;
    union() {
        translate([(boxWidth - bumperDiameter - offset*2)/-2, (boxDepth - bumperDiameter - offset*2)/2, (boxHeight + bumperHeight)/-2])
            cylinder(h=bumperHeight, d=bumperDiameter, center=true, $fn=128);
        translate([(boxWidth - bumperDiameter - offset*2)/2, (boxDepth - bumperDiameter - offset*2)/2, (boxHeight + bumperHeight)/-2]) 
            cylinder(h=bumperHeight, d=bumperDiameter, center=true, $fn=128);

        translate([(boxWidth - bumperDiameter - offset*2)/2, (boxDepth - bumperDiameter - offset*2)/-2, (boxHeight + bumperHeight)/-2]) 
            cylinder(h=bumperHeight, d=bumperDiameter, center=true, $fn=128);
        translate([(boxWidth - bumperDiameter - offset*2)/-2, (boxDepth - bumperDiameter - offset*2)/-2, (boxHeight + bumperHeight)/-2]) 
            cylinder(h=bumperHeight, d=bumperDiameter, center=true, $fn=128);
    }
}

module feet_holes_support() {
    bumperDiameter=34 - housingThickness/2;
    union() {
        translate([(boxWidth - bumperDiameter)/-2, (boxDepth - bumperDiameter)/2, (boxHeight - insertDepth - housingThickness)/-2])
            cylinder(h=insertDepth+housingThickness, d=insertDia+5*2, $fn=32, center=true);
        translate([(boxWidth - bumperDiameter)/2, (boxDepth - bumperDiameter)/2, (boxHeight - insertDepth - housingThickness)/-2]) 
            cylinder(h=insertDepth+housingThickness, d=insertDia+5*2, $fn=32, center=true);

        translate([(boxWidth - bumperDiameter)/2, (boxDepth - bumperDiameter)/-2, (boxHeight - insertDepth - housingThickness)/-2]) 
            cylinder(h=insertDepth+housingThickness, d=insertDia+5*2, $fn=32, center=true);
        translate([(boxWidth - bumperDiameter)/-2, (boxDepth - bumperDiameter)/-2, (boxHeight - insertDepth - housingThickness)/-2]) 
            cylinder(h=insertDepth+housingThickness, d=insertDia+5*2, $fn=32, center=true);
    }
}

module feet_holes(offset) {
    bumperDiameter=34 - housingThickness/2;
    union() {
        translate([(boxWidth - bumperDiameter)/-2, (boxDepth - bumperDiameter)/2, (boxHeight - insertDepth)/-2])
            cylinder(h=insertDepth+1, d=insertDia, $fn=16, center=true);
        translate([(boxWidth - bumperDiameter)/2, (boxDepth - bumperDiameter)/2, (boxHeight - insertDepth)/-2]) 
            cylinder(h=insertDepth+1, d=insertDia, $fn=16, center=true);

        translate([(boxWidth - bumperDiameter)/2, (boxDepth - bumperDiameter)/-2, (boxHeight - insertDepth)/-2]) 
            cylinder(h=insertDepth+1, d=insertDia, $fn=16, center=true);
        translate([(boxWidth - bumperDiameter)/-2, (boxDepth - bumperDiameter)/-2, (boxHeight - insertDepth)/-2]) 
            cylinder(h=insertDepth+1, d=insertDia, $fn=16, center=true);
    }
}

module speaker_mounting_holes_support() {
    translate([0, 0, (boxHeight - insertDepth - flangeThickness)/-2 + subSpkCountersink]) 
        rotate([0, 0, 0]) hole_support_pattern(n=4, diameter=subMountPatternDia, id=subHoleDia, od=subSpkDia);

    translate([(boxWidth - insertDepth - flangeThickness)/2 - prSpkCountersink, 0, 0]) rotate([90, 45, 90]) 
        hole_support_pattern(n=4, diameter=prMountPatternDia, id=prHoleDia, od=prSpkDia);
    translate([(boxWidth - insertDepth - flangeThickness)/-2 + prSpkCountersink, 0, 0]) rotate([-90, 45, 90]) 
        hole_support_pattern(n=4, diameter=prMountPatternDia, id=prHoleDia, od=prSpkDia);
}

module speaker_mounting_rings() {
    // prs
    color([0.3, 0.8, 0.3]) translate([(boxWidth - flangeThickness)/2 - prSpkCountersink, 
    0, 0]) rotate([90, -90, 90]) 
        speaker_cutout(dia=prSpkDia+housingThickness*2, depth=flangeThickness);
    color([0.3, 0.8, 0.3]) translate([(boxWidth - flangeThickness)/-2 + prSpkCountersink, 
    0, 0]) rotate([-90, -90, 90]) 
        speaker_cutout(dia=prSpkDia+housingThickness*2, depth=flangeThickness);
    
    // sub
    color([0.3, 0.8, 0.3]) translate([0, 
    0, 
    (boxHeight - flangeThickness)/-2 + subSpkCountersink]) rotate([0, 0, 0]) 
        speaker_cutout(dia=subSpkDia+housingThickness*2, depth=flangeThickness);
}

module speaker_mounting_cutouts() {
    // prs
    translate([(boxWidth - insertDepth - housingThickness - prSpkCountersink)/2, 0,
        0]) 
        rotate([90, 90, 90]) 
        speaker_cutout(dia=prHoleDia, depth=insertDepth+housingThickness+prSpkCountersink);
    translate([(boxWidth - insertDepth)/2 - prSpkCountersink, 0,
        0])
        rotate([90, 45, 90]) 
        hole_pattern(n=4, diameter=prMountPatternDia);

    translate([(boxWidth - insertDepth - housingThickness - prSpkCountersink)/-2, 
        0, 0]) 
        rotate([-90, 90, 90]) 
        speaker_cutout(dia=prHoleDia, depth=insertDepth+housingThickness+prSpkCountersink);
    translate([(boxWidth - insertDepth)/-2 + prSpkCountersink, 
        0, 0])
        rotate([-90, 45, 90]) 
        hole_pattern(n=4, diameter=prMountPatternDia);

    // sub
    translate([0, 
        0, 
        (boxHeight - insertDepth - housingThickness - subSpkCountersink)/-2]) 
        rotate([0, 0, 0]) 
        speaker_cutout(dia=subHoleDia, depth=insertDepth+housingThickness+subSpkCountersink);
    translate([0, 
        0, 
        (boxHeight - insertDepth)/-2 + subSpkCountersink])
        rotate([0, 0, 0]) 
        hole_pattern(n=4, diameter=subMountPatternDia);
}

module speaker_countersink_flanges() {
    // prs
    color([0.3, 0.8, 0.3]) translate([(boxWidth - prSpkCountersink)/2, 0,
        0]) 
        rotate([90, 90, 90]) 
        speaker_cutout(dia=prSpkDia, depth=prSpkCountersink);
    color([0.3, 0.8, 0.3]) translate([(boxWidth - prSpkCountersink)/-2, 0,
        0]) 
        rotate([-90, 90, 90]) 
        speaker_cutout(dia=prSpkDia, depth=prSpkCountersink);
        
    // sub
    color([0.3, 0.8, 0.3]) translate([0, 
        0, 
        (boxHeight - subSpkCountersink)/-2]) 
        rotate([0, 0, 0]) 
        speaker_cutout(dia=subSpkDia, depth=subSpkCountersink);
}

module terminal_holes_support() {
    translate([0, (boxDepth - insertDepth)/2, (boxHeight - 19)/-4]) rotate([90, 0, 0])    
        term_hole_support_pattern();
}

module terminal_hole_pattern() {
    translate([0, (boxDepth - insertDepth)/2, (boxHeight - 19)/-4]) rotate([90, 0, 0])
        term_hole_pattern();
}

module speaker() {
    difference() {
        union() {
            difference() {
                minkowski() {
                    sphere(r=housingThickness/2, $fn=64);
                    union() {
                        box_shape(boxWidth=boxWidth-housingThickness, boxDepth=boxDepth-housingThickness, boxHeight=boxHeight-housingThickness);
                        
                        //feet(housingThickness/2);
                    }
                }
              
                minkowski() {
                    sphere(r=housingThickness/2, $fn=64);
                    box_shape(boxWidth=innerBoxWidth-housingThickness, boxDepth=innerBoxDepth-housingThickness, boxHeight=innerBoxHeight-housingThickness);
                }
                boxVolume = (innerBoxWidth*innerBoxDepth*innerBoxHeight)/1000;
                cylVolume = (3.14159*(max(innerBoxHeight, innerBoxDepth)/2)*(max(innerBoxHeight, innerBoxDepth)/2)*innerBoxWidth)/1000;
                echo("Width: ", innerBoxWidth, " Depth: ", innerBoxDepth, " SqVolume: ", boxVolume, boxVolume/2 + cylVolume/2, "cc");
                
                // cut away (comment for print)
                //translate([0, 0, 40]) rotate([90, 0, 0]) cube([256, 40*2.5, 256], center=true);
            }

            speaker_mounting_holes_support();
            terminal_holes_support();
            speaker_mounting_rings();
            feet_holes_support();
            //translate([0, 0, (boxHeight + bumperHeight + housingThickness/2)/-2]) base_support_pattern(subSpkDia);
        }

        speaker_mounting_cutouts();
        speaker_countersink_flanges();
        terminal_hole_pattern();
        feet_holes();
        color("Green") logo();
    }
}

speaker();
