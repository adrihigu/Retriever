Car car;
PVector bf;
PVector bb;
float angle = 0;
float r;
  private final int WAITING = 0;
  private final int RETURN_ONEBALL = 1;
  private final int RETURN_ALLBALL = 2;
  private final int TRACK = 3;
  private final int REACH = 5;
  private final int _RETURN = 4;
double duty = 0;
double dutySide;
PVector ball;
int m1 = 1;
int m2 = 1;
PathPlanner traj;

void setup() {
  size(640, 360);
  //r = height/32;
  r = sqrt(sq(width/64) + sq(height/32));
  car = new Car(width/32, height/8,this);
  //println(car.getPos());
  traj = new PathPlanner(car, 0, this);
  car.set(width/2, height/2-height/8, width/2, height/2+height/8);
  bf = new PVector(width/2, height/2-height/32);
  bb = new PVector(width/2, height/2+height/32);
  car.setMatrix();
  //println("dir   : ", car.getDirX(), " ", car.getDirY(), degrees(-acos(car.getDirX()/sqrt(sq(car.getDirX()) + sq(car.getDirY()))))-PI/2);
}

void draw() {
  background(0);
  car.display();
  fill(0,0,255);
  ellipse(bf.x, bf.y, 10, 10);
  fill(color(0,255,255));
  ellipse(bb.x, bb.y, 10, 10);
  noFill();
  stroke(255);
  //float diag = sqrt(sq(width/64) + sq(height/32));
  //PVector hehexd = car.getDir().normalize().rotate(-HALF_PI).setMag(width/64).add(car.getPos());
  //ellipse(hehexd.x, hehexd.y, r*2, r*2);
  //PVector front = car.getDir().setMag(height/32).add(bf);
  //PVector back = car.getDir().setMag(height/32).mult(-1).add(bb);
  //line(front.x, front.y, back.x, back.y);
  //PVector luffy = hehexd.copy().sub(car.getPos());
  //PVector lF = luffy.copy().add(bf);
  //PVector rF = luffy.copy().rotate(PI).add(bf);
  //PVector lB = luffy.copy().add(bb);
  //PVector rB = luffy.copy().rotate(PI).add(bb);
  //line(lF.x, lF.y, rF.x, rF.y);
  //line(lB.x, lB.y, rB.x, rB.y);
  if(ball != null){
    fill(color(255,0,0));
    ellipse(ball.x, ball.y, 10, 10);
  }
  if(traj.applyPath()){
    updateCar();
    println("wop");
  }
  println(duty);
}

void mouseReleased(){
  ball = new PVector(mouseX, mouseY);
  traj.setMode(REACH);
  traj.update();
}

void updateCar(){
  int dir;
  if(m1 == 0 && m2 == 1){
    dir = -1;
  }else if(m1 == 1 && m2 == 0){
    dir = 1;
  }else{
    dir = 0;
  }
  //angle = angle+dir*radians(1);
  //bf = new PVector(mouseX, mouseY).add(new PVector(r*cos(angle-PI), r*sin(angle-PI)));
  //bb = new PVector(mouseX, mouseY).add(new PVector(r*cos(angle), r*sin(angle)));
  if(dir != 0){
      //PVector hehexd = car.getDir().normalize().rotate(-HALF_PI).setMag(width/64).add(car.getPos());
      PVector hehexd = car.getPos();
      PVector rotF = bf.copy().sub(hehexd);
      PVector rotB = bb.copy().sub(hehexd);
      bf = hehexd.copy().add(rotF.rotate(dir*(float)duty));
      bb = hehexd.copy().add(rotB.rotate(dir*(float)duty));
  }else{
    bf.add(car.getDir().mult(-(float)duty));
    bb.add(car.getDir().mult(-(float)duty));
  }
  car.set(bf.x,bf.y,bb.x,bb.y);
  car.setMatrix();
  //println("mouse : ", mouseX, " ", mouseY, " " , bf.x, " " , bf.y, " " , bb.x, " " , bb.y);
  //println("carro : ", car.getX(), " ", car.getY());
  //println("dir   : ", car.getDirX(), " ", car.getDirY(), degrees(-acos(car.getDirX()/sqrt(sq(car.getDirX()) + sq(car.getDirY()))))-HALF_PI);
}
static class Car{
  private AtomicFloat x;
  private AtomicFloat y;
  private AtomicFloat dirX;
  private AtomicFloat dirY;
  private final float cWidth;
  private final float cHeight;
  //private final String frontColor;
  //private final String backColor;
  //private BallArray balls;
  private final int carColor;
  private final prueba parent;
  private final PShape carShape;

  //Car(float cW, float cH, String fColor, String bColor, BallArray b, sketch_180703a p){
    Car(float cW, float cH, prueba p){
    parent = p;
    x = new AtomicFloat();
    y = new AtomicFloat();
    dirX = new AtomicFloat();
    dirY = new AtomicFloat();
    cWidth = cW;
    cHeight = cH;
    //frontColor = fColor;
    //backColor = bColor;
    //balls = b;
    carColor = #808080;
    carShape = parent.createShape();
    carShape.beginShape();
    carShape.fill(carColor);
    carShape.noStroke();
    carShape.vertex(0, 0);
    carShape.vertex(cWidth, 0);
    carShape.vertex(cWidth, cHeight);
    carShape.vertex(0, cHeight);
    carShape.endShape();
  }
  public PVector getPos(){
    return new PVector(getX(), getY());
  }
  public PVector getDir(){
    return new PVector(getDirX(), getDirY()).normalize();
  }
  public float getX(){
    return x.get();
  }
  public float getY(){
    return y.get();
  }
  public float getDirX(){
    return dirX.get();
  }
  public float getDirY(){
    return dirY.get();
  }
  public void set(float xF, float yF, float xB, float yB){
    x.set((xF + xB)/2);
    y.set((yF + yB)/2);
    dirX.set((xF - xB)/sqrt(sq(xF - xB) + sq(yF - yB)));
    dirY.set((yF - yB)/sqrt(sq(xF - xB) + sq(yF - yB)));
  }
  public void setMatrix(){
    carShape.resetMatrix();
    //parent.shapeMode(CENTER);
    carShape.translate(x.get(),y.get());  
    carShape.rotate((new PVector(getDirX(),getDirY())).heading()-HALF_PI);
    carShape.translate(-cWidth/2, -cHeight/2);
  }
  public void display(){
    parent.shape(carShape, 0,0);
  }
}
