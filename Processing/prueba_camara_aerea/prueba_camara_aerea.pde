final float COURT_WIDTH = 300;
final float COURT_HEIGHT = 300;
BallArray balls;


void setup() {
  size(640, 360);
  balls = new BallArray(COURT_WIDTH,COURT_HEIGHT, 1, 1, width/2, height/2, this);
  // start server data retrieval
  balls.startDataRequests();
   
}

void draw() {
  background(0);
  noFill();
  stroke(255);
  strokeWeight(2);
  rect(width/2 - COURT_WIDTH/2, height/2 - COURT_HEIGHT/2, COURT_WIDTH, COURT_HEIGHT);
  balls.display();
}

void keyPressed() {
  if (key == 'r') {
    balls.stopDataRequests();
    delay(20);
    balls.startDataRequests();
  }
  else if (key == 'q') {
    balls.stopDataRequests();
  }
  else if (key == 's') {
    balls.stopDataRequests();
    balls.startDataRequests();
  }
}
