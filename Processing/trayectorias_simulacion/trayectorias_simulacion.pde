
final float CAR_WIDTH = 30;
final float CAR_HEIGHT = 60;
final float COURT_WIDTH = 200;
final float COURT_HEIGHT = 350;
final float BALL_SIZE = 20;

Mover[] movers = new Mover[10];
Car carrito;
PVector car_pos;
PVector ball;
PVector end;
PVector court_center;
Trajectory t;
// Liquid
//Liquid liquid;

void setup() {
  size(640, 360);
  //reset();
  // Create liquid object
  //liquid = new Liquid(0, height/2, width, height/2, 0.1);
  car_pos = new PVector(width/2, height*3/4);
  carrito = new Car(1, car_pos, 30, 60);
  court_center = new PVector(width/2, height/2);
  ball = new PVector(random(court_center.x - (COURT_WIDTH/2 -BALL_SIZE*1.5), court_center.x + (COURT_WIDTH/2 -BALL_SIZE*1.5)),random(court_center.y - (COURT_HEIGHT/2 -BALL_SIZE*1.5), court_center.y + (COURT_HEIGHT/2 -BALL_SIZE*1.5)));
  end = new PVector(court_center.x, court_center.y + COURT_HEIGHT/2);
  t = new Trajectory(car_pos, ball, end);

}

void draw() {
  background(0);

  // Draw water
  //liquid.display();

  // for (Mover mover : movers) {

  //   // Is the Mover in the liquid?
  //   if (liquid.contains(mover)) {
  //     // Calculate drag force
  //     PVector drag = liquid.drag(mover);
  //     // Apply drag force to Mover
  //     mover.applyForce(drag);
  //   }

  //   // Gravity is scaled by mass here!
  //   PVector gravity = new PVector(0, 0.1*mover.mass);
  //   // Apply gravity
  //   mover.applyForce(gravity);

  //   // Update and display
  //   mover.update();
  //   mover.display();
  //   mover.checkEdges();
  // }
  // PVector gravity = new PVector(0, 0.1*carrito.mass);
  // carrito.applyForce(gravity);
  carrito.update();
  carrito.display();
  carrito.checkEdges();
  noStroke();
  fill(204, 102, 0);
  ellipse(ball.x, ball.y, BALL_SIZE, BALL_SIZE);
  fill(255);
  t.display();
  noFill();
  stroke(255);
  strokeWeight(2);
  rect(court_center.x - COURT_WIDTH/2, court_center.y - COURT_HEIGHT/2, COURT_WIDTH, COURT_HEIGHT);
  // text("click mouse to reset", 10, 30);
}

void mouseDragged() {
  if(mouseX < ball.x + BALL_SIZE/2 && mouseX > ball.x - BALL_SIZE/2 && mouseY < ball.y + BALL_SIZE/2 && mouseY > ball.y - BALL_SIZE/2){
    ball = new PVector(mouseX, mouseY);
    t = new Trajectory(car_pos, ball, end);
  }
  else if(mouseX < car_pos.x + CAR_WIDTH/2 && mouseX > car_pos.x - CAR_WIDTH/2 && mouseY < car_pos.y + CAR_HEIGHT/2 && mouseY > car_pos.y - CAR_HEIGHT/2){
    car_pos = new PVector(mouseX, mouseY);
    carrito = new Car(1, car_pos, 30, 60);
    t = new Trajectory(car_pos, ball, end);
  }
}

void keyPressed() {
   reset();
}

// Restart all the Mover objects randomly
void reset() {
  ball = new PVector(random(court_center.x - (COURT_WIDTH/2 -BALL_SIZE*1.5), court_center.x + (COURT_WIDTH/2 -BALL_SIZE*1.5)),random(court_center.y - (COURT_HEIGHT/2 -BALL_SIZE*1.5), court_center.y + (COURT_HEIGHT/2 -BALL_SIZE*1.5)));
  t = new Trajectory(car_pos, ball, end);
}
