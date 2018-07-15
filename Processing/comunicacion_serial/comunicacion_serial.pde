import processing.serial.*;
import controlP5.*;

public static final int WIDTH = 700;
public static final int HEIGHT = 400;

public static final int WAITING = 0;
public static final int RETURN_ONEBALL = 1;
public static final int RETURN_ALLBALL = 2;
public static final int TRACK = 3;
public static final int COME_BACK = 4;

public static final float CAR_DISTANCE_MARGIN = 5; // 5 cm
public static final float CAR_ANGLE_MARGIN = PI/18; // 10º

public static final int DUTYFIX = int((-3*0xFFFF)/100);  // -3%

public static final int COURT_WIDTH = 300;
public static final int COURT_HEIGHT = 300;
public static final int COURT_REAL_WIDTH = 1;
public static final int COURT_REAL_HEIGHT = 1;

public static final int NO_PACK = 0;
public static final int M_PACK = 1;
public static final int C_PACK = 2;

public static final int NO_ARG = 0;
public static final int ONE_ARG = 1;
public static final int TWO_ARG = 2;
public static final int COLOR_ARG = 3;

public static final int CAR_W = 30;
public static final int CAR_H = 60;
public static final String BBALL_COLOR = "BLUE";
public static final String FBALL_COLOR = "CYAN";

// Variables de recepcion de datos
Serial myPort;                                                           // Puerto Serial
byte[] rxBuffer= new byte[32];                                           // Bytes de entrada del puerto serial
int pot = 0;                                                             // medida del potenciometro
int bufferSize = 1;                                                        // Tamaño del buffer de entrada
int baudRate = 9620;
float[] sharpRef = new float[11]; // INTRODUCIR VALORES
int byteRx;
int camBytesRx;                                                          // Numero de argumentos del resultado de la camara + encabezado
int M1p;
int M2p;
int dutySideRx;                              // Factor de giro
int dutyRx;                                  // Velocidad de movimiento frontal
int dutyFixRx;                          // Corrección añadida a la rueda izquierda
boolean M1mRx;
boolean M2mRx;
boolean camBusy;                                                        // Indica si la camara está ocupada
boolean pwmRx;
boolean sensRx;
boolean eventRx;
boolean camRx;
boolean sharpRx;
boolean onRx;
boolean gameRx;
boolean e4Rx;                                                      // Indica si la recepción del DEMO está sincronizada 
boolean e3Rx;
boolean e2Rx;
boolean e1Rx;
boolean e0Rx;
boolean dig1;                                                      // Sensor digital 1
boolean dig2;                                                      // Sensor digital 2
boolean dig3;                                                      // Sensor digital 3
boolean dig4;                                                      // Sensor digital 4
boolean sync=false;                                                // Indica si la comunicacion serial esta sincronizada
IntList sharpBuffer = new IntList();

// Variables de transmision de datos
byte[] txBuffer= new byte[32];
int byteTx;
boolean txOK = false;                                              // Indica si han sido codificados los datos de transmision serial
boolean askTx;
boolean movTx;
boolean eventTx;
boolean camTx;
boolean e4Tx = sync;                                               // Indica si la recepción de PC está sincronizada 
boolean e3Tx = false;
boolean e2Tx = false;
boolean e1Tx = false;
boolean e0Tx = false;

// Procesamiento de datos de camara
byte[] camArgs = new byte[16];
byte[] camRes = new byte[16];

// Variables de control del juego
boolean on = false;                                // Estado del carrito
int game = 0;                              // Juego actual: 0 -> Buscar pelota; 1 -> Competitivo

// Variables de movimiento
int dutySide = 0;                              // Factor de giro
int duty = 0;                                  // Velocidad de movimiento frontal
int dutyFix = 0;                          // Corrección añadida a la rueda izquierda
boolean M1mTx = false;                             // true: rueda IZQUIERDA en retroceso
boolean M2mTx = false;                    // true: rueda DERECHA en retroceso

