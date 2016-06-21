import net.java.games.input.*;
import org.gamecontrolplus.*;
import org.gamecontrolplus.gui.*;
import java.util.List;

import netP5.*;
import oscP5.*;

import org.apache.commons.net.ftp.FTPClient;

import java.io.*;
import javax.imageio.ImageIO;
import javax.imageio.stream.ImageInputStream;
import java.awt.image.BufferedImage;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URL;
import java.net.URLConnection;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;
import java.util.Hashtable;

import processing.video.*;


String Output_Path="data\\output\\";
String Output_Title="video_";


boolean TEST_MODE=false; //auto run
boolean USE_DEMO_PHOTO=false;
boolean UPLOAD_THUMB_IMAGE=false;

/* source */
Movie _back_video;
ArrayList<PImage> _img_seq;
boolean finish_loading=false;
ArrayList<PVector> _frame_pos;
FloatList _frame_ang;

PImage _mask_image;
PImage _test_image;


Capture _cam;

/* ffmpeg recording */
String FFmpeg_Path;
OutputStream ffmpegInput;
boolean recording=false;

int FRAME_RATE=24;
float TOTAL_FRAME=460;

int _mode=0;
int cur_fr;
boolean _in_process=false;


/* mask */
PGraphics _front_pg;

PVector MaskPos=new PVector(0,0);
PVector MaskSize=new PVector(720,720);
PShader _mask_shader;


/* share qrcode */
String image_id;
String Server_Url,Server_Id,Server_Pwd,Server_Folder;
String Share_Url;
String QRCode_Order_File;
int QR_OFFSET=50;
PGraphics _qrcode_pg;
int _qr_size;

/* osc */
OscP5 oscP5;
int Osc_Port_Num;
NetAddress osc_location_1;
NetAddress osc_location_2;

/* game pad */
int MBUTTON=2;
ControlIO _gamepad_control;
ControlDevice _gamepad_device;
ArrayList<ControlButton> _gamepad_button;



void setup(){
  
  
  size(1280,720);
  background(255);
  frameRate(FRAME_RATE);

  //_back_video=new Movie(this,"middle.mov");  
    
  finish_loading=false;
  thread("loadImageSeq");
  readParam();
  
  initGamePad();
  initOsc();
  
  //image_id="2";
  //uploadVideo();
 
  
  
  _qr_size=min(width,height)-QR_OFFSET*2;
  _qrcode_pg=createGraphics(_qr_size,_qr_size);
  
  _mask_image=loadImage("mask_filter.png");  
  _test_image=loadImage("test.jpg");
 // _mask_shader=loadShader("filter.glsl");
  
  initCamera();
  saveStrings(QRCode_Order_File,new String[]{""});
}


void draw(){
  

  background(255);
  //cur_fr=constrain(int(_back_video.time()*FRAME_RATE),0,_frame_pos.size()-1);
      
  switch(_mode){
    case 0:
      if(TEST_MODE && random(200)<1) {
         createFrontImage();          
         cur_fr=0;
         initFFmpeg();
        _mode=2;
      }
      if(!finish_loading){
        pushStyle();
          String pstr="LOADING";
          for(int i=0;i<frameCount%4;++i) pstr+=".";
          fill(255,0,0);
          //textSize(50);
          text(pstr,width/3,height/2);
        popStyle();
        break;
      }
      
    case 1:
      
      if(_cam.available()==true) _cam.read();
      
      if(USE_DEMO_PHOTO) set(0,0,_test_image);
      else set(0,0,_cam);
      //image(_cam,0,0);
      pushStyle();
      blendMode(ADD);
        image(_mask_image,MaskPos.x,MaskPos.y,MaskSize.x,MaskSize.y);
      popStyle();
      
      pushStyle();
      fill(255,0,0);     
        text(MaskPos.x+" , "+MaskPos.y,20,40);
        text(MaskSize.x+" , "+MaskSize.y,20,80);
      popStyle();
      break; 
    case 2:                
      cur_fr=(int)(constrain(cur_fr+1,0,TOTAL_FRAME-1));
      //println((float)cur_fr/(float)FRAME_RATE);
      //_back_video.jump((float)cur_fr/(float)FRAME_RATE);
      
      
      pushStyle();
      //set(0,0,_back_video);
      set(0,0,_img_seq.get(cur_fr));
      pushMatrix();
     
      translate(_frame_pos.get(cur_fr).x,_frame_pos.get(cur_fr).y);
      rotate(radians(_frame_ang.get(cur_fr)));
      //scale(1.1,1.1);
        float fs=451;
        float fe=460;
        if(cur_fr>=fs && cur_fr<=fe) tint(255,map(cur_fr,fs,fe,255,0));
        image(_front_pg,0,0);
        //shader(_mask_shader);
        //noStroke();
        //beginShape(QUAD);
        //  vertex(0,0,0,0);
        //  vertex(0,_mask_image.height,0,1);
        //  vertex(_mask_image.width,_mask_image.height,1,1);
        //  vertex(_mask_image.width,0,1,0);
        //endShape();
      popMatrix();
      
      popStyle();
           
      
      //
      
      //if(_back_video.time()==_back_video.duration()){         
      if(cur_fr==TOTAL_FRAME-1){
          closeFFmpeg();        
          _mode=3;
         // resetShader();
      }
      
      break;
    case 3: //processing
     
      
      pushStyle();
        //textAlign(CENTER);
        fill(255,0,0);
        //textSize(50);
        String pstr="PROCESSING";
        for(int i=0;i<frameCount%4;++i) pstr+=".";
        text(pstr,width/3,height/2);
      popStyle();
      
      if(!_in_process) thread("processVideo");
       
      break;
    case 4: //qrcode
      image(_qrcode_pg,width/2-_qr_size/2,QR_OFFSET);
      break;
  }
    
    
    if(recording){
      if(UPLOAD_THUMB_IMAGE){
          if(cur_fr==34) ((PImage)this.g.get()).save("output/thumb/thumb_"+image_id+".png");
      }
      updateFFmpeg();
    }
    
    pushStyle();
      fill(255,0,0);
      textSize(12);
      text("mode= "+_mode,20,25);    
      text(String.valueOf(cur_fr),20,10);
      surface.setTitle(String.valueOf(frameRate));
    popStyle();
    updateGamePad();
    
}


