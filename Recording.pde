Process _precord;

void updateFFmpeg(){
  //PImage img=(PImage)this.g.get();
  try{
    // ImageInputStream iis = ImageIO.createImageInputStream(new ByteArrayInputStream(image));
    // BufferedImage img = ImageIO.read(iis);
    BufferedImage bimg=(BufferedImage)((PImage)this.g.get()).getNative();
    ImageIO.write(bimg, "BMP", ffmpegInput);

  }catch(Exception e){
    println(e);
  }
}
void initFFmpeg(){
  
  println("Start recording...");
  
  String path=sketchPath()+"\\output\\";
  
  File ffmpeg_output_msg = new File(path+"text\\ffmpeg_output_msg"+image_id+".txt");
  ProcessBuilder pb = new ProcessBuilder(
          FFmpeg_Path,"-f","image2pipe","-i","pipe:0","-c:v","libx264","-acodec","libfaac",path+"video\\"+image_id+".mp4");
  pb.redirectErrorStream(true);
  pb.redirectOutput(ffmpeg_output_msg);
  pb.redirectInput(ProcessBuilder.Redirect.PIPE);

  try{
    //Process p = pb.start();
    _precord=pb.start();
    ffmpegInput = _precord.getOutputStream();
  }catch(Exception e){
    println("init error: "+e);
  }
  
  recording=true;
  _in_process=false;
  
}
void closeFFmpeg(){
  
  println("Stop recording...");
  recording=false;
  
  try{
    ffmpegInput.close();
    _precord.waitFor();
  }catch(Exception e){
    println("init error: "+e);
  }
      
}
void processVideo(){
  
  _in_process=true;
  
  closeFFmpeg();
  
  convertVideo();
  createVideo();
  deleteBuffVideo();
 
  uploadFile(sketchPath()+"\\output\\video\\final_"+image_id+".mp4",Server_Folder+"final_"+image_id+".mp4");
  if(UPLOAD_THUMB_IMAGE) uploadFile(sketchPath()+"\\output\\thumb\\thumb_"+image_id+".png",Server_Folder+"thumb_"+image_id+".png");

  String url=Share_Url+image_id;
  createQRcode(url);
  _mode=0;
  
}