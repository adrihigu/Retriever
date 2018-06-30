final float COURT_WIDTH = 300;
final float COURT_HEIGHT = 300;
BallArray balls;


void setup() {
  size(640, 360);
  balls = new BallArray(COURT_WIDTH,COURT_HEIGHT, 1.5, 1.5, width/2, height/2, this);
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

//float translateCoordinate(float c){
//  return c*COURT_WIDTH/REAL_COURT_WIDTH;
//}

//PVector translatePosition(float x, float y){
//  return new PVector(translateCoordinate(x)+ court_center.x -COURT_WIDTH/2 ,translateCoordinate(y)+ court_center.y +COURT_HEIGHT/2);
//}


//void requestData(){
//  while(true){
//    if(requestServerDataFlag == REQUEST_DATA){
//      try{
//          JSONArray json = loadJSONArray(cam_server);
//          if(json == null){
//            if (dataX.size() != 0) {           // dataY tiene siempre el mismo tamaño
//              dataX.append(dataX.get(dataX.size() -1 ));
//              dataX.remove(0);
//              dataY.append(dataY.get(dataY.size() -1 ));
//              dataY.remove(0);
//            }
//          }else if(json.size() > 0){
//            JSONArray ball_1 = json.getJSONArray(0);
//            if (dataX.size() == MAX_DATA_POINTS) {// dataY tiene siempre el mismo tamaño
//              dataX.append(ball_1.getJSONArray(0).getFloat(0));
//              dataX.remove(0);
//              dataY.append(ball_1.getJSONArray(0).getFloat(1));
//              dataY.remove(0);
//            }else{
//              dataX.append(ball_1.getJSONArray(0).getFloat(0));
//              dataY.append(ball_1.getJSONArray(0).getFloat(1));
//            }
//            //ball = translatePosition(ball_1.getJSONArray(0).getFloat(0), ball_1.getJSONArray(0).getFloat(1));
//          }
//          Thread.sleep(10);
//      } catch (Exception e){
//        println("No es posible conectarse con el Servidor");
//        e.printStackTrace();
//      };   
//    }else if(requestServerDataFlag == END_DATA_REQUESTS){
//      break;
//    }
//  }
//}
