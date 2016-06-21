void initGamePad(){
   _gamepad_control=ControlIO.getInstance(this);
   List<ControlDevice> devices=_gamepad_control.getDevices();
   for(ControlDevice d: devices){
     //println(d.getName());
     if(d.getName().indexOf("USB Gamepad")!=-1){
       _gamepad_device=d;
       _gamepad_device.open();
       println("Init Game Pad...");       
     };
   }
   
   if(_gamepad_device==null){
      println("Fail....");
      return;
   }
   int bcount=0;   
   _gamepad_button=new ArrayList<ControlButton>();
   for(ControlInput input:_gamepad_device.getInputs()){
      if(input instanceof ControlButton){
        //println(input.getName());
        if(bcount<MBUTTON){
          _gamepad_button.add((ControlButton)input);
          bcount++;
        }        
      }
   }
   println("Register "+bcount+" buttons...");
}

void updateGamePad(){
  for(int i=0;i<MBUTTON;++i){
    boolean pressed_=_gamepad_button.get(i).pressed();
    drawButton(i,pressed_);
    
    if(!pressed_) continue;
    
    switch(i){
       case 0:
         takePhoto();
         break;
       case 1:
          sendMessage(osc_location_1,1);
         break;
    }
  }
}

void drawButton(int i,boolean p_){
  int rad=50;
   pushStyle(); 
    ellipseMode(CORNER);
    noStroke();
    //if(p_) println("Button "+i+" pressed!");
    fill(p_?color(255,0,0):color(180));
    ellipse(width-rad,i*rad+rad*.2,rad*.8,rad*.8);
   popStyle();
}