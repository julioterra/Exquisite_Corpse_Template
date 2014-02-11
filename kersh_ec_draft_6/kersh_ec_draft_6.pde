import spacebrew.*;

// Spacebrew stuff
String server = "sandbox.spacebrew.cc";
String name   = "ExquisiteCorpse_YOUR_NAME_HERE!";
String desc   = "Some stuff";

Spacebrew sb;

// App Size: you should decide on a width and height
// for your group
int appWidth  = 1280;
int appHeight = 720;

// EC stuff
int corpseStarted   = 0;
boolean bDrawing    =false;
boolean bNeedToClear = false;

//-----------Kersh Var -----------------------------------//
float x_kersh=width*0.66;       // variable for the x position of the ellipse
float xInc_kersh=6;    //  this is how much we will move the x pos
float y_kersh=0; // varible for the y position of the second ellipse 
float yInc_kersh=6; // increase / move the y pos 
float angle_kersh; // angle of rectangle 
float deltaAngle_kersh; // main angle of rectangle 
float x2_kersh= width*0.66; // x for rectangle
float y2_kersh; // y for rectangle 
color c_kersh; //might use this later for color 
PVector kershVel;
//-----------Kersh Var Done -----------------------------------//

void setup(){
  size( appWidth, appHeight );
 
  
  sb = new Spacebrew(this);
  sb.addPublish("doneExquisite", "boolean", false);
  sb.addSubscribe("startExquisite", "boolean");
  
  // add any of your own subscribers here!
  
  sb.connect( server, name, desc );
  
  //-----------Kersh Setup-----------------------------------//
  //initilise the x pos to be the middle of the screen
  x_kersh= width*0.66;
  //initilize the y pos to be the middle of the screen 
  y_kersh= height; 
  kershVel= new PVector(5,1);
  //for the rectangle turns 
  y2_kersh = random(height); 
  x2_kersh = 428;
  angle_kersh =0; // setting up value of angle varible 
  deltaAngle_kersh =0.05; // delta angle 
  c_kersh = color (255); // color of rec so it will change 
  smooth(); //Draws all geometry with smooth (anti-aliased) edges
   
  //redraw the background black
  //background(0);
  //-----------Kersh Setup Done -----------------------------------//
}

void draw(){
  // this will make it only render to screen when in EC draw mode
  //if (!bDrawing) return;
  
  // blank out your background once
  if ( bNeedToClear ){
    bNeedToClear = false;
    background(0); // feel free to change the background color
  }
  
  // ---- start person 1 ---- //
  if ( millis() - corpseStarted < 10000 ){
    noFill();
    stroke(255);
    rect(0,0, width / 3.0, height );
    fill(255);
  
  // ---- start person 2 ---- //
  } else if ( millis() - corpseStarted < 20000 ){
    noFill();
    stroke(255);
    rect(width / 3.0,0, width / 3.0, height );
    fill(255);
    
   //-----------Kersh Draw -----------------------------------// 
     //draw rectangle 
 // fill(244,30); 
  //rect(width/2, height/2, width, height); 
  c_kersh = color(255,map(mouseY,0,height,0,255),0); // don't understand the map and last 0 
  fill (c_kersh); // fill the rect with the color from above; 
  
  //mouse pressed interaction of the rec
  if(mousePressed){
    x2_kersh = mouseX; 
    deltaAngle_kersh=deltaAngle_kersh*0.7; // angle chnages by multipying 0.7
  }
  
//  if (x2_kersh< 426 || x2_kersh > width*.66){
//    x2_kersh++; // else the x2 adds by 1 
//    angle_kersh+=1;// deltaAngle_kersh; 
//  }


    y2_kersh+= kershVel.y; // else y1 of rect is random 
    x2_kersh+=kershVel.x; // x1 position is minus curent witdh times .25 or 25% this give backwards spin 
    angle_kersh+=1;
    deltaAngle_kersh= random(-426.1,800.1); //deltaAngle changes as well 
    
    if(x2_kersh>=width*.66 || x2_kersh<=width*.33){
      kershVel.x*=-1;
    }
      

pushMatrix(); 
translate(x2_kersh,y2_kersh); 
rotate (angle_kersh); 
float size = map(mouseX,0,width*.66,0.5,1); 
rect (0,0,width*0.1*size,height*0.1*size); 
popMatrix(); 
   
  //draw the ellipses'
  //ellipse 1 
  ellipse(x_kersh,height/2,20,20);
  //ellipse 2 
  ellipse(width/2, y_kersh, 40,40); 
   
  //add 2 to the x position of the ellipse
  x_kersh+=xInc_kersh;
  
  // add 2 to the y position of the ellipse 
   
  y_kersh+=yInc_kersh; 
  
  //if the possition is greater than width (so centre of ellipse at edge of screen)
  // || or
  //the x pos is on the right edge of the window
  if(x_kersh > width*.66 || x_kersh < 426){
    //flip the sign of the amount we move
    // if its +ve it moves to the right
    // if its -ve it moves to the left
    xInc_kersh= xInc_kersh *(-1);
  }
  
  if (y_kersh> height || y_kersh < 0){
    //flip the sign of the amount we move 
    yInc_kersh= yInc_kersh*(-1); 
  }
    
  // ---- start person 3 ---- //
  } else if ( millis() - corpseStarted < 30000 ){
    noFill();
    stroke(255);
    rect(width * 2.0/ 3.0,0, width / 3.0, height );
    fill(255);
  
  // ---- we're done! ---- //
  } else {
    sb.send( "doneExquisite", true );
    bDrawing = false;
  }
}

void mousePressed(){
  // for debugging, comment this out!
  sb.send( "doneExquisite", true );
}

void onBooleanMessage( String name, boolean value ){
  if ( name.equals("startExquisite") ){
    // start the exquisite corpse process!
    bDrawing = true;
    corpseStarted = millis();
    bNeedToClear = true;
  }
}

void onRangeMessage( String name, int value ){
}

void onStringMessage( String name, String value ){
}
