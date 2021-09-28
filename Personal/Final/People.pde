class People {

  float x, x1, x2, y, w, l, h;
  int count=0;
  float fact, colour, trans;


  People(float x, float y, float w, float h) {

    this.x=x;
    this.y=y;
    this.w=w;
    this.h=h;
    fact = 4*w/h;
    colour=255/h;
    trans=0.8/h;
  }

  void display() {
    float temp=10;
    while (count<h) {
      //triangle
      strokeWeight(1);
      for (int i=0; i<h/4; i++) {
        x1 = x-i*fact/2;
        x2 = x+i*fact/2;
        //stroke(h-count*colour, trans*count);
        //line(x1, y, x2, y);
        y--;
        //count++;
      }

      //rectangle
      for (int i=0; i<h*3/4; i++) {
        stroke(h-count*colour, trans*count);
        line(x1, y, x2, y);
        y--;
        count++;
      }
      temp=y;
      //demi-circle
      for (int i=0; i<h/4; i++) { 
        float r=w/2;
        float d=i;
        float c=2*sqrt(r*r-d*d);
        stroke(h-count*colour, trans*count);
        x1 = x-c/2;
        x2 = x+c/2;
        line(x1, y, x2, y);

        //face
        if (i>h/16-1 && i<h/16+1) {
          //temp=y;
        }
        y--;
        count++;
      }
      //face
      fill(0, 0, 1);
      strokeWeight(0.4);
      beginShape();
      curveVertex(x+w*3/8, temp-h/9);
      curveVertex(x+w*3/12, temp+h/7);
      curveVertex(x-w*3/12, temp+h/7);
      curveVertex(x-w*3/8, temp-h/9);
      curveVertex(x, temp-h/5.5);
      curveVertex(x+w*3/8, temp-h/9);
      curveVertex(x+w*3/12, temp+h/7);
      curveVertex(x-w*3/12, temp+h/7);
      curveVertex(x-w*3/8, temp-h/9);
      curveVertex(x, temp-h/5.5);
      endShape();

      //mouth
      noStroke();
      fill(0, 0, 0);
      ellipse(x, temp+h/11, w*2/5, h/38); 
      //eyes
      ellipse(x-w/5, temp-h/20, w*3/20, h/50);
      ellipse(x+w/5, temp-h/20, w*3/20, h/50);
      //eyelines
      stroke(0, 0, 0, 0.5);
      strokeWeight(h/200);
      line(x-w/4, temp-h*3/100, x-w/8, temp-h*3/100);
      line(x+w/4, temp-h*3/100, x+w/8, temp-h*3/100);

      //menton
      strokeWeight(h/150);
      line(x-w/15, temp+h/8, x+w/15, temp+h/8);

      fill(283, 0.25, 1, 0.6);
      noStroke();
      //marks top left
      beginShape();
      curveVertex(x-w/8, temp-h*7/100);
      curveVertex(x-w/8, temp-h*7/100);
      curveVertex(x-w/5, temp-h*7/100);      
      curveVertex(x-w/8, temp-h/8);
      curveVertex(x-w/9, temp-h/8);
      curveVertex(x-w/9, temp-h/8);
      endShape();

      //mark botton left
      beginShape();
      curveVertex(x-w/5, temp-h*1/100);
      curveVertex(x-w/5, temp-h*1/100);
      curveVertex(x-w*11/40, temp-h*1/100);      
      curveVertex(x-w/5, temp+h/20);
      curveVertex(x-w/5, temp+h/20);
      endShape();

      //mark top right
      beginShape();
      curveVertex(x+w/8, temp-h*7/100);
      curveVertex(x+w/8, temp-h*7/100);
      curveVertex(x+w/5, temp-h*7/100);      
      curveVertex(x+w/8, temp-h/8);
      curveVertex(x+w/9, temp-h/8);
      curveVertex(x+w/9, temp-h/8);
      endShape();

      //mark botton rigth
      beginShape();
      curveVertex(x+w/5, temp-h*1/100);
      curveVertex(x+w/5, temp-h*1/100);
      curveVertex(x+w*11/40, temp-h*1/100);      
      curveVertex(x+w/5, temp+h/20);
      curveVertex(x+w/5, temp+h/20);
      endShape();
    }
  }
}
