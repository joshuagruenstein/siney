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
    color([0.4,0.4,0.4]) translate([0,0.4566929/2,0]) cube([1.665354,0.4566929,1.665354],center=true); 
}

module paperMotor() {
    color([0.4,0.4,0.4]) translate([0,0,0.75]) cube([1.665354,1.665354,1.49606],center=true); 
}

module roller() {
    cylinder(r=roller_rad,h=roller_height);
    cylinder(r=flange_rad,h=flange_height);
    translate([0,0,roller_height-flange_height]) cylinder(r=flange_rad,h=flange_height);
}


module backPlate() {
    difference() {
        square([dist+2*flange_rad+1,roller_height+0.625]);
    
        for (i=[0:2:30]) {
            translate([i+1,0]) square([1,0.25]);
            translate([i+1,roller_height+0.625-0.25]) square([1,0.25]);

        }
        
        for (i=[0:1:30]) {
            translate([0,i+0.25]) square([0.25,0.5]);
            translate([dist+2*flange_rad+1-0.25,i+0.25]) square([0.25,0.5]);

        }

    }
    
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
            translate([i,0]) square([1,0.25]);
        }
        
        for (i=[3:1.5:17]) translate([i+0.375,2*roller_rad+0.5+support_pressure]) square([0.75,0.25]);
            
        translate([dist+flange_rad+0.5,flange_rad+0.5,0]) circle(r=0.125);
        translate([flange_rad+0.5,flange_rad+0.5,0]) circle(r=0.125);


    }
    
    b1 = dist-2*flange_rad-0.5;
    translate([(dist+2*flange_rad+1-b1)/2,2*flange_rad+0.75]) difference() {
        polygon(points = [
        [0,0],[b1,0],[(b1+front_width)/2,front_out],[(b1-front_width)/2,front_out]
    ]);
        intersection() {
            translate([(b1-front_width)/2,front_out-0.25]) square([front_width,0.25]); 
            for (i=[0:1:30]) translate([0.25-0.5+i+(b1-front_width)/2,front_out-0.25]) square([0.5,0.25]);
       }

    }
    
    
}

module stepperMount() {
    boltRad = 0.11811/2;
    
    circle(r=0.8858268/2);
    for (i=[45:90:315]) rotate(i) translate([0.863,0]) circle(r=boltRad);
}

module topPlate() {
    difference() {
        bottomPlate();
        
        translate([dist+flange_rad+0.5,flange_rad+0.5,0]) stepperMount();
    }
}

module sidePlate() {
    difference() {
        square([2*flange_rad+0.75,roller_height+0.625]);
        
        for (i=[0:1:5]) {
            translate([i+0.5,roller_height+0.625-0.25]) square([0.5,0.25]); 
            translate([i+0.5,-0.25]) square([0.5,0.5]);
        }
        
        for (i=[0:1:30]) {
            translate([0,i-0.25]) square([0.25,0.5]);
        }
    }
    
}

module supportPlate() {
    difference() {
        square([dist-2*flange_rad-0.5,roller_height+0.625]);
        for (i=[0:1.5:25]) {
            translate([i-0.125,0]) {
                translate([0,-0.25]) square([0.75,0.5]); 
                translate([0,roller_height+0.625-0.25]) square([0.75,0.5]);
            }
        }
    }
}

module frontPlate() {
    // add lightening structure (possibly hexagony stuff)

    rad = 0.765;
    w = 1/8;
    
        x = 8;
    y = 8;

    difference() {
        square([front_width,0.5]);
        for (i = [0:1:20]) translate([i+0.25,0]) square([0.5,0.25]);
    }
    translate([0,roller_height+0.625-0.5001]) difference() {
        square([front_width,0.5]);
        for (i = [0:1:20]) {
            translate([i+0.25,0.25]) square([0.5,0.25]);
        }
    }

    difference() {
    union() { translate([0,0.5]) difference() {
        square([front_width,roller_height+0.625-1]);




        translate([-0.24,0.07]) for (a=[0:x/2+1], b=[0:y], c=[0:1/2:1/2])
			translate([(a+c)*3*rad-w/2, (b+c)*sqrt(3)*rad-w/2])
			circle(r=rad-w,$fn=6);
    }

            translate([front_width/2,(roller_height+0.625)/2]) hull() {
                for (i=[45:90:315]) rotate(i) translate([0.75,0]) circle(r=0.25);
            }
    }
    
    translate([front_width/2,(roller_height+0.625)/2]) stepperMount();


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

module layoutOne() {
    translate([0.125,0.125]) frontPlate();
    //translate([16.25,4.125]) wheel();
}

module layoutTwo() {
    translate([0.125,0.125]) topPlate();
    translate([0.125,4]) bottomPlate();
    
    translate([11.75,8]) rotate(90) sidePlate();
    translate([23.75,8]) rotate(90) sidePlate();

}

module layoutThree() {
    translate([0.125,0.125]) supportPlate();
}

module layoutFour() {
    translate([0.125,0.125]) backPlate();
}

render();