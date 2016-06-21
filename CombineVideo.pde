void convertVideo(){
  println("Convert video...");
  
  String path=sketchPath()+"\\output\\";
  String dpath=sketchPath()+"\\data\\";
  
  File ffmpeg_output_msg = new File(path+"text\\ffmpeg_output_msg2.txt");
  
  ProcessBuilder pb = new ProcessBuilder(FFmpeg_Path, "-y",
    "-i", path+"video\\"+image_id+".mp4",
    "-r", "24", "-c", "copy", "-bsf:v", "h264_mp4toannexb", "-an", "-f", "mpegts",
    path+"video\\convert_"+image_id+".mpeg");
     
  pb.redirectErrorStream(true);
  pb.redirectOutput(ffmpeg_output_msg);
  
  try{
    Process p = pb.start();
    p.waitFor();
  }catch(Exception e){
    println("init error: "+e);
  }
  
}
void createVideo(){
  
  println("Combine video...");
  
  String path=sketchPath()+"\\output\\";
  String dpath=sketchPath()+"\\data\\";
  
  File ffmpeg_output_msg = new File(path+"text\\ffmpeg_output_msg3.txt");
  
  ProcessBuilder pb = new ProcessBuilder(FFmpeg_Path,
    "-y","-i","\"concat:"+dpath+"video\\open_v2.mpeg|"+path+"video\\convert_"+image_id+".mpeg|"+dpath+"video\\end_v2.mpeg\"",
    "-i", dpath+"video\\full_v2.m4a",
    "-c:v","libx264","-c:a","copy",path+"video\\final_"+image_id+".mp4");
     
  pb.redirectErrorStream(true);
  pb.redirectOutput(ffmpeg_output_msg);
  
  try{
    Process p = pb.start(); 
    p.waitFor();
  }catch(Exception e){
    println("init error: "+e);
  }
  
  
}

void deleteBuffVideo(){
  
  println("Delete Buff Video...");
  
  String path=sketchPath()+"\\output\\";
  
  File f1=new File(path+"video\\convert_"+image_id+".mpeg");
  f1.delete();
  File f2=new File(path+"video\\"+image_id+".mp4");
  f2.delete();
  

}