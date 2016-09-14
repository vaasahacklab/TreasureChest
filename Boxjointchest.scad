materialThickness = 4;
cutWidth = 0.05;
 
width = 100;
height = 50;
depth = 80;
 
axisWidth = 2;
plankCount = 12;
jointLength = 10;
footWidth = 30;
latchHeight = 15;
latchHoleOffset = 10;
lockHoleDiam = 8;
 
color_1 = [0,0,0];
color_2 = [1,0,0];
 
//constants
PI = 3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679828651328230;
 
//derived values (do not touch these unless you know what you are doing):
plankLength = width - 2*materialThickness - 2*cutWidth;
echo("plankLength"); echo(plankLength);
plankWidth = PI*(((depth/2)-materialThickness)/plankCount);
echo("plankWidth"); echo(plankWidth);
outerPlankWidth = PI*(((depth/2))/plankCount);
echo("outerPlankWidth"); echo(outerPlankWidth);
maleJointWidth = materialThickness + 2*cutWidth;
echo("maleJointWidth"); echo(maleJointWidth);
femaleJointWidth = materialThickness;
echo("femaleJointWidth"); echo(femaleJointWidth);
maleJointLength = jointLength + 2*cutWidth;
echo("maleJointLength"); echo(maleJointLength);
femaleJointLength = jointLength - 2*cutWidth;
echo("femaleJointLength"); echo(femaleJointLength);
latchProtrusion = 3*materialThickness;
latchRingDiam = 2*materialThickness;
jointCount_x = (width-2*footWidth)/jointLength/2;
jointCount_y = (depth-2*footWidth)/jointLength/2;
jointCount_z = height/jointLength/2-1;
latchProtrusion = 3*materialThickness;
latchDiscDiam = 2*materialThickness;
footHeight = 10;
 
dist = 2;
 
//module dimensions:
plank_x = plankLength + 2*materialThickness;
plank_y = plankWidth;
top_x = plank_x;
top_y = plankCount*(plankWidth+dist);
front_y = height + footHeight;
front_x = width;
 
$fn = 50;
build = false;
 
if(build) {
    bottom();
    translate([0,depth/2+height/2+dist+footHeight]) back();
    translate([0,-(depth/2+height/2+dist)]) front();
    translate([(width/2+height/2+dist+footHeight),0])rotate([0,0,270])side();
    translate([-(width/2+height/2+dist+footHeight),0])rotate([0,0,90])side();
    translate([0,depth/2+height+5*dist+footHeight]) top();
    translate([width/2+height+2*dist+footHeight,0]) rotate([0,0,270]) lidSide();
    translate([-(width/2+height+2*dist+footHeight),0]) rotate([0,0,90]) lidSide();
    translate([(width/2+dist),depth+dist]) rotate([0,0,270])lidRim();
    translate([-(width/2+dist),depth+dist]) rotate([0,0,90])lidRim();
    translate([(width/2+dist), -depth/2-dist-materialThickness*.75]) hinge_lower();
    translate([(width/2+dist), -depth/2-dist-materialThickness*3.75]) hinge_lower();
    translate([-(width/2+dist), -depth/2-dist-materialThickness*.75]) mirror() hinge_lower();
    translate([-(width/2+dist), -depth/2-dist-materialThickness*3.75]) mirror() hinge_lower();
    translate([(width/2+dist+materialThickness), -depth/2-2*dist-materialThickness*6.75]) latchSide();
    translate([-(width/2+dist+materialThickness), -depth/2-2*dist-materialThickness*6.75]) mirror() latchSide();
    translate([(width/2+dist+9*materialThickness), -depth/2-2*dist-materialThickness*12.75]) hinge_upper();
    translate([-(width/2+4*dist), -depth/2-2*dist-materialThickness*12.75]) mirror() hinge_upper();
    translate([-(width/2+4*dist), -depth/2-2*dist-materialThickness*16.75]) mirror() hinge_upper();
    translate([(width/2+dist+10*materialThickness), -depth/2-2*dist-materialThickness*4]) mirror() latchRing();
    translate([(width/2+dist+5*materialThickness), -depth/2-2*dist-materialThickness*13]) mirror() latchBase();
   
}

