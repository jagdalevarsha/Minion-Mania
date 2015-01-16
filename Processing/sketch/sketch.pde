import gifAnimation.*;
import codeanticode.syphon.*;
import processing.serial.*;

PGraphics canvas;
SyphonServer server;

float x;
float y;
int k=1;
int l=1;
int m=1;
int n=1;
int o=1;

float beginX;
float speed;
float angle;
float xSpeed;
float ySpeed;
float accel = -.85;

PImage bg;
PImage rope;
PImage raft;

Gif minionWalk;
Gif Teleport;
Gif Appear;

Serial myPort;  // Create object from Serial class
String arduinoData = "";     // Data received from the serial port
String splitSensorData[];

boolean isSensorOneActivated = false;
boolean isSensorTwoActivated = false;
boolean isSensorThreeActivated = false;

boolean showMinionLift = true;
boolean showMinionBridge = false;
boolean showMinionJump = false;

boolean showRaft = false;
boolean transition1 = true;
boolean transition2 = true;

void setup() 
{
  size(1178, 800, P3D);

  /*Declare Serial port to read values passed from Arduino **/

  String portName = Serial.list()[2]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 9600);

  x=700;
  y=694; 

  angle = 70;
  speed = 20;
  xSpeed = 0.4*speed * cos(radians(angle));
  ySpeed = 0.808*speed * sin(radians(angle));


  bg = loadImage("combine.jpg");
  raft = loadImage("raft.png");
  rope = loadImage("rope.png");
  minionWalk= new Gif(this, "walk.gif");
  minionWalk.loop();
  Teleport=new Gif(this, "teleport.gif");
  Teleport.loop();
  Appear=new Gif(this, "appear.gif");
  Appear.loop();

  canvas = createGraphics(1178, 800, P3D);

  // Create syhpon server to send frames out.
  server = new SyphonServer(this, "Processing Syphon");
}

void draw() 
{
  canvas.smooth();
  canvas.noStroke();
  canvas.beginDraw();

  canvas.background(bg);
  canvas.fill(0, 2);
  canvas.rect(0, 0, width, height);

  arduinoData = "";

  if (showMinionLift)  
    canvas.image(minionWalk, 70, 100, 60, 70);

  if (showMinionBridge)  
    canvas.image(minionWalk, 670, 150, 60, 70);

  if (showMinionJump)
    canvas.image(minionWalk, 700, 694, 60, 70);

  /**Read Data from Arduino starts **/

  if ( myPort.available() > 0) 
  {  
    // If data is available,
    arduinoData = myPort.readStringUntil('\n');         // read it and store it in val
    //arduinoData = arduinoData.trim();
    myPort.clear();
  } 

  print(arduinoData); //print it out in the console

  if (arduinoData != null)
  {
    //Splitting data based on the space
    splitSensorData = split(arduinoData, ',');

    if (splitSensorData.length==4)
    {

      println("Size of the array is"+splitSensorData.length);

      if (splitSensorData[0] != null && splitSensorData[0].equals("1") && !isSensorOneActivated)
      {
        println(splitSensorData[0]+"");
        println("Sensor 1 activated");
        isSensorOneActivated = true;
      }

      if (splitSensorData[1] != null && splitSensorData[1].equals("1") && !isSensorTwoActivated)
      {
        println(splitSensorData[1]+"");
        println("Sensor 2 activated");
        isSensorTwoActivated = true;
      }


      //println(splitSensorData[2]+"");
      // println(splitSensorData[2].equals("1"));

      if (splitSensorData[2] != null && splitSensorData[2].equals("1") && !isSensorThreeActivated)
      {
        println(splitSensorData[2]+"");
        println("Sensor 3 activated");
        isSensorThreeActivated = true;
      }

      println();
    }
  }

  if(isSensorOneActivated)
  {
    showMinionLift = false;
    lift();
  }  
  if (showRaft)
  {
    canvas.image(rope, 293, 65, 8, 23+510);
    canvas.image(raft, 226, 80+510, 140, 140);
  }

  if (transition1) 
  {
   if (n<50) {
     canvas.image(Appear, 640, 50, 100, 240);
     n++;
   } else {
     
     //idling
   }
 }   
 
 if (transition2) {
   if (o<50) {
     canvas.image(Appear, 670, 594, 100, 240);
     o++;
   } else {
     
     //idling
   }
 }
   
  if (showMinionBridge)
  {
    showMinionBridge = false;
    transition1 = false;
    bridge();
  }

  if(isSensorThreeActivated)
  {
    showMinionJump = false;
    jump();
  }   
  canvas.endDraw();
  image(canvas, 0, 0);
  server.sendImage(canvas);
}

void bridge()
{
  if (m<400) 
  {
    canvas.image(minionWalk, 670+m, 150, 60, 70);
    m=m+1;
  } else
  {
    isSensorTwoActivated = false;
    showMinionJump =true;
  }
}

void lift()
{
  //  image(rope, 293,65,8,23);
  //  image(raft, 226,80,140,140);
  if (l<200) {
    canvas.image(minionWalk, 70+l, 100, 60, 70);
    l=l+2;
    canvas.image(rope, 293, 65, 8, 23);
    canvas.image(raft, 226, 80, 140, 140);
  } else if ((l>=200) && (l<710)) {
    canvas.image(rope, 293, 65, 8, 23+l-200);
    canvas.image(raft, 226, 80+l-200, 140, 140);
    canvas.image(minionWalk, 265, 100+l-200, 60, 70);
    l=l+3;
  } else if ((l>=710)&&(l<910))
  {
    canvas.image(rope, 293, 65, 8, 23+510);
    canvas.image(raft, 226, 80+510, 140, 140);
    canvas.image(minionWalk, 265+l-710, 640, 60, 70);
    l=l+2;
  } else 
  {

    if (l<960)
    {
      canvas.image(minionWalk, 265+910-710, 640, 60, 70);
      canvas.image(Teleport, 470, 530, 100, 240);
      canvas.image(rope, 293, 65, 8, 23+510);
      canvas.image(raft, 226, 80+510, 140, 140);
    }
    l=l+3;
    if (l>=960)
    {
      isSensorOneActivated = false; 
      showRaft = true;
      showMinionBridge = true;
      transition1= true;
    }
  }
}

void jump() 
{
  if (k<120) 
  {   
    x += xSpeed;
    // double assignment creates y acceleration
    ySpeed += accel;
    y -= ySpeed;    
    canvas.image(minionWalk, x, y, 60, 70);
    k++;

    if ((k%30)==0) 
    {
      delay(300);
      ySpeed = 0.808*speed * sin(radians(angle));
    }
  } else 
  {
    canvas.image(minionWalk, 1022, 433, 60, 70);
    isSensorThreeActivated = false;
  }
}

void delay(int delay)
{
  int time = millis();
  while (millis () - time <= delay);
}


void drawGrid() { 
  stroke(255);
  strokeWeight (1);
  noFill();
  beginShape();
  noFill();
  // verticle lines

  // horizontal lines
  for (int i=1; i<8; i++) {
    line(0, i*100, 1178, i*100);
  }
  for (int j=1; j<12; j++) {
    line(j*100, 0, j*100, 800);
  }
  endShape();
}
