class PathPlanner{
  //private BallArray balls;
  private Car car;
  private prueba p;
  private int index;
  private ArrayList<PVector> path;
  private final float PROXIMITY_THRESHOLD = 1;
  private final float FINAL_THRESHOLD = 45*2/3 + 45/2;
  private final int WAITING = 0;
  private final int RETURN_ONEBALL = 1;
  private final int RETURN_ALLBALL = 2;
  private final int TRACK = 3;
  private final int REACH = 5;
  private final int _RETURN = 4;
  public int mode;
  private boolean catched;
  private AtomicFloat goalX;
  private AtomicFloat goalY;
  private final float MAX_ANGLE_DIFF = radians(1);
  private MiniPID pid;
  private final double KP_LIN = 0.05;
  private final double KI_LIN = 0;
  private final double KD_LIN = 0;
  private final double KP_ROT = 0.05;
  private final double KI_ROT = 0;
  private final double KD_ROT = 0;
  private boolean isRot = true;
  // PathPlanner(BallArray b, Car c, comunicacion_serial p){
  //PathPlanner(BallArray b, Car c, int m, prueba p){
  PathPlanner(Car c, int m, prueba p){
    //balls = b;
    car = c;
    mode = m;
    this.p = p;
    index = 0;
    catched = false;
    goalX = new AtomicFloat();
    goalY = new AtomicFloat();
  }
  public boolean isCatched(){
    return catched;
  }
  public void setCatched(boolean b){
    catched = b;
  }
  public boolean hasFinished(){
    return path.size() == 0? true : isReached(path.get(path.size() -1));
  }

  public boolean isReached(PVector point){
    if(mode == REACH && path.size() == 1){
      return car.getPos().sub(point).mag() <= FINAL_THRESHOLD;
    }
    return car.getPos().sub(point).mag() <= PROXIMITY_THRESHOLD;
  }

  public void setMode(int mode){
    this.mode = mode;
  }

  public PVector getGoal(){
    return path.get(0).copy();
  }

  public boolean nextGoal(){
    if(mode == REACH && path.size() == 1){
      return true;
    }
    path.remove(0);
    return path.size() == 1;
  }
  
  public void setGoal(float x, float y){
    goalX.set(x);
    goalY.set(y);
  }
  public boolean update(){
    path = new ArrayList<PVector>();
    if(mode == REACH){
      path.add(new PVector(mouseX, mouseY));
      pid = new MiniPID(KP_ROT, KI_ROT, KD_ROT);
      isRot = true;
    }
    else{
      path.add(p.car.getPos());
    }
    return true;
  }
  
  public boolean isGoalInFront(float angle){
    return angle <= MAX_ANGLE_DIFF? true : false;
  }
  
  public double followPath(float angle){
    if(isRot == false){
      return pid.getOutput(PVector.dist(getGoal(),p.car.getPos()), 0);
    }else {
      return pid.getOutput(angle, 0);
    }
  }
  
  public int checkDir(float angle){
    if(!isRot) return 0;
    if(isGoalInFront(angle) && isRot){
      pid.reset();
      pid = new MiniPID(KP_LIN, KI_LIN, KD_LIN);
      pid.setDirection(true);
      isRot = false;
      return 0;
    }else {
      return p.car.getDir().copy().cross(PVector.sub(getGoal(),p.car.getPos())).z >= 0? -1 : 1;
    }
  }
  
  public boolean applyPath(){ // retorna falso cuando se acabo el camino
    if(path == null || path.size() == 0) return false;
    if(isReached(getGoal())){
      if(nextGoal()){ // se acabo el camino
        p.duty = 0;
        p.dutySide = 0;
        return false;
      }
      else{
        pid = new MiniPID(KP_ROT, KI_ROT, KD_ROT);
      }
    }
    float angle =  PVector.angleBetween(PVector.sub(getGoal(),p.car.getPos()), p.car.getDir());
    int dir = checkDir(angle);
    if(dir == 0){
      p.m1 = 1;
      p.m2 = 1;
    }
    else if(dir == -1){ // counter clockwise
      p.m1 = 0;
      p.m2 = 1;
    }else if(dir == 1){ // clockwise
      p.m1 = 1;
      p.m2 = 0;
    }
    duty = followPath(angle);
    return true;
  }
}