latchSide();

module hinge_upper(){
    rotate([0,0,-90])
    translate([-depth/2-materialThickness,0]){
        difference(){
            union(){
                //translate([depth/2, -materialThickness])square([materialThickness, materialThickness]);
            translate([depth/2+materialThickness,0])circle(d = latchRingDiam);
            for(i = [0:2]){
                rotate((i+.25)*180/plankCount){
                    translate([depth/2-materialThickness,0]){
                        difference(){
                            square([materialThickness,maleJointWidth]);
                            if(i == 0){translate([materialThickness, maleJointWidth])rotate([0,0,120])square([materialThickness, maleJointWidth+10]);}
                            if(i == 2){translate([materialThickness,-maleJointWidth])rotate([0,0,60])square([materialThickness, maleJointWidth+10]);}
                        }
                    }
                       
                    }
                }
                difference(){
                    circle(d = depth+2*materialThickness);
                    circle(d = depth);
                    translate([-depth/2-materialThickness,-depth/2-materialThickness])
                    square([depth+2*materialThickness,depth/2+materialThickness]);
                    
                    rotate([0,0,-180+(3.5*plankCount)])
                    translate([-depth/2-materialThickness,-depth/2-materialThickness])
                    square([depth+2*materialThickness,depth/2+materialThickness]);
                    
                    }
            }
            translate([depth/2+materialThickness,0])color(color_1)circle(d = axisWidth);
        }
}
}
 
module latchRing(){
    difference(){
        circle(d = latchRingDiam);
        circle(d = axisWidth);
    }
}
 
module latchBase(){
    difference(){
        union(){
            square([latchHeight, latchProtrusion]);
            translate([-materialThickness,-materialThickness]) square([latchHeight+2*materialThickness,materialThickness]);
   
        translate([latchHeight/2, latchProtrusion])circle(d = latchHeight);
        }
        translate([latchHeight/2, latchProtrusion])circle(d = lockHoleDiam);
    }
}
 
module latchSide(){
    difference(){
        union(){
            circle(d = latchRingDiam);
            translate([latchHoleOffset+latchHeight+materialThickness,0]) circle(d = latchRingDiam);
            square([latchHoleOffset+latchHeight+materialThickness, materialThickness]);
        }
        circle(d = axisWidth);
        translate([latchHoleOffset+latchHeight+materialThickness,0]) circle(d = axisWidth);
    }
}
 
module hinge_lower(){
    difference(){
        union(){
            for(i = [0:2]){
                translate([materialThickness*2*i, 0]) square([maleJointWidth, materialThickness]);
            }
            translate([0,-materialThickness])square([materialThickness*7,materialThickness]);
            translate([materialThickness*7, -materialThickness]) circle(d = latchRingDiam);
        }
        translate([materialThickness*7, -materialThickness]) circle(d = axisWidth);
    }
}
 
module side(){
    difference(){
        union(){
            square([depth-2*materialThickness,height], center = true);
            translate([(depth-2*materialThickness-(footWidth-materialThickness-jointLength/2))/2,-height/2-footHeight/2]) {
                square([footWidth-materialThickness-jointLength/2, footHeight], center = true);
            }
            translate([-(depth-2*materialThickness-(footWidth-materialThickness-jointLength/2))/2,-height/2-footHeight/2]) {
                square([footWidth-materialThickness-jointLength/2, footHeight], center = true);
            }
            for(i = [0:jointCount_z]){
                translate([depth/2-materialThickness/2,2*i*jointLength-jointLength*jointCount_z])
                    square([materialThickness, jointLength], center = true);
                translate([-depth/2+materialThickness/2,2*i*jointLength-jointLength*jointCount_z])
                    square([materialThickness, jointLength], center = true);
            }
        }
        for(i = [0:jointCount_y]) {
            translate([2*i*jointLength-(jointLength*jointCount_y),-height/2+materialThickness/2])
                square([femaleJointLength, materialThickness], center = true);
        }
        translate([depth/2-footWidth/2+materialThickness/2,-height/2-footHeight/2]) {
            translate([-(footWidth-materialThickness-jointLength/2)/2,-footHeight/2])circle(r = footHeight);
        }
        translate([-(depth/2-footWidth/2+materialThickness/2)+(footWidth-materialThickness-jointLength/2),-height/2-footHeight/2]) {
            translate([-(footWidth-materialThickness-jointLength/2)/2,-footHeight/2])circle(r = footHeight);
        }
    }
}
 