// Variables de juego
PathPlanner trajectory;
boolean isTrajectory;
BallArray ballArray;
PVector court_center;
Car carrito;
int mode;
boolean pre_on = false;
float goalDistance;

// Variables de interfaz de usuario
ControlP5 cp5;
int myColor = color(0,0,0);
PFont font;                                                              // Tipo de letra
int ls = 24;                                                             // Constante para espaciado

void setup(){
  size(700,400);
  noStroke();

  court_center = new PVector(width - COURT_WIDTH/2, height/2); // Cancha a la derecha de la GUI
  carrito = new Car(CAR_W, CAR_H, BBALL_COLOR, FBALL_COLOR, this);
  ballArray = new BallArray(COURT_WIDTH, COURT_HEIGHT, COURT_REAL_WIDTH, COURT_REAL_HEIGHT, court_center.x, court_center.y, carrito, this);
  trajectory = new PathPlanner(ballArray, carrito, WAITING, this); // Args: (BallArray ballArray, int mode)
                                                   // mode: WAITING, RETURN_ONEBALL, RETURN_ALLBALL, RETURN 
  myPort = new Serial(this, Serial.list()[1], 9620);
  myPort.buffer(bufferSize);

  cp5 = new ControlP5(this);
  
  initGUI();
  ballArray.start();
}

void draw(){
  background(200);
  checkOn();
  //println("mode :", mode, " tmode: ", trajectory.mode);
  if(on){
    if(trajectory.hasFinished()){ //<>//
      text("Objetivo Completado!", 50, 15);
      //on = false;
      cp5.getController("on").setValue(0);
    }
    else{
      if(isTrajectory){
        controlMov();
      }
      else{
        text("NO SE ENCUENTRA UN CAMINO HACIA EL OBJETIVO", 50, 15);
      }
    }
  }
  else{
    duty = 0;
    dutySide = 0;
    // todo : m1 m2
  }

  if(txOK == false){
    encodeTx();
  }
}

void checkOn(){
  if(on & !pre_on){
    trajectory.set(mode);
    isTrajectory = trajectory.update(); // UPDATE TIENE QUE BAJAR LA FLAG .hasFinished()
  }
  if(!on & pre_on){
    mode = WAITING;
    cp5.getController("mode").setValue(WAITING);
    trajectory.set(mode);
  }
  pre_on = on;
}

void controlMov(){
  PVector current_move;
  PVector preGoal;
  float currentDistance;
  float currentAngle;

  current_move = new PVector(trajectory.getGoal().x-carrito.getX(), trajectory.getGoal().y-carrito.getY());
  currentAngle = getAngle(new PVector(carrito.getDirX(),carrito.getDirY())) - getAngle(current_move);
  dutySide = DUTYFIX;

  if(abs(currentAngle) < CAR_ANGLE_MARGIN){
    currentDistance = current_move.mag();
    if(goalDistance < CAR_DISTANCE_MARGIN){
      if(!trajectory.isCatched()){ // carrito no tiene la bola
        preGoal = trajectory.getGoal();
        trajectory.setCatched(trajectory.nextGoal());  // Cuidado con el caso del ultimo goal: subir la flag .hasFinished()
        goalDistance = preGoal.dist(trajectory.getGoal());
      }
      else{
        mode = COME_BACK;
        cp5.getController("mode").setValue(COME_BACK);
        trajectory.set(mode); // En la clase, siempre se recalcula
        isTrajectory = trajectory.update();
      }
    }
    else{
      duty = int((0.2*0xFFFF) + ((0.3*0xFFFF) * currentDistance)/goalDistance);
      println("duty (distancia)= " + duty);
    }
  }
  else{
    duty = int((0.2*0xFFFF) + ((0.3*0xFFFF) * abs(currentAngle))/PI);
    println("duty (angulo)= " + duty);
    if(currentAngle >= 0){
      M1mTx = false;
      M2mTx = true;
    }
    else{
      M1mTx = true;
      M2mTx = false;
    } 
  }
  
  cp5.getController("Retroceso izquierda").setValue(M1mTx?1:0); //<>//
  cp5.getController("Retroceso derecha").setValue(M2mTx?1:0);
  cp5.getController("DUTYSIDE").setValue(dutySide);
  cp5.getController("DUTY").setValue(duty);
}

