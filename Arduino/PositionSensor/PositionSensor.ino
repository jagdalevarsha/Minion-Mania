//Design of Interactive Environments
//Positioning using Magnetic sensors

//Connections
//Arduino Reed sensor

const int reedSensorOneInputPin = 12;
const int ledOneOutputPin = 13;

const int reedSensorTwoInputPin = 7;
const int ledTwoOutputPin = 8;

const int reedSensorThreeInputPin = 2;
const int ledThreeOutputPin = 4;

int reedSensorOneState = 0;
int reedSensorTwoState = 0;
int reedSensorThreeState = 0; 

String strToProcessing = "";

void setup()
{
  //Initialise the Led Pin as output  
  pinMode(ledOneOutputPin, OUTPUT);
  pinMode(ledTwoOutputPin, OUTPUT);
  pinMode(ledThreeOutputPin, OUTPUT);
    
  //Initialise the Reed Sensor One pin as input  
  pinMode(reedSensorOneInputPin, INPUT);
  pinMode(reedSensorTwoInputPin, INPUT);
  pinMode(reedSensorThreeInputPin, INPUT);
  
  //Establish serial communication
  Serial.begin(9600); 
}

void loop()
{
  strToProcessing = "";
  
  //Read the state of the hall sensor  
  reedSensorOneState = digitalRead(reedSensorOneInputPin);
  
  //Read the state of the hall sensor  
  reedSensorTwoState = digitalRead(reedSensorTwoInputPin);
  
  //Read the state of the hall sensor  
  reedSensorThreeState = digitalRead(reedSensorThreeInputPin);  
  
  //Print distance of magnet from sensor 1
  if(reedSensorOneState == LOW)
    digitalWrite(ledOneOutputPin, LOW);
  
  else
    digitalWrite(ledOneOutputPin, HIGH);
  
  strToProcessing = strToProcessing + reedSensorOneState;

  //Print distance of magnet from sensor 2 
  if(reedSensorTwoState == LOW)
    digitalWrite(ledTwoOutputPin, LOW);
  
  else
    digitalWrite(ledTwoOutputPin, HIGH);
  
  strToProcessing = strToProcessing+"," + reedSensorTwoState;
  
  //Print distance of magnet from sensor 3 
  if(reedSensorThreeState == LOW)
    digitalWrite(ledThreeOutputPin, LOW); 
  else
    digitalWrite(ledThreeOutputPin, HIGH);

  strToProcessing = strToProcessing+","+ reedSensorThreeState+",1";

  Serial.println(strToProcessing);
  
  delay(1000);
}
