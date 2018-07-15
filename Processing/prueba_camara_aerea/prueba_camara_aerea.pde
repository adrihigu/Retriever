final float COURT_WIDTH = 300;
final float COURT_HEIGHT = 300;
final float REAL_COURT_WIDTH = 1;
final float REAL_COURT_HEIGHT = 1;
Car car;
BallArray balls;
Court court;

void setup() {
  size(640, 360);
  car = new Car(30, 60, "CYAN", "BLUE", this);
  balls = new BallArray(COURT_WIDTH,COURT_HEIGHT, REAL_COURT_WIDTH, REAL_COURT_HEIGHT, width/2, height/2, car, this);
  court = new Court(COURT_WIDTH, COURT_HEIGHT, width/2, height/2);
  // start server data retrieval
  balls.start();
}

void draw() {
  background(0);
  noFill();
  court.display();
  car.display();
  balls.display();
}

void keyPressed() {
  if (key == 'r') {
    balls.reStart();
  }
  else if (key == 'q') {
    balls.stop();
  }
}

private class Court{
  private final float cWidth;
  private final float cHeight;
  private final PVector center;

  Court(float cW, float cH, float x, float y){
    cWidth = cW;
    cHeight = cH;
    center = new PVector(x,y);
  }
  public PVector getPos(){
    return center.copy();
  }
  public float getWidth(){
    return cWidth;
  }
  public float getHeight(){
    return cHeight;
  }
  public void display(){
    stroke(255);
    strokeWeight(2);
    rect(center.x - cWidth/2, center.y - cHeight/2, cWidth, cHeight);
  }
}