float getAngle(PVector vector){
  PVector xVector = new PVector(1,0);
  int sign = (vector.y < 0) ? -1 : 1;
  return(sign * PVector.angleBetween(xVector, vector));
}
//*********************************************** TRANSMISION DE DATOS ***************************************************//

void encodeTx(){
  byteTx = 0;
  camTx = false;
  eventTx = true;
  movTx = true;
  int camBytesTx = 0;
  
  txBuffer[0] = byte((1 << 7) + (((askTx) ? 1 : 0) << 6) + (((movTx) ? 1 : 0) << 5) + (((eventTx) ? 1 : 0) << 4) + (camBytesTx & 0x0F));
  byteTx++;
  
  if(movTx){
    encodeMov();
  }
  
  if(eventTx){
    encodeEvent();
  }
  
  if(camTx){
    encodeCam();
  }
  
  txOK = true;
}

void encodeMov(){
  txBuffer[byteTx] = byte((dutySide & 0x000C000) >> 14);
  txBuffer[byteTx+1] = byte((dutySide & 0x00003F80) >> 7);
  txBuffer[byteTx+2] = byte(dutySide & 0x0000007F);
  txBuffer[byteTx+3] = byte((((M1mTx == true) ? 1 : 0) << 3) + (((M2mTx == true) ? 1 : 0) << 2) + ((duty & 0x000C000) >> 14));
  txBuffer[byteTx+4] = byte((duty & 0x00003F80) >> 7);
  txBuffer[byteTx+5] = byte(duty & 0x0000007F);
  txBuffer[byteTx+6] = byte((dutyFix & 0x000C000) >> 14);
  txBuffer[byteTx+7] = byte((dutyFix & 0x00003F80) >> 7);
  txBuffer[byteTx+8] = byte(dutyFix & 0x0000007F);
  byteTx += 9;
}

void encodeEvent(){
  txBuffer[byteTx] = byte( ( (on ? 1 : 0) << 6) + (game  << 5) + (((sync) ? 1 : 0) << 4) + (((e3Tx) ? 1 : 0) << 3) + (((e2Tx) ? 1 : 0) << 2) + (((e1Tx) ? 1 : 0) << 1) + ((e0Tx) ? 1 : 0) );
  byteTx++;
}

// SIN IMPLEMENTAR

void encodeCam(){
  // int camOp = 0;
  // int camArg= 0;
  
  // if(NO_pack.isFail()){
  //   camOp = NO_pack.getCamOp();
  // }
  // if(M_pack.isFail()){
  //   camOp = M_pack.getCamOp();
  // }
  // if(C_pack.isFail()){
  //   camOp = C_pack.getCamOp();
  // }
  
  // txBuffer[byteTx] = byte( ((camOp & 0x0F) << 4) + camArg);
  // byteTx++;
  
  // switch(camArg){
  //   case 0: //NO_ARG:
      
  //     break;
  //   case 1: //ONE_ARG:
      
  //     break;
  //   case 2: //TWO_ARG:
      
  //     break;
  //   case 3: //COLOR_ARG:
      
  //     break;
  //   default:
  //     break;
    
  // }

}

//*********************************************** RECEPCION DE DATOS ***************************************************//
 
