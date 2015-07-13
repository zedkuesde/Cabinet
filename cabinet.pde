import ddf.minim.*;

String bddName = "bdd.txt";

Minim minim;
AudioPlayer player;
bdd base; 
record testrec = null;
int  recordID =0;
display disp;


//test var
PImage[] img = new PImage[3];

public class record{
  private int id;
  AudioPlayer audio;
  int marqueurTab[][];
  String village;
  PImage img;
  int x,y,w,h;
  
  public record(String villagestr, int idrec){
    village = villagestr;
    audio = minim.loadFile("data/"+village+"/audio.wav");
    id = idrec;
    img = new PImage();
    //img = loadImage("data/"+village+"/visuel.png");
    fillMarqueurTab();
    fillDisplayData();
    rect(x,y,w,h);
  }
  
  private void fillDisplayData(){
    String[] stuff = loadStrings("data/"+village+"/display.txt");
    int[] tampon = new int[4];
    tampon = int(split(stuff[0],'@')); 
    x = tampon[0];
    y = tampon[1];
    w = tampon[2];
    h = tampon[3];
  }
  
  private void fillMarqueurTab(){
    String[] stuff = loadStrings("data/"+village+"/marqueur.txt");
    int[] tampon = new int[2];
    marqueurTab = new int[stuff.length][2];
    //println(stuff[0]);
    for(int i = 0; i<stuff.length;i++){
       tampon = int(split(stuff[i],' ')); 
       marqueurTab[i][0]= tampon[0];
       marqueurTab[i][1]= tampon[1];
       //println(marqueurTab[i][0] +" | " +marqueurTab[i][1]);
    }
  }
  
  public int getLength(){
     return audio.length(); 
  }
   public int getPosition(){
     return audio.position(); 
  }
  
  public void lOop(){
    audio.loop();
    
  }
  public int getIDCurrentWord(){
     int position = audio.position();
     println("position = "+position);
     int wordID = searchForPosition(position);
     println("wordID = "+wordID);
     return wordID;
  }
  
  public int getMilliForWordID(int wordId){
    for(int i = 0; i<marqueurTab.length-1;i++){
       if (marqueurTab[i][0] == wordId) return marqueurTab[i][1];
    }
    return marqueurTab[0][1];
  }
  
  private int searchForPosition(int position){
     for(int i = 0; i<marqueurTab.length-1;i++){
        if(position < marqueurTab[0][1]) return marqueurTab[0][0];
        if(position > marqueurTab[i][1] && position < marqueurTab[i+1][1]) return marqueurTab[i][0];
     } 
     return 0;
  }
  
  public int getID() {return id;}
  public String getVillage() {return village;}
  
  public void recordPlay(int millisec){
     audio.play(millisec); 
  }
  public void recordPlay(){
     audio.play(); 
  }
  public void recordPause(){
     audio.pause(); 
  }
}

public class bdd{
  String bddData[][];
  private String path;
  record recordTab[];
  int bddLength;
  
  public bdd(String pth){
    setPath(pth);
    getBDD();
    createRecord();
  }
  public void setPath(String pth){ path = pth;}
  public String getPath(){ return path;}
  
  public void setBddLength(int lgth){ bddLength = lgth;}
  public int getBddLength(){ return bddLength;}
  
  public String getVillageWithID(int id){ 
    for(int i=0;i<bddLength;i++){
       if(Integer.parseInt(bddData[i][0]) == id) 
         return bddData[id][1];
       else return "error";
    }
    return "error";
}

  public record getRecordByID(int idrec){
    for(int i=0;i<bddLength;i++){
       if(recordTab[i].getID() == idrec) 
         return recordTab[i];
    }
    return null;
  }
  
  private void createRecord(){
     recordTab = new record[getBddLength()];
     
    
    for(int i=0; i< getBddLength();i++){
        recordTab[i] = new record(bddData[i][1],Integer.parseInt(bddData[i][0]));
    }
  }
  
  private void getBDD(){
  String tampon[];
  String tampon1[];
  
  //read bdd
  tampon = loadStrings("bdd.txt");
  setBddLength(tampon.length);
  bddData = new String[tampon.length][2];
  
  for(int i=0; i < tampon.length;i++){
     tampon1 = split(tampon[i],'@');
     bddData[i][0] = tampon1[0]; 
     bddData[i][1] = tampon1[1];
  }
}
}

public class display{
   int windowWidth;
   int windowHeigth;
   int numberOfTrack;
   
   public display(int w, int h, int nb){
    windowWidth = w;
    windowHeigth = h;
    numberOfTrack = nb;
    size(windowWidth,windowHeigth);
   }
   
   public void displayContent(record recordTab[]){
    for (int i =0; i < numberOfTrack;i++){
     image(recordTab[i].img,recordTab[i].x,recordTab[i].y,recordTab[i].w,recordTab[i].h);
     //display marqueur
     for(int k = 0; k < recordTab[i].marqueurTab.length ; k++){
      rect(recordTab[i].x+whereToPutTheReader(recordTab[i].getLength(),recordTab[i].marqueurTab[k][1],recordTab[i].w),recordTab[i].y,1,10);
     }
    } 
   }
   
   public void displaySelector(){
      ellipse(testrec.x-60,testrec.y+(testrec.h/2),50,50); 
   }
}


void setup(){
  //size(800,600);
    disp = new display(1280,800,4);
  minim = new Minim(this);
base = new bdd(bddName);
  /*
  img[1] = loadImage("data/faget/visuel.png");
  img[0] = loadImage("data/plaisance/visuel.png");
  img[2] = loadImage("data/romieu/visuel.png");
  */
  //disp = new display(1280,800,4);
 testrec = base.getRecordByID(0);  
 println(testrec.getVillage());
 testrec.recordPlay();
 testrec.lOop();
}

void draw(){
  background(0,0,0);
  // disp.displayContent(base.recordTab);
  fill(250);
  noStroke();
  rect(whereToPutTheReader(testrec.getLength(),testrec.getPosition(),testrec.w)+testrec.x,testrec.y,8,testrec.h);

  //disp.displaySelector();
  
  
}

public int whereToPutTheReader(int soundLength, int soundPosition, int displaySize){
  return ((displaySize*soundPosition)/soundLength);
}

void mousePressed(){
  for(int i = 0; i<base.recordTab.length;i++){
    //println(base.recordTab[i].x);
     if(mouseX > base.recordTab[i].x && mouseX < base.recordTab[i].x+base.recordTab[i].w && mouseY > base.recordTab[i].y && mouseY < base.recordTab[i].y+base.recordTab[i].h){
       recordID = base.recordTab[i].getID();
     }
  }
    switchRecord();
}

void switchRecord(){
  testrec.recordPause();
  int wordid = testrec.getIDCurrentWord();
  //int test = (int)(random(2));
  //println(test);
  testrec = base.getRecordByID(recordID);
  int millisecForPlay = testrec.getMilliForWordID(wordid);
  println(testrec.getVillage());
  println("word number : "+millisecForPlay);
  testrec.recordPlay(millisecForPlay);
  testrec.lOop();
}

void keyPressed(){
  switch(key){
     case 'a' : recordID = 0;switchRecord(); break;
    case 'z' : recordID = 1;switchRecord(); break;
   case 'e' : recordID = 2;switchRecord(); break;
   case 'r' : recordID = 3;switchRecord(); break;
  }
}

void stop()
{
  // always close Minim audio classes when you are done with them
  minim.stop();
  super.stop();
}

