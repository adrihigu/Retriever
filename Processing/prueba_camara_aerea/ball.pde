import java.util.concurrent.atomic.*;
import java.util.Map;
import java.util.HashMap;
import java.util.Collections;

static class Ball{
  private AtomicFloat x;
  private AtomicFloat y;
  private final AtomicReference<String> ballColor;
  private AtomicFloat radius;
  private AtomicInteger lostFlag;
  private final prueba_camara_aerea parent;
  private static final Map<String, Integer> colorMap;
  static{
    Map<String, Integer>tempMap = new HashMap<String, Integer>();
    tempMap.put("RED", #FF0000);
    tempMap.put("GREEN", #00FF00);
    tempMap.put("BLUE", #0000FF);
    tempMap.put("CYAN", #00FFFF);
    tempMap.put("MAGENTA", #FF00FF);
    tempMap.put("YELLOW", #FFFF00);
    colorMap = Collections.unmodifiableMap(tempMap);
  }
  
  Ball(float posX, float posY, float r, String bColor, prueba_camara_aerea p){
    parent = p;
    x = new AtomicFloat();
    y = new AtomicFloat();
    radius = new AtomicFloat();
    lostFlag = new AtomicInteger();
    ballColor = new AtomicReference<String>();
    x.set(posX);
    y.set(posY);
    ballColor.set(bColor);
    radius.set(r);
    lostFlag.set(0);
    //println("pelota nueva " + bColor);
  }
  public void set(float posX, float posY, float r, String bColor){
    x.set(posX);
    y.set(posY);
    ballColor.set(bColor);
    radius.set(r);
  }
  public void setLost(int f){
    lostFlag.set(f);
  }
  public boolean isLost(){
    return lostFlag.get() == 0? false : true;
  }
  public float getDistTo(float x, float y){
    return dist(x, y, this.x.get(), this.y.get());
  }
  public boolean isCloseTo(float x, float y){
    return getDistTo(x,y) <= getRadius()? true : false;
  }
  public color getColor(){
    return colorMap.get(ballColor.get()).intValue();
  }
  public PVector getPos(){
    return new PVector(getX(), getY());
  }
  public float getX(){
    return x.get();
  }
  public float getY(){
    return y.get();
  }
  public float getRadius(){
    return radius.get();
  }
  public void display(){
    parent.noStroke();
    parent.fill(getColor());
    parent.ellipse(getX(), getY(), getRadius(), getRadius());
  }
}
