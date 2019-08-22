/*[Station]*/
rows=3;
columns=3;
caseThickness=9;


/*[Danger zone]*/
space=19.04;
cutXSize=15;
cutYSize=15;
notchX=4;
notchY=0.75;
showSwitch=false;

module cherrySwitch(){
	// Awesome Cherry MX model created by gcb
	// Lib: Cherry MX switch - reference
	// Download here: https://www.thingiverse.com/thing:421524
	//  p=cherrySize/2+0.53;
	translate([0,0,13.2])
		import("switch_mx.stl");
}

module KeyPlate(w=space,l=space*1.089,h=caseThickness,center=true){
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


module build(rows, cols, thickness,space,cutX,cutY,notchX,notchY){
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

build(rows, columns, caseThickness, space,cutXSize,cutYSize,notchX,notchY*2);