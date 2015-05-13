import hypermedia.net.*;
import java.awt.*;
import java.awt.event.*;

Robot robo;
UDP udp; 

float x, y;
int rectX, rectY;
char keyboard;
String keyInput;

void setup() {
  size(1280,800);
     try {
       robo = new Robot();
     } catch (AWTException e) {
     }

  udp = new UDP( this, 6666);//, "149.31.194.25" );
 // udp.log( true );     // <-- printout the connection activity
  udp.listen( true );
  
  rectX = width/2;
  rectY = height/2;
  
  keyInput = " ";
  
}

//process events
void draw() {
  background(100);
  ellipse (x, y, 10,10);
  rect(rectX, rectY, 100, 100);
  text(keyInput, 0, 0);
  influence();
  
  
  //influence(110);
}

void influence(){ //mouse movement
  
  if (x!=0 && y!=0)
    //robo.mouseMove((int)x,(int)y);

  println("influence mouseX = " + x + "   mouseY = " + y);
}
void influence(int pressThis){
  
 if (pressThis > 96 && pressThis < 123) 
   pressThis = pressThis - 32;
  robo.keyPress(pressThis);
  robo.keyRelease(pressThis);
  println("influence = " + pressThis);
}
void influence(String pressThis){
  
  /*
  if (x!=0 && y!=0)
  if (frameCount % 100 == 0)robo.mouseMove((int)x,(int)y);
*/
  if (pressThis.equals("mLEFT")){
    
    robo.mousePress(InputEvent.BUTTON1_DOWN_MASK);
    
    robo.mouseRelease(InputEvent.BUTTON1_MASK);
  }
  if (pressThis.equals("mRIGHT")){
    
    robo.mousePress(InputEvent.BUTTON2_MASK);
    robo.delay(100);
    robo.mouseRelease(InputEvent.BUTTON2_MASK);
  }

  if (pressThis.equals("LEFT")){
    robo.keyPress(LEFT);
    robo.keyRelease(LEFT);
    rectX--; 
  }
  if (pressThis.equals("RIGHT")){
    robo.keyPress(RIGHT);
    robo.keyRelease(RIGHT);
    rectX++; 
  }
  if (pressThis.equals("UP")){
    robo.keyPress(UP);
    robo.keyRelease(UP);
    rectY++; 
  }
  if (pressThis.equals("DOWN")){
    robo.keyPress(DOWN);
    robo.keyRelease(DOWN);
    rectY++; 
  }
  
  println("influence = " + pressThis);
}

void receive( byte[] data, String ip, int port ) {  // <-- extended handler
  
  
  int sep = processRaw(data);
  
  String type = new String(subset(data,0,sep)); 
  //println("sep = " + sep + "  length = " + data.length);
 // data = );
 //println("type = " + type);
  String message = new String(subset(data, sep+1, data.length-sep-1));
  
  //println( "receive type: " + type + " - message: " + message);
  
  if (type.equals("mouseX")){
    float dataF = float(message) / 100;
    x = dataF * width;
  } else if (type.equals("mouseY")){
      
    float dataF = float(message) / 100;
    y = dataF * height;
  } else if (type.equals("dir")){
     influence(message);
    
    
  } else if (type.equals("mouseClick")){
    influence(message);
  
} else if(type.equals("key")){
    
    influence((int)data[data.length-1]);
  }
  
  //println("received from ip : " + ip);
}

int processRaw(byte[] dataA){
  
  for (int i = 0; i <= dataA.length; i++){
    if (dataA[i] == ':'){
      
      return i;
    }
  }
  return 0;
}

void keyPressed(){
  keyInput+= key;
  println("key input = " + keyInput);
  
}