module bottom(){
    square([width-2*materialThickness, depth-2*materialThickness], center = true);
    for(i = [0:jointCount_x]){
        translate([2*i*jointLength-(jointCount_x*jointLength),(depth-materialThickness)/2])
        square([maleJointLength, materialThickness], center = true);
        translate([2*i*jointLength-(jointCount_x*jointLength),-(depth-materialThickness)/2])
        square([maleJointLength, materialThickness], center = true);
    }
    for(i = [0:jointCount_y]){
        translate([(width-materialThickness)/2, 2*i*jointLength-(jointCount_y*jointLength)])
        square([materialThickness, maleJointLength], center = true);
        translate([(-width+materialThickness)/2, 2*i*jointLength-(jointCount_y*jointLength)])
        square([materialThickness, maleJointLength], center = true);
    }
}
 
module back(){
    difference(){
        union(){
            square([width, height], center = true);
        }
   
        translate([-jointCount_x*jointLength, -height/2+materialThickness/2])
        for(i = [0:jointCount_x]){
            translate([2*i*jointLength, 0])
                square([jointLength,materialThickness], center = true);
        }
        translate([width/2-materialThickness, -height/2+jointLength/2])
        for(i = [0:jointCount_z]){
            translate([0,2*i*jointLength])
                square([materialThickness, jointLength]);
        }
        translate([-width/2, -height/2+jointLength/2])
        for(i = [0:jointCount_z]){
            translate([0,2*i*jointLength])
                square([materialThickness, jointLength]);
        }
        for(i = [1:3]){
            translate([-plankLength/3+materialThickness, height/2-materialThickness*2*i])
                square([materialThickness, femaleJointWidth], center = true);
            translate([plankLength/3+materialThickness, height/2-materialThickness*2*i])
                square([materialThickness, femaleJointWidth], center = true);
            translate([-plankLength/3-materialThickness, height/2-materialThickness*2*i])
                square([materialThickness, femaleJointWidth], center = true);
            translate([plankLength/3-materialThickness, height/2-materialThickness*2*i])
                square([materialThickness, femaleJointWidth], center = true);
        }
    }
    difference(){
        union(){
            translate([width/2-(footWidth-materialThickness)/2,-height/2-footHeight/2])square([footWidth-materialThickness, footHeight], center = true);
            translate([-(width/2-(footWidth-materialThickness)/2),-height/2-footHeight/2])square([footWidth-materialThickness, footHeight], center = true);
        }
        translate([width/2-2*(footWidth-materialThickness)/2,-height/2-footHeight])circle(r = footHeight);
        translate([-(width/2-2*(footWidth-materialThickness)/2),-height/2-footHeight])circle(r = footHeight);
    }
}
 