//void movieEvent(Movie m) {
//  _back_video.read();
//}

void takePhoto(){
  if(_mode==0 && finish_loading){        
    createFrontImage();          
    //_back_video.play();
    //TOTAL_FRAME=_back_video.duration()*FRAME_RATE;
    cur_fr=0;
    //_back_video.jump(0);
    
     initFFmpeg();
    _mode=2;
  }
}

void keyPressed(){

  switch(key){      
      //case 't':
      //  image_id=getTimeId();
      //  createQRcode("http://mmlab.bremennetwork.tw/WarTown/final_"+image_id+".mp4");
      //  break;
      case 'a': 
        takePhoto();                  
        break;      
      case 'd':
        if(_mode==0) _mode=1;
        break;
      case 's':
        if(_mode==1){
          writeParam();
          _mode=0;
        }
        break;
      case 'r':
        readParam();
        break;        
        
      case '1':
        sendMessage(osc_location_1,1);
        break;
      case '2':
        sendMessage(osc_location_2,1);
        break;
  }
  if(_mode!=1) return;
  if(key==CODED){
    switch(keyCode){
      case UP:
        MaskPos.y-=1;break;
      case DOWN:
        MaskPos.y+=1;break;
      case RIGHT:
        MaskPos.x+=1;break;
      case LEFT:
        MaskPos.x-=1;break;       
    }
  }else{
    switch(key){
      case 'z':
        MaskSize.x+=1;break;
      case 'x':
        MaskSize.x-=1;break;
      case 'c':
        MaskSize.y+=1;break;
      case 'v':
        MaskSize.y-=1;break;
    }
  }
}


void createFrontImage(){
    
   image_id=getTimeId(); 
  _front_pg=createGraphics(_mask_image.width,_mask_image.height);
  
   float rx=_mask_image.width/MaskSize.x;
   float ry=_mask_image.height/MaskSize.y;
   
  _front_pg.beginDraw();
  if(USE_DEMO_PHOTO)
    _front_pg.image(_test_image,-MaskPos.x*rx,-MaskPos.y*ry,
                  rx*_cam.width,
                  ry*_cam.height);
  else
    _front_pg.image(_cam,-MaskPos.x*rx,-MaskPos.y*ry,
                  rx*_cam.width,
                  ry*_cam.height);
  //_front_pg.blendMode(ADD);
  //_front_pg.image(_mask_image,0,0);
  //_front_pg.loadPixels();
  
  for(int i=0;i<_mask_image.width;++i)
    for(int j=0;j<_mask_image.height;++j){
      color c=_mask_image.get(i,j);
      color src=_front_pg.get(i,j);
      _front_pg.set(i,j,maskColor(c,src));
    }
  //_front_pg.updatePixels();
  _front_pg.endDraw();
  _front_pg.save("output\\image\\"+image_id+".png");
  

}

color maskColor(color m,color s){
  return color(min(red(m)+red(s),255),
              min(green(m)+green(s),255),
              min(blue(m)+blue(s),255),alpha(m));
}