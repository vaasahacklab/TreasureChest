// variables:
materialThickness = 4;
cutThickness = 0.1;

width = 100;
height = 100; // height without lid
depth = 100;

axisThickness = 2;

build = true;

// more variables (do not touch unless you know what you are doing):
plankCount = 16;
footWidth = 30;
jointLength = 10;
latchHeight = 15;

latchHoleOffset = 30;
lockHoleDiam = 8;


// constants (do not touch these unless you can defy reality):
PI = 3.1415926535897932384626433832795028841971693993751058209749230781640628620899864825;

// derived values (touching these not recommended):
plankLength = width - 2*materialThickness - 2*cutThickness;
echo("plankLength"); echo(plankLength);
plankWidth = PI*(((depth/2)-materialThickness)/plankCount)-2*cutThickness;
echo("plankWidth"); echo(plankWidth);
outerPlankWidth = PI*(((depth/2))/plankCount)-2*cutThickness;
echo("outerPlankWidth"); echo(outerPlankWidth);
maleJointWidth = materialThickness + 2*cutThickness;
echo("maleJointWidth"); echo(maleJointWidth);
femaleJointWidth = materialThickness;
echo("femaleJointWidth"); echo(femaleJointWidth);
maleJointLength = jointLength + 2*cutThickness;
echo("maleJointLength"); echo(maleJointLength);
femaleJointLength = jointLength - 2*cutThickness;
echo("femaleJointLength"); echo(femaleJointLength);
latchProtrusion = 3*materialThickness;
latchRingDiam = 2*materialThickness;
jointCount_x = (width-2*footWidth)/jointLength/2;
jointCount_y = (depth-2*footWidth)/jointLength/2;
jointCount_z = height/jointLength/2-1;


//CODE:

if(build){
    bottom();
    translate([0,depth+10]) rotate([0,0,180])back();
    translate([0,-(depth+10)]) front();
    translate([width+5,0]) rotate([0,0,90])side();
    translate([-width-5,0]) rotate([0,0,270])side();
    translate([0,depth+height-20]) top();
    translate([width/2+10,depth+10]) rotate([0,0,270]) lidSide();
    translate([-(width/2+10),depth+10]) rotate([0,0,90]) lidSide();
    translate([width/2+20+40,depth+10]) rotate([0,0,270]) lidRim();
    translate([-(width/2+20+40),depth+10]) rotate([0,0,90]) lidRim();
    translate([width*.5+10,-height*.5-10]) hingeLower();
    translate([width*.5+10,-height*.5-30]) hingeLower();
    translate([width*.5+10,-height*.5-50]) hingeLower();
    translate([width*.5+10,-height*.5-70]) hingeLower();
    translate([width*.5+10,-height*.5-100]) latchBase();
    translate([width*.5+50,-height*.5-20]) latchSide();
    translate([width*.5+50,-height*.5-35]) latchSide();
    translate([width*.5+50,-height*.5-55]) latchRing();
    
}

if(!build)
{
    side();
}

module latchRing(){
    difference(){
        union(){
            circle(d = latchRingDiam);
        }
        circle(d = axisThickness);
    }
}

