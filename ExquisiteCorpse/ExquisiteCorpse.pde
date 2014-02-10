import spacebrew.*;


// Spacebrew stuff
String server = "sandbox.spacebrew.cc";
String name   = "ExquisiteCorpse_Salome";
String desc   = "Some stuff";

Spacebrew sb;

// App Size: you should decide on a width and height
// for your group
int appWidth  = 1280;
int appHeight = 720;

// EC stuff
int corpseStarted   = 0;
boolean bDrawing    = false;
boolean bNeedToClear = false;

//Person 1
PImage odbHead;
PImage odbNeck;
PImage bigEyes;
PImage grill;
PImage sliderBatLocal;
PImage sliderBatRemote;
PFont sliderTitle;
int headPos;
int headbop;
float grillTint;
int local_slider_val = 0;
int remote_slider_val = 0;
int numberOfBats = 10;
float[]batsX = new float[numberOfBats];
float[]batsY = new float[numberOfBats];
float[]batsVel = new float[numberOfBats];

void setup() {
  size( appWidth, appHeight );
  frameRate(24);

  sb = new Spacebrew(this);
  sb.addPublish("doneExquisite", "boolean", false);
  sb.addSubscribe("startExquisite", "boolean");

  // add any of your own subscribers here!
  sb.addSubscribe("ExquisiteCorpse_Kristen", "boolean");

  sb.connect( server, name, desc );

  //Person 1
  odbNeck = loadImage("odbNeck.png");
  bigEyes = loadImage("bigEyes.png");
  sliderBatLocal = loadImage("wutangbatLocal.png");
  sliderBatRemote = loadImage("wutangbatRemote.png");
  sliderTitle = loadFont("HelveticaNeue-Italic-20.vlw");
  headPos = 0;
  headbop = 1;
  sb.addPublish( "local_slider", "range", local_slider_val ); 
  sb.addSubscribe( "remote_slider", "range" );
  for (int i=0; i<numberOfBats; i++) {
    batsX[i]=40*(i);
    batsY[i]=10;
    batsVel[i] = random(0.5, 5);
  }
}


void draw() {
  // this will make it only render to screen when in EC draw mode
  if (!bDrawing) return;

  // blank out your background once
  //if ( bNeedToClear ) {
  //bNeedToClear = false;
  background(255); // feel free to change the background color!
  //}

  // ---- start person 1 ---- //
  if ( millis() - corpseStarted < 10000 ) {
    noFill();
    stroke(255);
    rect(0, 0, width / 3.0, height );
    fill(255);
    textFont(sliderTitle);
    odbHead = loadImage("odbHead.png");
    grill = loadImage("grill.png");

    //    numberOfBats = int(map(local_slider_val, 0, 420, 0, 10));
    //    println(numberOfBats);

    noTint();
    image(odbNeck, 0, 0);
    image(odbHead, 0, headPos);

    // slider controls grill
    tint(214, 176, 60, grillTint);
    image(grill, 0, headPos);
    grillTint = map(int(local_slider_val), 0, 420, 0, 255);

    //head bop
    headPos= headPos+headbop; 

    //contain head bop
    if (headPos<= 0 || headPos>=20) {
      headbop= -1*headbop;
    }

    //eyes
    if (headPos>=10 && headPos<=13) {
      noTint();
      image(bigEyes, 0, headPos);
    }

    // Black box containing slider
    fill(0);
    rect(0, height-50, width/3, 50);
    //remote slider
    noTint();
    image(sliderBatRemote, remote_slider_val, height-50); 
    //local slider
    noTint();
    image(sliderBatLocal, local_slider_val, height-50);
    //text
    text("Slide the Wu", 5, height-60);

    //control Bat movements
    for (int i=0; i<numberOfBats; i++) {
      tint(214, 176, 60, grillTint);
      image(sliderBatLocal, batsX[i], batsY[i], 50, 50);  
      batsY[i]=batsY[i]+batsVel[i];
      batsX[i]=batsX[i]+batsVel[i];
      if (batsY[i]>= height-80 || batsY[i]<=5 || batsX[i]<=0 || batsX[i]>= (width/3) -50) {
        batsVel[i]= batsVel[i]*(-1);
      }
    }

    // ---- start person 2 ---- //
  } 
  else if ( millis() - corpseStarted < 20000 ) {
    noFill();
    stroke(255);
    rect(width / 3.0, 0, width / 3.0, height );
    fill(255);

    // ---- start person 3 ---- //
  } 
  else if ( millis() - corpseStarted < 30000 ) {
    noFill();
    stroke(255);
    rect(width * 2.0/ 3.0, 0, width / 3.0, height );
    fill(255);

    // ---- we're done! ---- //
  } 
  else {
    sb.send( "doneExquisite", true );
    bDrawing = false;
  }
}

void mousePressed() {
  // for debugging, comment this out!
  sb.send( "doneExquisite", true );
}

void onBooleanMessage( String name, boolean value ) {
  if ( name.equals("startExquisite") ) {
    // start the exquisite corpse process!
    bDrawing = true;
    corpseStarted = millis();
    bNeedToClear = true;
  }
}

void mouseDragged() {
  // Leaving 20 pixels at the end prevents the slider from going off the screen
  if (mouseX >= 0 && mouseX <= width/3) {
    local_slider_val = mouseX;
    sb.send("local_slider", local_slider_val);
  }
}

void onRangeMessage( String name, int value ) {
  println("got range message " + name + " : " + value);
  remote_slider_val = value;
}

void onStringMessage( String name, String value ) {
}

