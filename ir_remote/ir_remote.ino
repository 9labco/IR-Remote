/*
 * IOS IR TV Remote
 * An IR LED must be connected to Arduino PWM pin 3.
 * Version 0.1 July, 2012
 * Copyright 2012 Joseph Cheng @ 9Lab
 * http://www.9lab.co
 *
 * IRremote library by https://github.com/shirriff/Arduino-IRremote
 * SoftModem library by http://arms22.googlecode.com/issues/attachment?aid=20004000&name=SoftModemPatched.zip&token=6REFM_K9gTcbesitPCPXY_8OdHI%3A1343234956312
 * ByteBuffer library by http://siggiorn.com/arduino-circular-byte-buffer/
 *
 * IRremote and SoftModem is also uses timer2 so i uncommented 61 line in IRremoteInt.h
 *
 */

#include <ByteBuffer.h>
#include <SoftModem.h>
#include <IRremote.h>

long cmd;
ByteBuffer buffer;
SoftModem modem;

IRsend irsend;

void setup()
{
  Serial.begin(9600);
  
  // Initialize the buffer with a capacity for 4 bytes
  buffer.init(4);
  
  delay(1000);
  modem.begin();
}

void loop() {

  while(modem.available()){
    int c = modem.read();
    if((buffer.getSize() == 4 || buffer.getSize() == 0) && c == 0xFF) {
      buffer.clear();
    } else {
      buffer.put(c);
    }
  }
  
  if(buffer.getSize() == 4) {
    long cmd = buffer.getLong();
    
    Serial.print("Sending cmd: ");
    Serial.println(cmd, HEX);
    
    irsend.sendNEC(cmd, 32); // NEC Protocol command
    delay(100);
  }
}
