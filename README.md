# Interactive-Media-projects
#
import controlP5.*;
import java.util.*;
import beads.*;

PImage background, streetLights, sky;
float alpha = 0;
Table lightning, people;
int lightRowCount, peopleRowCount;
float colour;
float[][] ppl;
float[][] xs, ys, coordinates;
float margin = 50, offset = 50;
People arr[];
float w, h;

float[][] light;
PFont myFont;

List dates;
String[] dateElements;
int [] days = new int[30]; //Data retrieved from 4/22 to 5/22 have 30 days in demand
int [] hours = new int[24];
int [] mins = new int[4];

FloatList thisX, thisY;
ControlP5 cp5;

Slider s;
float myColor;
float sliderX, sliderY;
int sliderWidth, sliderHeight;
int sliderMinVal, sliderMaxVal;
int sliderValue;
int selectDate, mySlider;

ScrollableList d;
float scrollX, scrollY;

AudioContext ac;
SamplePlayer bgm, birds;
Gain bgm_gain, birds_gain;
Panner birds_pan;
Knob knobV;
float volume = 0.7;

PImage birds_img;
int x0_bird = 0;
int y0_bird = 0;

void setup() {
  //fullScreen();
  size(1000, 600);
  background = loadImage("background3.png");
  sky = loadImage("gradient.png");
  streetLights = loadImage("lightsBG.png");
  birds_img = loadImage("birds.gif");
  
  
  myFont = createFont("Poor Richard", 250);

  sliderX = width*0.42;
  sliderY = height*0.9;
  sliderWidth = (int)(width/2.5);
  sliderHeight = height/30;
  sliderMinVal = 0;
  sliderMaxVal = 95;
  scrollX = width/20;
  scrollY = height/10;

  lightning = loadTable("lightning.csv", "csv");
  people = loadTable("peopleCounter.csv", "csv");
  lightRowCount = lightning.getRowCount(); //2881 rows
  peopleRowCount = people.getRowCount(); //4390 rows  
  
  //Initiate Array of Days
  int day = 0;
  int row = 0;
  while (row < lightRowCount) {
    String currentDate = lightning.getString(row, 3);
    String previousDate = lightning.getString(row, 3);

    if (row != 0) {
      previousDate = lightning.getString(row-1, 3);
    }

    String[] datePieces = split(currentDate, "/");
    String[] previousPieces = split(previousDate, "/");
    int cDate = Integer.valueOf(datePieces[1]);
    int pDate = Integer.valueOf(previousPieces[1]);

    if (cDate != pDate) {
      days[day++] = pDate;
    }
    row++;
  }


  //Initiate Array of Hours dan Mins
  for (int hour = 0; hour < 24; hour++) {
    hours[hour] = hour;
    for (int min = 0; min < 4; min++) {
      mins[min] = min * 15;
    }
  }

  
  //Access data value of both tables
  light = accessData(lightning, light);
  ppl = accessData(people, ppl);      


  //Set people position to random x and y
  int maxPeople = getMaxValue(people);
   ys = new float[peopleRowCount][maxPeople];
  for (int i = 0; i < peopleRowCount; i++) {
    for (int j = 0; j < maxPeople; j++) {
      ys[i][j] = random(height*2/3, height);
    }
  }

  xs = new float[peopleRowCount][maxPeople];
  for (int i = 0; i < peopleRowCount; i++) {
    for (int j = 0; j < maxPeople; j++) {
      margin = ys[i][j]*0.8;
      xs[i][j] = random(-map(ys[i][j], height*2/3, height, -600, -200), width+map(ys[i][j], height*2/3, height, -600, -200)) + offset;
    }
    //Arrays.sort(xs[i]);
  }

  //ControlP5 components
  cp5 = new ControlP5(this);
  thisY = new FloatList ();
  thisX = new FloatList ();

  s = cp5.addSlider("mySlider");
  s.setPosition(sliderX, sliderY)
    .setSize(sliderWidth, sliderHeight)
    .setRange(sliderMinVal, sliderMaxVal)
    .setValue(0)
    .setColorBackground(#000000)
    .setColorForeground(#D8003A)
    .setColorActive(#BC0035)
    .scrolled((sliderMinVal+sliderMaxVal)/24)
    .getValueLabel().setVisible(false) //or change to .setLabelVisible(false)
    ;

  s.getCaptionLabel()
    //.align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0)
    //.setFont(createFont("Comic Sans MS", 16)).toUpperCase(false)
    .setVisible(false)
    ;

  //Initiate dates as an array for ScrollabelList
  dateElements = new String[days.length]; 
  for (int i = 0; i < days.length; i++) {
    if (days[i] >= 22) dateElements[i] = String.valueOf(days[i]) + " April";
    if (days[i] < 22) dateElements[i] = String.valueOf(days[i]) + " May";
  }
  dates = Arrays.asList(dateElements);

  d = cp5.addScrollableList("date");  
  d.setPosition(scrollX, scrollY)
   .setSize(200, 300)
   .setBarHeight(30)
   .setItemHeight(30)
   .addItems(dates)
   .setColorBackground(#000000)
   .setColorForeground(#D8003A)
   .setColorActive(#BC0035)
   .setCaptionLabel("Select a date")
   .close();
   
  d.getValueLabel().setFont(createFont("Consolas", 12));
  d.getCaptionLabel().alignY(ControlP5.CENTER).setPaddingX(0).setFont(createFont("Consolas", 14));
  
  frameRate(60);
  colorMode(HSB, 360, 1, 1, 0.4);


  //Audio settings
  ac = new AudioContext();

  //Knob setup
  knobV = cp5.addKnob("volume");
  knobV.setPosition(width*0.84, height*0.78)
       .setRadius(55)
       .setRange(0, 100)
       .setValue(50)
       .setColorBackground(#000000)
       .setColorForeground(#D8003A)
       .setColorActive(#BC0035)
       .getCaptionLabel().setVisible(false)
       ;
       
  knobV.getValueLabel().setFont(createFont("Consolas", 16));
       
  bgm();
  birds();
  
  
  //text message
  String m = "";
  m += "\n=================================USER INSTRUCTIONS!!=================================\n";
  m += "\n";
  m += "Go over the FIGURES' HEADS using mouse to display current people data\n";
  m += "   *** no figure -> data = 0 / NULL *** \n";
  m += "Go over the STREET LAMPS' LIGHT SOURCE using mouse to display current lightning value\n";
  m += "\n=====================================================================================\n";
  println(m);
  
}

void draw(){
  //background setup
  background(sky);
  
  fill(50, alpha); // grey, alpha
  rect(0, 0, 1000, 600);
  image(background, 0, 0);
  
  //birds setup
  x0_bird = int(random(0, width-1));
  y0_bird = int(random(30, 50));
  frameRate(5);
  image(birds_img, x0_bird, y0_bird, 200, 200);
  birds_pan.setPos(panValue());
  
  
  sliderValue = int(cp5.getController("mySlider").getValue());

  //slider label
  float labelX = map(sliderValue, 0, 95, sliderX, sliderX + sliderWidth);
  PFont timeFont =  createFont("Comic Sans MS", (width*height)/30000);
  fill(0);
  textFont(timeFont);
  text(lightning.getString(sliderValue, 4), labelX + 20, sliderY+45);

  
  //street light's source
  float maxLight = getMaxValue(lightning);
  lights(map(light[selectDate][sliderValue], 0, maxLight, 0, 1));
  
  //text(ppl[selectDate][sliderValue], width/2, 100);
  arr= new People [int(ppl[selectDate][sliderValue])];
  for (int j=0; j<ppl[selectDate][sliderValue]; j++) {
    if (thisY.size()>0) {    
      h = map(thisY.get(j), height*2/3, height*11/10, height/5, height/2)-ppl[selectDate][sliderValue]*5;
      w=h/4;
      arr[j] = new People(thisX.get(j), thisY.get(j), w, h);    
      arr[j].display();
    }
  }
  showDataPeople();
  showDataLight();
}

float[][] accessData(Table t, float[][] object) {
  int count = 0;
  int rowsPerDay = hours.length * mins.length;
  object = new float[days.length][rowsPerDay];
  for (int i = 0; i < days.length; i++) {
    for (int j = 0; j < rowsPerDay; j++) {
      object[i][j] = t.getFloat(count, 1);
      count++;
    }
  } 

  return object;
} 

int getMaxValue(Table t) {
  int maxValue = Integer.MIN_VALUE;
  for (int i = 0; i < t.getRowCount(); i++) {
    int val = t.getInt(i, 1);
    if (val > maxValue) maxValue = val;
  }
  return maxValue;
}

void mySlider(int n) {
  
  if (n <= 40) {
    alpha = map(n, sliderMinVal, 40, 0.4, 0);
  } else if (n>40 && n<=64) {
    alpha = 0;
  } else {
    alpha = map(n, 65, sliderMaxVal, 0, 0.4);
  }
 
  arr= new People[int(ppl[selectDate][n])];
  thisY.clear();
  thisX.clear();

  for (int j=0; j<ppl[selectDate][n]; j++) {
    int count = (selectDate+1)*n; 
    int rand = int(random(ys[count].length));
    thisY.append(ys[count][rand]);
    thisX.append(xs[count][rand]);

    count++;
  }
  coordinates = new float [thisY.size()][2];
  int count=0;
  while (thisY.size()>0) {
    for (int i=0; i<thisY.size(); i++) {
      if (thisY.get(i)==thisY.min()) {
        //float temp = thisY.get(i);
        coordinates[count][0]=thisY.get(i);
        coordinates[count][1]=thisX.get(i);
        thisY.remove(i);
        thisX.remove(i);
        count++;
      }
    }
  }

  for (int i=0; i<ppl[selectDate][n]; i++) {

    thisY.append(coordinates[i][0]);
    thisX.append(coordinates[i][1]);
    //println(i+"/"+thisX.get(i));      //print people coordinates
    //println(i+"/"+thisY.get(i));
  }
}

void date(int n) {
  CColor defCol = new CColor();
  defCol.setBackground(color(#000000));
  for (int i=0; i<dates.size(); i++) {
    cp5.get(ScrollableList.class, "date").getItem(i).put("color", defCol);
  }

  CColor selectCol = new CColor();
  selectCol.setBackground(color(#D8003A));
  cp5.get(ScrollableList.class, "date").getItem(n).put("color", selectCol);
  selectDate=n;
}

//Function to show raw data - People counter
void showDataPeople() {
  textAlign(CENTER);
  fill(0, 0, 0, 0.2);      
  boolean hover =false;
  for (int i=0; i<thisX.size(); i++) { //if mouse is over any people's head, display people counter value
    h = map(thisY.get(i), height*2/3, height*11/10, height/5, height/2)-ppl[selectDate][sliderValue]*5;
    if (mouseX>thisX.get(i)-20 && mouseX<thisX.get(i)+20 && mouseY>thisY.get(i)-h-20 && mouseY<thisY.get(i)-h+20) {
      hover = true;
    }
  }
  if (hover==true) {
    textFont(myFont);
    textSize(height/10);
    text(thisX.size(), width/15, height*4/5);
  }
}

//Function to show street lights
void lights(float opacity) {
  //street lights' source
  strokeWeight(1);
  float[] lampA = {width/5.4, height/3.37, width/4.1, height/3.37, width/2, height/1.18, width/5, height/1.18};               //X-pos and Y-pos of lamp A ray
  float[] lampB = {width/2.92, height/3.05, width/2.6, height/3.05, width/1.9, height*3/4, width/2.86, height*3/4};            //lamp B ray

  //create light A
  float xl = (lampA[6]-lampA[0])/(lampA[5]-lampA[1]);
  float xr = (lampA[4]-lampA[2])/(lampA[5]-lampA[1]);
  float x1, x2;
  for (int i=0; i<lampA[5]-lampA[1]; i++) {
    stroke(#FFFF8E, (0.3/(lampA[5]-lampA[1])*(lampA[5]-lampA[1]-i))*opacity);
    x1 = lampA[0]+i*xl;
    x2 = lampA[2]+i*xr;
    line(x1, lampA[1]+i, x2, lampA[1]+i);
  }

  //create light B
  xl = (lampB[6]-lampB[0])/(lampB[5]-lampB[1]);
  xr = (lampB[4]-lampB[2])/(lampB[5]-lampB[1]);
  for (int i=0; i<lampB[5]-lampB[1]; i++) {
    stroke(#FFFF8E, (0.3/(lampB[5]-lampB[1])*(lampB[5]-lampB[1]-i))*opacity);
    x1 = lampB[0]+i*xl;
    x2 = lampB[2]+i*xr;
    line(x1, lampB[1]+i, x2, lampB[1]+i);
  }
}

//Function to show raw data - light
void showDataLight() {
  textAlign(CENTER);
  fill(0, 0, 0, 0.2);
  
  float [] rectA = {width/5.4, height/3.75, width/4.1, height/3.37};    //corners of lamp A
  float [] rectB = {width/2.92, height/3.3, width/2.6, height/3.05};    //corners of lamp B
  boolean hover1 = false;
  boolean hover2 = false;

  if (mouseX>rectA[0] && mouseX<rectA[2] && mouseY>rectA[1] && mouseY<rectA[3]) {              //if mouse is over 1st lamp, display light value
    hover1 = true;
  } else if (mouseX>rectB[0] && mouseX<rectB[2] && mouseY>rectB[1] && mouseY<rectB[3]) {        //if mouse is over 2nd lamp, display light value
    hover2=true;
  }

  if (hover1 == true) {
    //text background color
    fill(0);
    rect(width/6.2, height/5, 55, 23);

    fill(#D8003A);
    textFont(myFont);
    textSize(height/25);
    text(light[selectDate][sliderValue], width/5.4, height/4.3);
  }
  
  if (hover2 == true) {
    //text background color
    fill(0);
    rect(width/3.1, height/4, 50, 20);

    fill(#D8003A);
    textFont(myFont);
    textSize(height/30);
    text(light[selectDate][sliderValue], width/2.9, height/3.55);
  }
}

void bgm(){
  ac = new AudioContext();
  String bgm_title = dataPath("") + "/bgm.wav";
  bgm = new SamplePlayer(ac, SampleManager.sample(bgm_title));
  
  bgm_gain = new Gain(ac, 1, volume);
  bgm_gain.addInput(bgm);
  
  ac.out.addInput(bgm_gain);
  ac.start();
}

void birds(){
  ac = new AudioContext();
  String birds_title = dataPath("") + "/birds.wav";
  birds = new SamplePlayer(ac, SampleManager.sample(birds_title));
  birds.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  
  birds_gain = new Gain(ac, 1, 0.5);
  birds_gain.addInput(birds);
  
  birds_pan = new Panner(ac, 0);
  birds_pan.addInput(birds_gain);
  
  ac.out.addInput(birds_pan);
  ac.start();
}

void volume(float value){
  bgm_gain.setGain(map(value, 0, 100, 0, 2));
}

float panValue(){
  return map(x0_bird, 0, width, -1, 1);
}
