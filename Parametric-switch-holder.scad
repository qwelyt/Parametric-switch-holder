/*[Station]*/
rows=3;
columns=3;
caseThickness=9;

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
space=19.04;
cutXSize=14;
cutYSize=15;
notchX=4;
notchY=0.50;
showSwitch=false;
plateLength=space*1.089;

function legZ(thickness,legHeight) = -(thickness*0.5+legHeight*0.5);

module cherrySwitch(){
	// Awesome Cherry MX model created by gcb
	// Lib: Cherry MX switch - reference
	// Download here: https://www.thingiverse.com/thing:421524
	//  p=cherrySize/2+0.53;
	translate([0,0,13.2])
		import("switch_mx.stl");
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

module KeyCut(thickness,x,y,notchX,notchY){
  union(){
    difference(){
      cube([x,y,thickness+2],center=true);
      
      translate([0,y/2,0])
      cube([notchX,notchY,thickness+3],center=true);
      
      translate([0,-y/2,0])
      cube([notchX,notchY,thickness+3],center=true);
    }
  }
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

module plate(rows, cols, thickness,space,cutX,cutY,notchX,notchY){
   union(){
    for(r=[0:rows-1]){
      for(c=[0:cols-1]){
        translate([space*r, space*c,0]){
          difference(){
            KeyPlate();
            KeyCut(thickness,cutX,cutY,notchX,notchY);
          }
          if(showSwitch){
            #translate([0,0,thickness/2])cherrySwitch();
          }
          
          
        }
      }
    }
  }
}

module build(rows, cols, thickness,space,cutX,cutY,notchX,notchY){
  union(){
    if(puzzle){
      difference(){
        plate(rows,cols,thickness,space,cutX,cutY,notchX,notchY);
        if(backPuzzle){
          translate([0,-space*0.39,0])puzzleCut(thickness+2,false);
          
          translate([space*(rows-1),-space*0.39,0])puzzleCut(thickness+2,false);
        }
    
        if(rightPuzzle){
          translate([-space*0.346,0,0])rotate([0,0,-90])puzzleCut(thickness+2,false);
          
          translate([-space*0.346,space*(cols-1),0])rotate([0,0,-90])puzzleCut(thickness+2,false);
        }
      }
      
      if(frontPuzzle){
        translate([0,space*cols-space*0.3,0])puzzleCut(thickness,true);
        
        translate([space*(rows-1),space*cols-space*0.3,0])puzzleCut(thickness,true);
      }
      
      if(leftPuzzle){
        translate([space*rows-space*0.35,0,0])rotate([0,0,-90])puzzleCut(thickness,true);
        
        translate([space*rows-space*0.35,space*(cols-1),0])rotate([0,0,-90])puzzleCut(thickness,true);
      }
      
    } else {
      plate(rows,cols,thickness,space,cutX,cutY,notchX,notchY);
    }
 
    if(legs){
      legs(thickness,rows-1,cols-1,0,0);
    }
  }
}

build(rows, columns, caseThickness, space,cutXSize,cutYSize,notchX,notchY*2);

//puzzleCut(caseThickness,true);