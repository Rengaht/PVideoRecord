String uploadFile(String filePath,String uploadPath){
  
  String ftpUrl="ftp://%s:%s@%s/%s;type=i";
 
  //String filePath=sketchPath()+"\\output\\video\\final_"+image_id+".mp4";
  //String uploadPath=Server_Folder+"final_"+image_id+".mp4";
 
  FTPClient ftpClient=new FTPClient();
    
  try {
            
      ftpClient.connect(Server_Url, 21);
      ftpClient.login(Server_Id,Server_Pwd);
      ftpClient.enterLocalPassiveMode();
 
      ftpClient.setFileType(FTP.BINARY_FILE_TYPE);
 
      File firstLocalFile = new File(filePath);
 
      String firstRemoteFile =uploadPath;
      InputStream inputStream = new FileInputStream(firstLocalFile);
 
      println("Start uploading...");
      boolean done = ftpClient.storeFile(firstRemoteFile, inputStream);
      inputStream.close();
      if (done) {
          println("Uploaded successfully.");
      }
    }catch(IOException ex){
        println("Error: " + ex.getMessage());
        ex.printStackTrace();
    }finally{
        try{
            if(ftpClient.isConnected()){
                ftpClient.logout();
                ftpClient.disconnect();
            }
        }catch(IOException ex){
            ex.printStackTrace();
        }
        
        return "http://"+Server_Url+"/"+uploadPath;
        
    }
  
}

//void uploadImage(){
  
//  String ftpUrl="ftp://%s:%s@%s/%s;type=i";
 
//  String filePath=sketchPath()+"\\output\\thumb\\thumb_"+image_id+".png";
//  String uploadPath=Server_Folder+"thumb_"+image_id+".png";
 
//  FTPClient ftpClient=new FTPClient();
    
//  try {
            
//      ftpClient.connect(Server_Url, 21);
//      ftpClient.login(Server_Id,Server_Pwd);
//      ftpClient.enterLocalPassiveMode();
 
//      ftpClient.setFileType(FTP.BINARY_FILE_TYPE);
 
//      File firstLocalFile = new File(filePath);
 
//      String firstRemoteFile =uploadPath;
//      InputStream inputStream = new FileInputStream(firstLocalFile);
 
//      println("Start uploading image...");
//      boolean done = ftpClient.storeFile(firstRemoteFile, inputStream);
//      inputStream.close();
//      if (done) {
//          println("Uploaded successfully.");
//      }
//    }catch(IOException ex){
//        println("Error: " + ex.getMessage());
//        ex.printStackTrace();
//    }finally{
//        try{
//            if(ftpClient.isConnected()){
//                ftpClient.logout();
//                ftpClient.disconnect();
//            }
//        }catch(IOException ex){
//            ex.printStackTrace();
//        }
        
//        //return "http://"+Server_Url+"/"+uploadPath;
        
//    }
//}