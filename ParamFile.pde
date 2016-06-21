
String getTimeId(){   
  return year()+"_"+nf(month(),2)+"_"+nf(day(),2)+"_"+nf(hour(),2)+"_"+nf(minute(),2)+"_"+nf(second(),2);  
}

void readPos(){
  
   XML posxml=loadXML("pos_file.xml");
   XML[] frame=posxml.getChildren("FRAME");
   
   _frame_pos=new ArrayList<PVector>();
   _frame_ang=new FloatList();
   
   int len=frame.length;
   for(int i=0;i<len;++i){
     _frame_pos.add(new PVector(frame[i].getFloat("X"),frame[i].getFloat("Y")));
     _frame_ang.append(frame[i].getFloat("ANG"));    
   }
}

void readParam(){
  
  XML param_xml;
  try{
    param_xml=loadXML("data\\param_file.xml");
  }catch(Exception e){
    println("writeParam");
    writeParam();
    return;
  }
  
  Output_Path=(param_xml.getChildren("OUTPUT_PATH")[0]).getContent();
  Output_Title=(param_xml.getChildren("OUTPUT_TITLE")[0]).getContent();
    
  MaskPos=new PVector(float((param_xml.getChildren("MASK_X")[0]).getContent()),float((param_xml.getChildren("MASK_Y")[0]).getContent()));
  MaskSize=new PVector(float((param_xml.getChildren("MASK_WIDTH")[0]).getContent()),float((param_xml.getChildren("MASK_HEIGHT")[0]).getContent()));
  
  Server_Url=(param_xml.getChildren("SERVER_URL")[0]).getContent();
  Server_Id=(param_xml.getChildren("SERVER_ID")[0]).getContent();
  Server_Pwd=(param_xml.getChildren("SERVER_PWD")[0]).getContent();
  Server_Folder=(param_xml.getChildren("SERVER_FOLDER")[0]).getContent();
  
  Share_Url=(param_xml.getChildren("SHARE_URL")[0]).getContent();
  
  QRCode_Order_File=(param_xml.getChildren("QRCODE_ORDER_FILE")[0]).getContent();
  
  Osc_Port_Num=int((param_xml.getChildren("OSC_PORT_NUM")[0]).getContent());
  FFmpeg_Path=(param_xml.getChildren("FFMPEG_PATH")[0]).getContent();
  
  String Osc_IP_1=(param_xml.getChildren("OSC_CLIENT_IP_1")[0]).getContent();
  String Osc_IP_2=(param_xml.getChildren("OSC_CLIENT_IP_2")[0]).getContent();
  
  int Osc_Port_1=int((param_xml.getChildren("OSC_CLIENT_PORT_1")[0]).getContent());
  int Osc_Port_2=int((param_xml.getChildren("OSC_CLIENT_PORT_2")[0]).getContent());
  
  osc_location_1=new NetAddress(Osc_IP_1,Osc_Port_1);
  osc_location_2=new NetAddress(Osc_IP_2,Osc_Port_2);
  
  println(Output_Path);
  println(Output_Title);
  
  println(MaskPos);
  println(MaskSize);
  
  readPos();
}

void writeParam(){
  XML xml=new XML("PARAM");
  XML op=xml.addChild("OUTPUT_PATH");
  op.setContent(Output_Path);
  
  XML ot=xml.addChild("OUTPUT_TITLE");
  ot.setContent(Output_Title);
  
  XML mx=xml.addChild("MASK_X");
  mx.setContent(String.valueOf(MaskPos.x));
  
  XML my=xml.addChild("MASK_Y");
  my.setContent(String.valueOf(MaskPos.y));
  
  XML mw=xml.addChild("MASK_WIDTH");
  mw.setContent(String.valueOf(MaskSize.x));
  
  XML mh=xml.addChild("MASK_HEIGHT");
  mh.setContent(String.valueOf(MaskSize.y));
  
  XML m1=xml.addChild("SERVER_URL");
  m1.setContent("mmlab.bremennetwork.tw");
  XML m2=xml.addChild("SERVER_ID");
  m2.setContent("mmlabnetwork");
  XML m3=xml.addChild("SERVER_PWD");
  m3.setContent("fAg5h@j");
  XML m4=xml.addChild("SERVER_FOLDER");
  m4.setContent("WarTown/");
  
  XML m5=xml.addChild("QRCODE_ORDER_FILE");
  m5.setContent(sketchPath()+"\\output\\qrcode\\qrorder.txt");
  
  XML m6=xml.addChild("SHARE_URL");
  m6.setContent("mmlab.bremennetwork.tw/Share/index.php?vid=");

  XML m7=xml.addChild("OSC_PORT_NUM");
  m7.setContent("12000");
      
  XML m8=xml.addChild("FFMPEG_PATH");
  m8.setContent("C:\\ffmpeg\\bin\\ffmpeg.exe");
  
  XML osc1=xml.addChild("OSC_CLIENT_IP_1");
  osc1.setContent("127.0.0.1");  
  XML posc1=xml.addChild("OSC_CLIENT_PORT_1");
  posc1.setContent("25000");
  
  XML osc2=xml.addChild("OSC_CLIENT_IP_2");
  osc2.setContent("127.0.0.1");  
  XML posc2=xml.addChild("OSC_CLIENT_PORT_2");
  posc2.setContent("25000");
  
  
  saveXML(xml,"data\\param_file.xml");
  
}