

void createQRcode(String qrcode_url){
    
    println("Create QRcode..."+qrcode_url);
    String myCodeText=qrcode_url;
    
    try{
        Hashtable<EncodeHintType, ErrorCorrectionLevel> hintMap=new Hashtable<EncodeHintType, ErrorCorrectionLevel>();
        hintMap.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.L);
        QRCodeWriter qrCodeWriter=new QRCodeWriter();
        BitMatrix byteMatrix=qrCodeWriter.encode(myCodeText,BarcodeFormat.QR_CODE, _qr_size, _qr_size, hintMap);
        int CrunchifyWidth=byteMatrix.getWidth();
        
        
        _qrcode_pg.beginDraw();        
        _qrcode_pg.background(255);
        
         for(int i=0;i<CrunchifyWidth;i++)
            for(int j=0;j<CrunchifyWidth;j++)
                if(byteMatrix.get(i,j)){
                  _qrcode_pg.set(i,j,color(0));
                }        
        _qrcode_pg.endDraw();

        String qname=sketchPath()+"\\output\\qrcode\\"+image_id+".png";
        PImage tmp=_qrcode_pg.get();        
        tmp.save(qname);
        
        saveStrings(QRCode_Order_File,new String[]{qname});

    }catch(Exception e){
        e.printStackTrace();
    }

  
}