$fn = 100;

dist = 18;

roller_rad = 0.75;
flange_rad = 1;

roller_height = 11;
flange_height = 0.25;

support_pressure = 0;

front_width = 12;
front_out = 1;

wheel_rad = 4;

module wheelMotor() {
    color([0.4,0.4,0.4]) translate([-1,0,-1]) cube([2,0.5,2]);
}

module paperMotor() {
    color([0.4,0.4,0.4]) translate([-1,-1,0]) cube([2,2,0.5]);
}

module roller() {
    cylinder(r=roller_rad,h=roller_height);
    cylinder(r=flange_rad,h=flange_height);
    translate([0,0,roller_height-flange_height]) cylinder(r=flange_rad,h=flange_height);
}


module backPlate() {
    square([dist+2*flange_rad+1,roller_height+0.625]);
    
    // door for electronics
}

module bottomPlate() {
    difference() {
        square([dist+2*flange_rad+1,2*flange_rad+0.75]);
        for (i=[0:1:5]) {
            translate([0,i]) square([0.25,0.5]);
            translate([dist+2*flange_rad+0.75,i]) square([0.25,0.5]);
        }
        
        for (i=[0:2:30]) {
            translate([0.5+i,0]) square([1,0.25]);
        }
    }
    
    b1 = dist-2*flange_rad-0.5;
    translate([(dist+2*flange_rad+1-b1)/2,2*flange_rad+0.75]) polygon(points = [
        [0,0],[b1,0],[(b1+front_width)/2,front_out],[(b1-front_width)/2,front_out]
    ]);
    
    
}

module topPlate() {
    bottomPlate();
}

module sidePlate() {
    square([2*flange_rad+0.75,roller_height+0.625]);
}

module supportPlate() {
    square([dist-2*flange_rad-0.5,roller_height+0.625]);
    
    // mount electronics on the back of this
}

module frontPlate() {
    // add lightening structure (possibly hexagony stuff)

    rad = 0.765;
    w = 1/8;
    
        x = 8;
    y = 8;

    square([front_width,0.5]);
    translate([0,roller_height+0.625-0.5]) square([front_width,0.5]);

    translate([0,0.5]) difference() {
        square([front_width,roller_height+0.625-1]);


        translate([-0.24,0.07]) for (a=[0:x/2+1], b=[0:y], c=[0:1/2:1/2])
			translate([(a+c)*3*rad-w/2, (b+c)*sqrt(3)*rad-w/2])
			circle(r=rad-w,$fn=6);
    }
}

module wheel() {
    circle(r=wheel_rad);
}

module render() {
    translate([0,0,0.25+1/16]) roller();
    translate([dist,0,0.25+1/16]) roller();

    translate([dist/2,-0.25-front_out-flange_rad,(roller_height+0.625)/2]) rotate(180) wheelMotor();
    translate([0,0,roller_height+0.625]) paperMotor();

    translate([-flange_rad-0.5,flange_rad+0.5]) rotate([90,0,0]) color([1,0,0]) linear_extrude(0.25) backPlate();

    translate([dist+flange_rad+0.5,flange_rad+0.5,0]) color([0,1,0]) linear_extrude(0.25) rotate(180) bottomPlate();

    translate([dist+flange_rad+0.5,flange_rad+0.5,roller_height+0.625-0.25]) color([0,0,1]) linear_extrude(0.25) rotate(180) topPlate();

    translate([-flange_rad-0.25,flange_rad+0.5]) rotate([90,0,-90]) linear_extrude(0.25) sidePlate();

    translate([dist+flange_rad+0.5,flange_rad+0.5]) rotate([90,0,-90]) linear_extrude(0.25) sidePlate();

    translate([dist/2-(dist-2*flange_rad-0.5)/2,-roller_rad+0.25-support_pressure]) rotate([90,0,0]) color([0,1,1]) linear_extrude(0.25) supportPlate();

    translate([dist/2,0.5-front_out-flange_rad,(roller_height+0.625)/2]) rotate([90,0,0]) color([0.5,1,0.5]) linear_extrude(0.25) wheel();

    translate([dist/2-front_width/2,-front_out-flange_rad]) rotate([90,0,0]) color([1,0,1,0.3]) linear_extrude(0.25) frontPlate();
}

//render();

topPlate();