module front(){
    difference(){
        union(){
            square([width, height], center = true);
        }
   
        translate([-jointCount_x*jointLength, -height/2+materialThickness/2])
        for(i = [0:jointCount_x]){
            translate([2*i*jointLength, 0])
                square([jointLength,materialThickness], center = true);
        }
        translate([width/2-materialThickness, -height/2+jointLength/2])
        for(i = [0:jointCount_z]){
            translate([0,2*i*jointLength])
                square([materialThickness, jointLength]);
        }
        translate([-width/2, -height/2+jointLength/2])
        for(i = [0:jointCount_z]){
            translate([0,2*i*jointLength])
                square([materialThickness, jointLength]);
        }
        translate([-materialThickness/2,height/2-latchHeight-latchHoleOffset]) square([materialThickness, latchHeight]);
    }
    difference(){
        union(){
            translate([width/2-(footWidth-materialThickness)/2,-height/2-footHeight/2])square([footWidth-materialThickness, footHeight], center = true);
            translate([-(width/2-(footWidth-materialThickness)/2),-height/2-footHeight/2])square([footWidth-materialThickness, footHeight], center = true);
        }
        translate([width/2-2*(footWidth-materialThickness)/2,-height/2-footHeight])circle(r = footHeight);
        translate([-(width/2-2*(footWidth-materialThickness)/2),-height/2-footHeight])circle(r = footHeight);
    }
}
 
module lidRim(){
    difference(){
        union(){
            circle(d = depth-materialThickness*2+1);
            for(i = [0:plankCount-1]){
            rotate((i+.25)*180/plankCount){
                translate([depth/2-materialThickness,0])
                    square([materialThickness,maleJointWidth]);
               
            }
        }
        }
        circle(d = .8*depth);
        translate([-depth/2,-depth])
            square([depth, depth]);
    }
}
 
module lidSide(){
    difference(){
        union(){
            circle(d = depth);
        }
        translate([-depth/2,-depth])
            square([depth, depth]);
        for(i = [0:plankCount-1]){
            rotate((i+.25)*180/plankCount){
                translate([depth/2-materialThickness,0])
                    square([materialThickness,femaleJointWidth]);
               
            }
        }
    }
}
 
module top(){
    for(i = [0:plankCount-1]){
        translate([0, (i)*(plankWidth+dist)]){
            if(i < 3)frontPlank();
            else if (i < plankCount-3) topPlank();
            else backPlank();
        }
    }
}
 
module backPlank(){
    difference(){
        union(){
            square([plankLength, plankWidth], center = true);
            translate([plankLength/2+materialThickness/2,0]) square([materialThickness, maleJointWidth], center = true);
            translate([-(plankLength/2+materialThickness/2),0]) square([materialThickness, maleJointWidth], center = true);
        }
        translate([-plankLength/4, 0]) square([materialThickness-2*cutWidth,femaleJointWidth], center = true);
        translate([plankLength/4, 0]) square([materialThickness-2*cutWidth,femaleJointWidth], center = true);
        translate([-plankLength/3, 0]) square([materialThickness, femaleJointWidth], center = true);
        translate([plankLength/3, 0]) square([materialThickness, femaleJointWidth], center = true);
    }
}
 
module frontPlank(){
    difference(){
        union(){
            square([plankLength, plankWidth], center = true);
            translate([plankLength/2+materialThickness/2,0]) square([materialThickness, maleJointWidth], center = true);
            translate([-(plankLength/2+materialThickness/2),0]) square([materialThickness, maleJointWidth], center = true);
        }
        square([materialThickness-2*cutWidth,femaleJointWidth], center = true);
        translate([-plankLength/4, 0]) square([materialThickness-2*cutWidth,femaleJointWidth], center = true);
        translate([plankLength/4, 0]) square([materialThickness-2*cutWidth,femaleJointWidth], center = true);
    }
}
 
module topPlank() {
    difference(){
        union(){
            square([plankLength, plankWidth], center = true);
            translate([plankLength/2+materialThickness/2,0]) square([materialThickness, maleJointWidth], center = true);
            translate([-(plankLength/2+materialThickness/2),0]) square([materialThickness, maleJointWidth], center = true);
        }
        translate([-plankLength/4, 0]) square([materialThickness-2*cutWidth,femaleJointWidth], center = true);
        translate([plankLength/4, 0]) square([materialThickness-2*cutWidth,femaleJointWidth], center = true);
    }
}