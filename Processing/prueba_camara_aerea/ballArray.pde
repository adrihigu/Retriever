import java.util.Map;
import java.util.HashMap;

static class BallArray{
  private Map<Integer,Ball> balls;
  private final float COURT_WIDTH;
  private final float COURT_HEIGHT;
  private float REAL_COURT_WIDTH;
  private float REAL_COURT_HEIGHT;
  private final PVector court_center;
  private final prueba_camara_aerea parent;
  private Boolean requestDataFlag;
  private Runnable ballUpdateThread;
  
  BallArray(float cW, float cH, float rCW, float rCH, float cX, float cY, prueba_camara_aerea p){
    COURT_WIDTH = cW;
    COURT_HEIGHT = cH;
    REAL_COURT_WIDTH = rCW;
    REAL_COURT_HEIGHT = rCH;
    court_center = new PVector(cX, cY);
    parent = p;
    requestDataFlag = false;
  }
  
  private void addBall(float x, float y, float r, String c){
    balls.put(balls.isEmpty()? 1: balls.size()+1 , new Ball(x, y, r, c, parent));
  }
  private void updateBall(float x, float y, float r, String c, int id){
    balls.get(id).set(x, y, r, c);
  }
  private void startDataRequests(){
    //JSONArray json = parent.loadJSONArray(camServer);
    if(!requestDataFlag){
      //println("iniciando hilo");
      requestDataFlag = true;
      balls = new HashMap<Integer,Ball>();
      ballUpdateThread = new BallUpdateRunnable(balls);
      Thread t = new Thread(ballUpdateThread);
      t.setDaemon(true);
      t.start();
    }
  }
  private void stopDataRequests(){
    //println("terminando hilo");
    requestDataFlag = false;
  }
  public void start(){
    stopDataRequests();
    startDataRequests();
  }
  public void reStart(){
    stopDataRequests();
    parent.delay(20);
    startDataRequests();
  }
  public void stop(){
    stopDataRequests();
  }
  public void display(){
    //println("mostrando las bolas");
    for(int i = 1; i <= balls.size(); i++) {
      balls.get(i).display();
    }
  }
  public PVector translateCoordinate(float x, float y){
    return new PVector(x*COURT_WIDTH/REAL_COURT_WIDTH + court_center.x - COURT_WIDTH/2, y*COURT_HEIGHT/REAL_COURT_HEIGHT + court_center.y - COURT_HEIGHT/2);
  }
  public float convertFloatToPixel(float x){
    return x*COURT_WIDTH/REAL_COURT_WIDTH;
  }
  public int findClosestTo(PVector newBall, IntList l){
    float closestDist = sqrt(sq(COURT_WIDTH) + sq(COURT_HEIGHT));
    int closestIndex = 0;
    for(int i = 1; i <= balls.size(); i++) {
      float tempDist = balls.get(i).getDistTo(newBall.x, newBall.y);
      if( !l.hasValue(i) && tempDist < closestDist){
        closestDist = tempDist;
        closestIndex = i;
      }
    }
    return closestIndex;
  }
  public int updateClosest(PVector newBall, float r, String c, IntList l){
    int closest = findClosestTo(newBall, l);
    if(closest != 0) updateBall(newBall.x, newBall.y, r, c, closest);
    return closest;
  }
  private class BallUpdateRunnable implements Runnable{
    private Map<Integer,Ball> balls;
    private static final String camServer = "http://127.0.0.1:8000/";
    private static final int MS_DATA_REQUEST_PERIOD = 1;
    
    public BallUpdateRunnable(Map<Integer,Ball> ballsToUpdate){
      this. balls = ballsToUpdate;
    }
    
    @Override
      public void run(){
        while(requestDataFlag){
          //println("nuevo ciclo en hilo");
          int ms = parent.millis();
          try{
              JSONArray json = parent.loadJSONArray(camServer);
              if(json == null){
                //println("data vacia");
              }else if(json.size() > 0){
                //IntList foundBalls = new IntList();
                IntList updatedBalls = new IntList();
                for (int i = 0; i < json.size(); i++) {
                  //boolean ballRecognized = false;
                  PVector newBallPos = translateCoordinate(json.getJSONArray(i).getJSONArray(0).getFloat(0),json.getJSONArray(i).getJSONArray(0).getFloat(1));
                  //println(json.getJSONArray(i).getString(2));
                  //for (int j = 1; j <= balls.size(); j++) {
                  //  //println(j);
                  //  if(balls.get(j).isCloseTo(newBallPos.x, newBallPos.y)){
                  //    //println("bola cercana");
                  //    updateBall(newBallPos.x, newBallPos.y,convertFloatToPixel(json.getJSONArray(i).getFloat(1)), json.getJSONArray(i).getString(2), j);
                  //    updatedBalls.append(updateClosest(newBallPos, convertFloatToPixel(json.getJSONArray(i).getFloat(1)), json.getJSONArray(i).getString(2), updatedBalls));
                  //    //ballRecognized = true;
                  //    //foundBalls.append(j);
                  //    break;
                  //  }
                  //}
                  int ballRecognized = updateClosest(newBallPos, convertFloatToPixel(json.getJSONArray(i).getFloat(1)), json.getJSONArray(i).getString(2), updatedBalls);
                  
                  if(ballRecognized != 0? false : true){
                    //println("agregando pelota nueva");
                    addBall(newBallPos.x, newBallPos.y ,convertFloatToPixel(json.getJSONArray(i).getFloat(1)), json.getJSONArray(i).getString(2));
                    updatedBalls.append(i);
                  }else{
                    updatedBalls.append(ballRecognized);
                  }
                }
                //for(int i = 1; i <= balls.size(); i++) {
                //  if(!foundBalls.hasValue(i)){
                //    balls.get(i).setLost(1);
                //  }
                //  //println( balls.get(i).getX(), " ", balls.get(i).getY(), " ", balls.get(i).getColor(), "id: ", i , " ", balls.size());
                //}
                //ball = translatePosition(ball_1.getJSONArray(0).getFloat(0), ball_1.getJSONArray(0).getFloat(1));
              }
              Thread.sleep(MS_DATA_REQUEST_PERIOD);
          } catch (Exception e){
            println("No es posible conectarse con el Servidor");
            //e.printStackTrace();
          };
          println("tomo ", parent.millis()-ms, " ms procesar las ", balls.size() , " bolas");
        }
        //println("limpiando bolas");
        balls.clear();
      }
  }
  
}
