void loadImageSeq(){
  
  _img_seq=new ArrayList<PImage>();
  for(int i=0;i<TOTAL_FRAME;++i){
    PImage img=loadImage("seq\\mid"+nf(i,3)+".png");
    _img_seq.add(img);
    println("load img #"+i);
  }
  
  finish_loading=true;
}