module latchSide(){
    difference(){
        union(){
            circle(d = latchRingDiam);
            translate([latchRingDiam+latchHeight,0]) circle(d = latchRingDiam);
            square([latchRingDiam+latchHeight,latchRingDiam/2]);
        }
        circle(d = axisThickness);
        translate([latchRingDiam+latchHeight,0]) circle(d = axisThickness);
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

module hingeUpper(){ //TODO: finish
    difference(){
        union(){
            translate([outerPlankWidth/2-maleJointWidth/2,0])square([maleJointWidth, materialThickness]);
            translate([0,-materialThickness*1.5])square([outerPlankWidth, materialThickness*1.5]);
            
            translate([outerPlankWidth,0]){
                rotate([0,0,360/plankCount]) {
                translate([outerPlankWidth/2-maleJointWidth/2,0])square([maleJointWidth, materialThickness]);
            translate([0,-materialThickness*1.5])#square([outerPlankWidth, materialThickness*1.5]);
                    translate([outerPlankWidth,0]){
                rotate([0,0,360/plankCount]) {
                translate([outerPlankWidth/2-maleJointWidth/2,0])square([maleJointWidth, materialThickness]);
            translate([0,-materialThickness*1.5])#square([outerPlankWidth, materialThickness*1.5]);
                    
                }
                
            }
                }
                
            }
        }
    }
}

module hingeLower(){
    difference(){
        union(){
            for(i = [0:2]){
                translate([2*i*materialThickness,0]) square([maleJointWidth, materialThickness]);
            }
            translate([0,-materialThickness]) square([materialThickness*6, materialThickness]);
            translate([materialThickness*6,-materialThickness]) circle(d = latchRingDiam, center = true);
        }
    translate([materialThickness*6,-materialThickness]) circle(d = axisThickness, center = true);
    }
}

module bottom(){
    #square([width - 2*materialThickness, depth], center = true);
    for(i = [0:jointCount_y]){
        translate([-((width - 2*materialThickness)/2),-(depth/4+jointLength/2)])
            for(i = [0:jointCount_y]){
                translate([-maleJointWidth/2,2*i*jointLength+jointLength])
                    square([maleJointWidth, maleJointLength], center = true);
            }
       translate([((width - 2*materialThickness)/2),-(depth/4+jointLength/2)])
            for(i = [0:jointCount_y]){
                translate([maleJointWidth/2,2*i*jointLength+jointLength])
                    square([maleJointWidth, maleJointLength], center = true);
            }
    }
    translate([-jointCount_x*jointLength, height/2+maleJointWidth/2])
        for(i = [0:jointCount_x]){
            translate([2*i*jointLength,0])
                square([maleJointLength, maleJointWidth], center = true);
        }
    translate([-jointCount_x*jointLength, -(height/2+maleJointWidth/2)])
        for(i = [0:jointCount_x]){
            translate([2*i*jointLength,0])
                square([maleJointLength, maleJointWidth], center = true);
        }
}

module side(){
    difference(){
        union(){
            square([depth, height], center = true);
            translate([-(depth/2+maleJointWidth/2), -(height/jointLength/2)*jointLength])
                for(i = [0:jointCount_z]){
                    translate([0,2*i*jointLength+jointLength])
                        square([maleJointWidth, maleJointLength], center = true);
                }
            translate([(depth/2+maleJointWidth/2), -(height/jointLength/2)*jointLength])
                for(i = [0:jointCount_z]){
                    translate([0,2*i*jointLength+jointLength])
                        square([maleJointWidth, maleJointLength], center = true);
                }
            }
            translate([-height/3+femaleJointWidth/2, depth/2-femaleJointWidth/2])
            for(i = [0:jointCount_y]){
                translate([2*i*jointLength+jointLength,0])
                    #square([femaleJointLength, femaleJointWidth], center = true);
            }
            
    }
}

module back(){
    difference(){
        union(){
            square([width, height], center = true);
        }
        echo((width-2*footWidth)/jointLength/2);
        translate([-jointCount_x*jointLength, height/2-femaleJointWidth/2])
        for(i = [0:jointCount_x]){
            translate([2*i*jointLength,0])
                square([femaleJointLength, femaleJointWidth], center = true);
        }
        
        translate([width/2-femaleJointWidth/2, -(height/jointLength/2)*jointLength])
        for(i = [0:jointCount_z]){
            translate([0,2*i*jointLength+jointLength])
                square([femaleJointWidth, femaleJointLength], center = true);
        }
            
        translate([-(width/2-femaleJointWidth/2), -(height/jointLength/2)*jointLength])
        for(i = [0:jointCount_z]){
            translate([0,2*i*jointLength+jointLength])
                square([femaleJointWidth, femaleJointLength], center = true);
        }
        for(i = [1:3]){
            translate([-plankLength/3+materialThickness, -height/2+materialThickness*2*i])
                square([materialThickness, femaleJointWidth], center = true);
            translate([plankLength/3+materialThickness, -height/2+materialThickness*2*i])
                square([materialThickness, femaleJointWidth], center = true);
            translate([-plankLength/3-materialThickness, -height/2+materialThickness*2*i])
                square([materialThickness, femaleJointWidth], center = true);
            translate([plankLength/3-materialThickness, -height/2+materialThickness*2*i])
                square([materialThickness, femaleJointWidth], center = true);
        }
        
}
}

module front(){
    difference(){
        union(){
            square([width, height], center = true);
        }
        echo((width-2*footWidth)/jointLength/2);
        translate([-jointCount_x*jointLength, height/2-femaleJointWidth/2])
        for(i = [0:jointCount_x]){
            translate([2*i*jointLength,0])
                square([femaleJointLength, femaleJointWidth], center = true);
        }
        
        translate([width/2-femaleJointWidth/2, -(height/jointLength/2)*jointLength])
        for(i = [0:jointCount_z]){
            translate([0,2*i*jointLength+jointLength])
                square([femaleJointWidth, femaleJointLength], center = true);
        }
            
        translate([-(width/2-femaleJointWidth/2), -(height/jointLength/2)*jointLength])
        for(i = [0:jointCount_z]){
            translate([0,2*i*jointLength+jointLength])
                square([femaleJointWidth, femaleJointLength], center = true);
        }
        translate([0,-latchHoleOffset])
            square([femaleJointWidth, latchHeight - 2*cutThickness], center = true);
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
                translate([depth/2-femaleJointWidth,0])
                    square([femaleJointWidth,femaleJointWidth]);
                
            }
        }
    }
}

module top(){
    for(i = [0:plankCount-1]){
        if(i < 3) translate([0,(plankWidth+1)*i]) topPlank(true, false);
        else if (i < plankCount-3) translate([0,(plankWidth+1)*i]) topPlank(false, false);
        else translate([0,(plankWidth+1)*i]) topPlank(false, true);
    }
}

module topPlank(front, back){
    difference(){
        union(){
            square([plankLength, plankWidth], center = true);
            translate([-plankLength/2-maleJointWidth/2,0])
                square([maleJointWidth, maleJointWidth], center = true);
            translate([plankLength/2+maleJointWidth/2,0])
                square([maleJointWidth, maleJointWidth], center = true);
        }
        translate([-plankLength/4, 0])
            square([materialThickness, femaleJointWidth], center = true);
        translate([plankLength/4, 0])
            square([materialThickness, femaleJointWidth], center = true);
        if(front)
            square([materialThickness, femaleJointWidth], center = true);
        if(back){
            translate([-plankLength/3, 0])
                square([materialThickness, femaleJointWidth], center = true);
            translate([plankLength/3, 0])
                square([materialThickness, femaleJointWidth], center = true);
        }
    }
}