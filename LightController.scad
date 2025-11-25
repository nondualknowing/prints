panelMargin = 0.1*25.4;
panelMarginX = 0.2*25.4;
panelWidth = 0.7*25.4 + panelMarginX*2;
panelHeight = 2.5*25.4;
panelThickness = 3;

deckHeight=20;

featherHoleLength = 1.8*25.4;
featherHoleWidth = 0.7*25.4;
featherRecessDiameter = 10;
screwAnchorThickness = 1;
featherRecessDepth = panelThickness - screwAnchorThickness;

controlWidth = panelWidth + panelThickness;
controlHeight= panelThickness + deckHeight + panelThickness + deckHeight;
controlDepth = 20;

dmxHoleWidth = 16;
dmxHoleDiameter = 4.6;
dmxHoleDepth = 36;

mechEncoderHoleDiameter = 7;
magnetEncoderHoleDiameter = 10;

roundingDiameter=0.5;

module steppedHole() {
    //translate([0, 0, (panelThickness - featherRecessDepth)/-2]) 
    //    cylinder(h=featherRecessDepth, d=0.16*25.4, center=true, $fn=32);
    cylinder(h=panelThickness, d=0.1*25.4, center=true, $fn=32);
}

difference() { // omg fixme
    minkowski() {
        union() {
            cube([panelWidth, panelHeight, panelThickness - roundingDiameter], center=true);
            translate([(panelWidth + panelThickness)/2, 0, (deckHeight + panelThickness)/2]) 
                cube([panelThickness - roundingDiameter, panelHeight, deckHeight + panelThickness* 2 - roundingDiameter], center=true);
            translate([0, 0, deckHeight + panelThickness]) 
                cube([panelWidth, panelHeight, panelThickness - roundingDiameter], center=true);
            translate([panelThickness/2, (panelHeight + controlDepth)/2, 0])
                cube([panelWidth + panelThickness, controlDepth, panelThickness - roundingDiameter], center=true);
            translate([panelThickness/2, (panelHeight + panelThickness)/2 + controlDepth, (controlHeight - panelThickness)/2])
                cube([panelWidth + panelThickness, panelThickness - roundingDiameter, controlHeight - roundingDiameter], center=true);
            difference() {
                translate([panelThickness/2, (panelHeight + controlDepth)/2, deckHeight + panelThickness])
                    cube([panelWidth + panelThickness, controlDepth, panelThickness - roundingDiameter], center=true);
                translate([panelThickness/2, (panelHeight + controlDepth/2)/2, deckHeight + panelThickness])
                    cube([(panelWidth + panelThickness)/2, controlDepth/2, panelThickness - roundingDiameter], center=true);
            }
        }
        sphere(d=roundingDiameter);
    }
    union() {
        translate([(panelWidth)/2 - panelMarginX, panelHeight/-2 + panelMargin, 0]) 
            steppedHole();
        translate([(panelWidth)/2 - featherHoleWidth - panelMarginX, panelHeight/-2 + panelMargin, 0]) 
            steppedHole();
        translate([(panelWidth)/2 - panelMarginX, panelHeight/-2 + featherHoleLength + panelMargin, 0]) 
            steppedHole();
        translate([(panelWidth)/2 - featherHoleWidth - panelMarginX, panelHeight/-2 + featherHoleLength + panelMargin, 0]) 
            steppedHole();
        translate([panelThickness/2, (panelHeight + panelThickness)/2 + controlDepth, (panelThickness + deckHeight)/2])
            rotate([90, 0, 0]) cylinder(d=mechEncoderHoleDiameter, h=panelThickness, center=true, $fn=64);
    }
        translate([panelThickness/2, (panelHeight + panelThickness)/2 + controlDepth, (panelThickness + deckHeight)/2 + panelThickness + deckHeight])
            rotate([90, 0, 0]) cylinder(d=magnetEncoderHoleDiameter, h=panelThickness, center=true, $fn=64);
        translate([(dmxHoleWidth+panelThickness)/2 , (panelHeight)/-2 + dmxHoleDepth, deckHeight + (panelThickness + panelThickness)/2])
            cylinder(d=dmxHoleDiameter, h=panelThickness, center=true, $fn=32);
        translate([(dmxHoleWidth-panelThickness)/-2, (panelHeight)/-2 + dmxHoleDepth, deckHeight + (panelThickness + panelThickness)/2])
            cylinder(d=dmxHoleDiameter, h=panelThickness, center=true, $fn=32);
        translate([(panelWidth+panelThickness)/2, 0, deckHeight])
            cube([panelThickness, dmxHoleDiameter*2, panelThickness], center=true);

}