void serialEvent(Serial myPort) {
  if(txOK){                                     // Si los datos para el envio estan listos...
    myPort.write(txBuffer);
    txOK = false;
  }
  
  byteRx = 0;
  myPort.readBytes(rxBuffer);                  // Lectura del buffer de entrada
  syncronize();                                // Verifica si el buffer está sincronizado
  if(sync){
    if(rxBuffer[0] >= 0){                      // Si hay sincronizacion y si no se está leyendo un encabezado...
      //println("----NUEVO PAQUETE----");
      if(pwmRx){
        decodePWM();                           // Decodifica las señales de los PWM: M1+, M1-, M2+ ,M2-
        //println("duty = " + dutyRx);
        //println("dutySide = " + dutySideRx);
        //println("dutyFix = " + dutyFixRx);
        //println("M1m = " + M1mRx);
        //println("M2m = " + M2mRx);
      }
      
      if(sensRx){        
        decodeSens();                          // Decodifica los sensores digitales y la medida del potenciómetro (10 bits)
        //println("dig1 = " + dig1);
        //println("dig2 = " + dig2);
        //println("dig3 = " + dig3);
        //println("dig4 = " + dig4);
        //println("pot = " + pot);
      }
      
      if(eventRx){        
        decodeEvent();                         // Decodifica los eventos
        //println("on = " + onRx);
        //println("game = " + gameRx);
        //println("e0Rx = " + e0Rx);
        //println("e1Rx = " + e1Rx);
        //println("e2Rx = " + e2Rx);
        //println("e3Rx = " + e3Rx);
        //println("e4Rx = " + e4Rx);
      }
      
      if(camBytesRx != 0 ){
        decodeCam();                           // Decodifica los resultados de la CMUcam
      }
      
      //println("sharpVolt = " + (rxBuffer[byteRx] & 0x7F));
      sharpBuffer.append(decodeSharp());    // Decodifica la señal del infrarrojo (7 bits)

      if(sharpBuffer.size() > 100){
        sharpBuffer.remove(0);
      }
      //println("sharpDist = " + sharpBuffer.get(sharpBuffer.size()-1));
    }
    //println("NXTHeader = " + rxBuffer[bufferSize-1]);
    readNextHeader();    // Lee el encabezado del siguiente bloque
  }
  myPort.buffer(bufferSize);                 // Cambia el tamaño del buffer de recepción para el siguiente bloque de bytes
}

  /**
   * Comprueba si la recepción serial está sincronizada          
   * 
   */
void syncronize(){
  if(!sync){
    if((rxBuffer[0] & 0x80) == 0x80){
      sync=true;
    }
  }
}

void decodePWM(){
  dutySideRx = ((rxBuffer[byteRx] & 0x03) << 14) + ((rxBuffer[byteRx+1] & 0x7F) << 7) + (rxBuffer[byteRx+2] & 0x7F);
  dutySideRx += (((dutySideRx & 0x00008000) == 0x00008000) ? 0xFFFF0000 : 0x00000000);
  byteRx += 3;
  M1mRx = ((rxBuffer[byteRx] & 0x08) == 0x08) ? true : false;
  M2mRx = ((rxBuffer[byteRx] & 0x04) == 0x04) ? true : false; 
  dutyRx = ((rxBuffer[byteRx] & 0x03) << 14) + ((rxBuffer[byteRx+1] & 0x7F) << 7) + (rxBuffer[byteRx+2] & 0x7F);  
  byteRx += 3;
  dutyFixRx = ((rxBuffer[byteRx] & 0x03) << 14) + ((rxBuffer[byteRx+1] & 0x7F) << 7) + (rxBuffer[byteRx+2] & 0x7F);
  dutyFixRx += (((dutyFixRx & 0x00008000) == 0x00008000) ? 0xFFFF0000 : 0x00000000);
  byteRx += 3;
}

void decodeSens(){
  dig1 = ((rxBuffer[byteRx] & 0x40) == 0x40) ? false : true;
  dig2 = ((rxBuffer[byteRx] & 0x20) == 0x20) ? false : true;
  dig3 = ((rxBuffer[byteRx] & 0x10) == 0x10) ? false : true;
  dig4 = ((rxBuffer[byteRx] & 0x08) == 0x08) ? false : true;
  pot = int(rxBuffer[byteRx+1] & 0x1F) << 7;
  pot += int(rxBuffer[byteRx+2] & 0x7F);
  byteRx += 3;
}

