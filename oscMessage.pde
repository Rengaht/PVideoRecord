
void initOsc(){
   oscP5 = new OscP5(this,Osc_Port_Num);
}

//void oscEvent(OscMessage _message) {
  
//  if(_message.checkAddrPattern("/test")==true) {
//    if(_message.checkTypetag("ifs")) {    
//      int firstValue = _message.get(0).intValue();  
//      float secondValue = _message.get(1).floatValue();
//      String thirdValue = _message.get(2).stringValue();
//      print("### received an osc message /test with typetag ifs.");
//      println(" values: "+firstValue+", "+secondValue+", "+thirdValue);
//      return;
//    }  
//  } 
//  println("### received an osc message. with address pattern "+_message.addrPattern());
//}

void sendMessage(NetAddress loc_,int data){
   OscMessage message_=new OscMessage("/go");
   message_.add(data);
   oscP5.send(message_,loc_);
}