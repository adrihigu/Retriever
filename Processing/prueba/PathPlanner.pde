class PathPlanner{
  //private BallArray balls;
  private Car car;
  private prueba p;
  private int index;
  private ArrayList<PVector> path;
  private final float PROXIMITY_THRESHOLD = 1;
  private final float STOP_MARGIN = 3;
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
  private MiniPID linPid;
  private MiniPID rotPid;
  private double rotOut;
  private double linOut;
  private final double KP_LIN = 0.05;
  private final double KI_LIN = 0;
  private final double KD_LIN = 0;
  private final double KP_ROT = 0.05;
  private final double KI_ROT = 0.00005;
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
      rotPid = new MiniPID(KP_ROT, KI_ROT, KD_ROT);
      linPid = new MiniPID(KP_LIN, KI_LIN, KD_LIN);
      rotPid.setDirection(true);
      isRot = true;
      return true;
    }
    else{
      path.add(p.car.getPos());
      return false;
    }
    return false;
  }
  
  public boolean isGoalInFront(float angle){
    return angle <= MAX_ANGLE_DIFF? true : false;
  }
  
  public void followPath(float angle){
    linOut =  linPid.getOutput(PVector.dist(getGoal(),p.car.getPos()), 0);
    rotOut = rotPid.getOutput(angle, 0);
    //println("lin: ", linOut, " rot: ", rotOut);
    println("linFix: ", fixLin(angle), " rotFix: ", fixRot(fixLin(angle), PVector.dist(getGoal(),p.car.getPos())));
    //println("lin: ", linOut*LIN_CONST, " rot: ", rotOut*ROT_CONST);
  }
  public boolean checkObstacle(PVector point, PVector ball){
    return PVector.dist(point, ball) <= CAR_RADIUS? true : false 
  }
  public int checkDir(float angle){
    return p.car.getDir().copy().cross(PVector.sub(getGoal(),p.car.getPos())).z >= 0? -1 : 1;
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
        linPid.reset();
        rotPid.reset();
      }
    }
    float angle =  PVector.angleBetween(PVector.sub(getGoal(),p.car.getPos()), p.car.getDir());
    int dir = checkDir(angle);
    followPath(angle);
    if(isGoalInFront(angle)){
       p.dutySide = rotOut;
       p.duty = linOut;
       p.m1 = 1;
       p.m2 = 1;
       p.ds = dir == -1? 0: 1;
    }
    else if(dir == -1){ // counter clockwise
      p.duty = rotOut;
      p.m1 = 0;
      p.m2 = 1;
    }else if(dir == 1){ // clockwise
      p.duty = rotOut;
      p.m1 = 1;
      p.m2 = 0;
    }
    return true;
  }
  
  public float fixLin(float currentAngle){
    if(currentAngle < MAX_ANGLE_DIFF){
      if((linOut*LIN_CONST) > 27){
        return (float)(linOut*LIN_CONST);
      }
      if((linOut*LIN_CONST) > STOP_MARGIN &(linOut*LIN_CONST) <= 27){
        return (float)27;
      }
    }
    else{
      return (float)0;
    }
    
    if((linOut*LIN_CONST) < STOP_MARGIN){
      return (float)0;
    }
    return 0;
  }
  
  public float fixRot(float linFix,float currentDistance){
    if((linOut*LIN_CONST) < STOP_MARGIN){
      return 0;
    } else
    return (float)((rotOut*ROT_CONST) + ((linFix == 0) ? 27 : 0));
    //if(currentDistance > FINAL_THRESHOLD + 10){
    //  if(linFix == 0)
    //    return (float)(rotOut*ROT_CONST) + 27;
    //  else{
    //    return 0;
    //  }
    //}
    //else{
    //  return (float)(rotOut*ROT_CONST);
    //}
  }
  
}