void decodeEvent(){
  onRx = ((rxBuffer[byteRx] & 0x40) == 0x40) ? true : false;
  gameRx = ((rxBuffer[byteRx] & 0x20) == 0x20) ? true : false;
  e4Rx = ((rxBuffer[byteRx] & 0x10) == 0x10) ? true : false;
  e3Rx = ((rxBuffer[byteRx] & 0x08) == 0x08) ? true : false;
  e2Rx = ((rxBuffer[byteRx] & 0x04) == 0x04) ? true : false;
  e1Rx = ((rxBuffer[byteRx] & 0x02) == 0x02) ? true : false;
  e0Rx = ((rxBuffer[byteRx] & 0x01) == 0x01) ? true : false;
  byteRx += 1;
}


void decodeCam(){
  //int pack;
  //int camOp;
  //boolean CK;

  //camOp = ((rxBuffer[byteRx] & 0x78) >> 3);
  //CK = ((rxBuffer[byteRx] & 0x04) == 0x04) ? true : false;
  //pack = rxBuffer[byteRx] & 0x03;
  //byteRx += 1;
  //switch(pack){
  //  case NO_PACK:
  //    if(!CK){NO_pack.setFail(true);}else{
  //      NO_pack.setReaded(false);
  //    }
  //    NO_pack.setCamOp(camOp);
  //    break;
  //  case M_PACK:
  //    if(!CK){M_pack.setFail(true);}else{
  //      M_pack.setMx((rxBuffer[byteRx] << 1) + (rxBuffer[byteRx + 8] & 0x40) >> 6);
  //      M_pack.setMy((rxBuffer[byteRx+1] << 1) + (rxBuffer[byteRx + 8] & 0x20) >> 5);
  //      M_pack.setX1((rxBuffer[byteRx+2] << 1) + (rxBuffer[byteRx + 8] & 0x10) >> 4);
  //      M_pack.setY1((rxBuffer[byteRx+3] << 1) + (rxBuffer[byteRx + 8] & 0x08) >> 3);
  //      M_pack.setX2((rxBuffer[byteRx+4] << 1) + (rxBuffer[byteRx + 8] & 0x04) >> 2);
  //      M_pack.setY2((rxBuffer[byteRx+5] << 1) + (rxBuffer[byteRx + 8] & 0x02) >> 1);
  //      M_pack.setPix((rxBuffer[byteRx+6] << 1) + (rxBuffer[byteRx + 8] & 0x01));
  //      M_pack.setCnf((rxBuffer[byteRx+7] << 1));
  //      byteRx += 9;
  //      M_pack.setReaded(false);
  //    }
  //    M_pack.setCamOp(camOp);
  //    break;
  //  case C_PACK:
  //    if(!CK){C_pack.setFail(true);}else{
  //      C_pack.setX1((rxBuffer[byteRx] << 1) + (rxBuffer[byteRx + 6] & 0x20) >> 5);
  //      C_pack.setY1((rxBuffer[byteRx+1] << 1) + (rxBuffer[byteRx + 6] & 0x10) >> 4);
  //      C_pack.setX2((rxBuffer[byteRx+2] << 1) + (rxBuffer[byteRx + 6] & 0x08) >> 3);
  //      C_pack.setY2((rxBuffer[byteRx+3] << 1) + (rxBuffer[byteRx + 6] & 0x04) >> 2);
  //      C_pack.setPix((rxBuffer[byteRx+4] << 1) + (rxBuffer[byteRx + 6] & 0x02) >> 1);
  //      C_pack.setCnf((rxBuffer[byteRx+5] << 1) + (rxBuffer[byteRx + 6] & 0x01));
  //      byteRx += 7;
  //      C_pack.setReaded(false);
  //    }
  //    C_pack.setCamOp(camOp);
  //    break;
  //  default:
  //    break;
  //}
  /*
  if(ACK){
    switch(pack){
    case 1:
      packageS(rxBuffer,n,opCam);
      break;
    case 2:
      packageC(rxBuffer,n,opCam);
      break;
    case 3:
      packageM(rxBuffer,n,opCam);
      break;
    default:
      break;
    }
    
    DECIDIR QUE SE VA A ACTUALIZAR EN BASE 
  }
  */
}

