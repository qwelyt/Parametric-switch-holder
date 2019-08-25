/*[Station]*/
rows=3;
columns=3;
// Could be made thinner but then you should add legs. Make sure the total height/thickness is 9 or more or else the switches will touch the ground.
caseThickness=9;
switch="MX"; // ["MX","ALPS"]
showSwitch=false;

/*[Legs]*/
legs=false;
legWidth=3;
legLength=3;
legHeight=6;

/*[Puzzle]*/
puzzle=false;
leftPuzzle=true;
rightPuzzle=true;
frontPuzzle=true;
backPuzzle=true;



/*[Danger zone]*/
// Measured from key cap center to key cap center
space=19.04;
plateLength=space*1.089;

/*[MX settings]*/
MX_cutXSize=14;
MX_cutYSize=15;
MX_notchX=4;
MX_notchY=0.50;

/*[ALPS settings]*/
ALPS_cutXSize=12.8;
ALPS_cutYSize=16.0;

function legZ(thickness,legHeight) = -(thickness*0.5+legHeight*0.5);

module MXSwitch(){
	// Awesome Cherry MX model created by gcb
	// Lib: Cherry MX switch - reference
	// Download here: https://www.thingiverse.com/thing:421524
	//  p=cherrySize/2+0.53;
	translate([0,0,13.2])
  rotate([0,0,-90])
		import("switch_mx.stl");
}

module ALPSSwitch(){
  // ALPS model created by qwelyt (me)
  // Lib: ALPS switch - reference
  // Download here: https://www.thingiverse.com/thing:3829342
  translate([0,0,-2])
  rotate([0,0,0])
  import("ALPS-switch.stl");
}

module leg(){
  cube([legWidth,legLength,legHeight],center=true);
}


module legs(thickness,rows,cols, row, col){
  x=(space*0.5-legWidth*0.5);
  y=(plateLength*0.5-legLength*0.5);
  z=legZ(thickness,legHeight);
  
  translate([0,0,0])translate([-x,-y,z])leg();
  translate([space*rows,0,0])translate([x,-y,z])leg();
  translate([0,space*cols,0])translate([-x,y,z])leg();
  translate([space*rows,space*cols,0])translate([x,y,z])leg();
  
}

module KeyPlate(w=space,l=plateLength,h=caseThickness,center=true){
	cube([w,l,h],center=center);
}

module MXCut(thickness,x,y,MX_notchX,MX_notchY){
  union(){
    difference(){
      cube([x,y,thickness+2],center=true);
      
      translate([0,y/2,0])
      cube([MX_notchX,MX_notchY,thickness+3],center=true);
      
      translate([0,-y/2,0])
      cube([MX_notchX,MX_notchY,thickness+3],center=true);
    }
  }
}

module ALPSCut(thickness){
  cube([ALPS_cutXSize,ALPS_cutYSize,thickness+2],center=true);
}

module puzzleCut(thickness,hook){
  size = hook ? 9 : 10;
  move = hook ? 1 : 0;
  difference(){
    translate([0,0,0])rotate([0,0,45])cube([size,size,thickness],center=true);
    
    translate([0,size*0.4,0])cube([size*2,size,thickness+2],center=true);
    
    translate([0,-((size*0.8)+move),0])cube([size*2,size,thickness+2],center=true);
  }
}

module plate(){
   union(){
    for(r=[0:rows-1]){
      for(c=[0:columns-1]){
        translate([space*r, space*c,0]){
          difference(){
            KeyPlate();
            if(switch == "MX"){
              MXCut(caseThickness,MX_cutXSize,MX_cutYSize,MX_notchX,MX_notchY*2);
            } else if(switch == "ALPS"){
              ALPSCut(caseThickness);
            } else {
              cube([space*0.8,space*0.8,caseThickness+2],center=true);
            }
          }
          if(showSwitch){
            if(switch == "MX"){
              #translate([0,0,caseThickness/2])MXSwitch();
            } else if(switch == "ALPS"){
              #translate([0,0,caseThickness/2])ALPSSwitch();
            } else {
              #translate([0,0,caseThickness/2])
              cube([space*0.8,space*0.8,caseThickness+2],center=true);
            }
          }
          
          
        }
      }
    }
  }
}

module build(){
  union(){
    if(puzzle){
      difference(){
        plate();
        if(backPuzzle){
          translate([0,-space*0.39,0])puzzleCut(caseThickness+2,false);
          
          translate([space*(rows-1),-space*0.39,0])puzzleCut(caseThickness+2,false);
        }
    
        if(rightPuzzle){
          translate([-space*0.346,0,0])rotate([0,0,-90])puzzleCut(caseThickness+2,false);
          
          translate([-space*0.346,space*(cols-1),0])rotate([0,0,-90])puzzleCut(caseThickness+2,false);
        }
      }
      
      if(frontPuzzle){
        translate([0,space*cols-space*0.3,0])puzzleCut(caseThickness,true);
        
        translate([space*(rows-1),space*cols-space*0.3,0])puzzleCut(caseThickness,true);
      }
      
      if(leftPuzzle){
        translate([space*rows-space*0.35,0,0])rotate([0,0,-90])puzzleCut(caseThickness,true);
        
        translate([space*rows-space*0.35,space*(cols-1),0])rotate([0,0,-90])puzzleCut(caseThickness,true);
      }
      
    } else {
      plate();
    }
 
    if(legs){
      legs(caseThickness,rows-1,cols-1,0,0);
    }
  }
}

build();