int decodeSharp(){              // Devuelve distancia en cm entre 1 y 21 (solo impares)
  int sharpVolt;
  sharpVolt = int(rxBuffer[byteRx] & 0x1F) << 7;
  sharpVolt += int(rxBuffer[1+byteRx] & 0x7F);
  byteRx += 2;
  for(int i=0; i < sharpRef.length-1; i++){
    if((sharpVolt >= sharpRef[i]) && (sharpVolt <= sharpRef[i+1])){
      return 2*i+1;
    }
  }
  return -1;
}
  /**
   * 
   * Asigna el tamaño del buffer para la lectura del siguiente bloque de acuerdo al tipo de encabezado (0xF1, 0xF2).
   * Habilita la lectura del segundo canal analogico y detecta si hay desincronizacion.
   */
void readNextHeader(){
  int nextBS = 1;
  
  if((rxBuffer[bufferSize-1] & 0x80) != 0x80){
    sync = false;
  }
  else{
    if((rxBuffer[bufferSize-1] & 0x40) == 0x40){
      pwmRx = true;
      nextBS += 9;
    }
    
    if((rxBuffer[bufferSize-1] & 0x20) == 0x20){
      sensRx = true;
      nextBS += 3;
    }
    
    if((rxBuffer[bufferSize-1] & 0x10) == 0x10){
      eventRx = true;
      nextBS += 1;
    }
    
    camBytesRx = int(rxBuffer[bufferSize-1] & 0x0F);
    nextBS += camBytesRx;
    
    sharpRx = true;
    nextBS += 2;
  }
  //println("bufferSize = " + bufferSize);
  //println("nextBS = " + nextBS);
  bufferSize = nextBS;
}

void initGUI(){
  cp5.addToggle("on")
   .setPosition(50,50)
   .setSize(40,20)
   ;
    
  // add a vertical slider
  cp5.addSlider("DUTY")
    .setPosition(50,150)
    .plugTo(duty)
    .lock()
    .setSize(300,20)
    .setRange(0,32767)
    ;
  
  // reposition the Label for controller 'slider'
  cp5.getController("DUTY").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("DUTY").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  
    // add a vertical slider
  cp5.addSlider("DUTYSIDE")
     .setPosition(50,200)
     .plugTo(dutySide)
     .setSize(300,20)
     .setRange(-16384,16383)
     .lock()
     ;
  
  // reposition the Label for controller 'slider'
  cp5.getController("DUTYSIDE").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("DUTYSIDE").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
   

  cp5.addSlider("Retroceso derecha")
    .setPosition(50,250)
    .plugTo(M2mTx)
    .lock()
    .setWidth(40)
    .setHeight(20)
    .setRange(0,1) // values can range from big to small as well
    .setNumberOfTickMarks(2)
    .setSliderMode(Slider.FLEXIBLE)
    ;
  cp5.addSlider("Retroceso izquierda")
    .setPosition(250,250)
    .plugTo(M1mTx)
    .lock()
    .setWidth(40)
    .setHeight(20)
    .setRange(0,1) // values can range from big to small as well
    .setNumberOfTickMarks(2)
    .setSliderMode(Slider.FLEXIBLE)
    ;

  cp5.addSlider("mode")
   .setPosition(50,300)
   .setWidth(300)
   .setHeight(20)
   .setRange(0,4) // values can range from big to small as well
   .setNumberOfTickMarks(5)
   .setSliderMode(Slider.FLEXIBLE)
   ;
  
  text("0: Esperando; 1: recoger pelota; 2: recoger multiples pelotas; 3: seguir pelota; 4: volver a la meta",50,335);
}
