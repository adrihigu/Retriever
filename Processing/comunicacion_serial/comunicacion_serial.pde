import processing.serial.*;
import controlP5.*;

public static final int NO_PACK = 0;
public static final int M_PACK = 1;
public static final int C_PACK = 2;

public static final int NO_ARG = 0;
public static final int ONE_ARG = 1;
public static final int TWO_ARG = 2;
public static final int COLOR_ARG = 3;


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
CamPackRes NO_pack = new CamPackRes();
CamPackRes M_pack = new CamPackRes();
CamPackRes C_pack = new CamPackRes();

// Variables de juego
int on = 0;                                // Estado del carrito
int game = 0;                              // Juego actual: 0 -> Buscar pelota; 1 -> Competitivo

// Variables de movimiento
int dutySide = 0;                              // Factor de giro
int duty = 0;                                  // Velocidad de movimiento frontal
int dutyFix = 0;                          // Corrección añadida a la rueda izquierda
boolean M1mTx = false;                             // true: rueda IZQUIERDA en retroceso
boolean M2mTx = false;                             // true: rueda DERECHA en retroceso
// Variables de interfaz de usuario

ControlP5 cp5;
int myColor = color(0,0,0);
PFont font;                                                              // Tipo de letra
int ls = 24;                                                             // Constante para espaciado
boolean manual = true;
double time;

class CamPackRes{
  int mx;
  int my;
  int x1;
  int y1;
  int x2;
  int y2;
  int pix;
  int cnf;
  int camOp;
  boolean readed;
  boolean fail;
  
  CamPackRes() {
    readed = true;
    fail = false;
  }
  
  // Metodos set
  
  void setMx(int newVal){
    mx = newVal;
  }
  void setMy(int newVal){
    my = newVal;
  }
  void setX1(int newVal){
    x1 = newVal;
  }
  void setY1(int newVal){
    y1 = newVal;
  }
  void setX2(int newVal){
    x2 = newVal;
  }
  void setY2(int newVal){
    y2 = newVal;
  }
  void setPix(int newVal){
    pix = newVal;
  }
  void setCnf(int newVal){
    cnf = newVal;
  }
  void setReaded(boolean newVal){
    readed = newVal;
  }
  void setCamOp(int newVal){
    camOp = newVal;
  }
  void setFail(boolean newVal){
    fail = newVal;
  }
  
  // Metodos get
  int getMx(){
    return mx;
  }
  int getMy(){
    return my;
  }
  int getX1(){
    return x1;
  }
  int getY1(){
    return y1;
  }
  int getX2(){
    return x2;
  }
  int getY2(){
    return y2;
  }
  int getPix(){
    return pix;
  }
  int getCnf(){
    return cnf;
  }
  int getCamOp(){
    return camOp;
  }
  boolean isReaded(){
    return(readed);
  }
  boolean isFail(){
    return(fail);
  }
}

void setup(){
  printArray(Serial.list());                                             // Muestra los puertos seriales disponibles
  myPort = new Serial(this, Serial.list()[1], 9620);
  myPort.buffer(bufferSize);                                             // Ajusta el tamaño del buffer serial, por defecto 1

  size(700,400);
  noStroke();
  cp5 = new ControlP5(this);
  
  initRef();
  
  // initGUI
    cp5.addSlider("on")
     .setPosition(50,50)
     .setWidth(40)
     .setHeight(20)
     .setRange(0,1) // values can range from big to small as well
     .setNumberOfTickMarks(2)
     .setSliderMode(Slider.FLEXIBLE)
     ;
     
     cp5.addSlider("game")
     .setPosition(125,50)
     .setWidth(40)
     .setHeight(20)
     .setRange(0,1) // values can range from big to small as well
     .setNumberOfTickMarks(2)
     .setSliderMode(Slider.FLEXIBLE)
     ;
    
  // add a vertical slider
  cp5.addSlider("duty")
    .setPosition(50,150)
    .setSize(300,20)
    .setRange(0,32767)
    ;
  
  // reposition the Label for controller 'slider'
  cp5.getController("duty").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("duty").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  
    // add a vertical slider
  cp5.addSlider("dutySide")
     .setPosition(50,200)
     .setSize(300,20)
     .setRange(-32767,32767)
     ;
  
  // reposition the Label for controller 'slider'
  cp5.getController("dutySide").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("dutySide").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  
    // add a vertical slider
  cp5.addSlider("dutyFix")
     .setPosition(50,250)
     .setSize(300,20)
     .setRange(-32767,32767)
     ;
  
  // reposition the Label for controller 'slider'
  cp5.getController("dutyFix").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("dutyFix").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
      
   cp5.addSlider("Retroceso")
     .setPosition(50,300)
     .plugTo(M1mTx)
     .plugTo(M2mTx)
     .setWidth(40)
     .setHeight(20)
     .setRange(0,1) // values can range from big to small as well
     .setNumberOfTickMarks(2)
     .setSliderMode(Slider.FLEXIBLE)
     ;
     
  if(!manual){
    cp5.getController("duty").lock();
    cp5.getController("dutySide").lock();
    cp5.getController("dutyFix").lock();
    cp5.getController("Retroceso").lock();
  }
}

void draw() {
  background(200);
  if(txOK == false){
    encodeTx();
  }
}

void initRef(){
  float[] sharpBlack = {360,1340,1540,1660,1560,1200,1040,1040,800,660,480,300};  // 20 cm con color negro (mV)
  float[] sharpWhite = {400,1000,1760,1800,1760,1500,1320,1200,1100,860,800,700};  // 20 cm con color blanco (mV)
  
  for(int i = 0 ; i < sharpRef.length; i++){
    sharpRef[i] = ((128/3000) * (sharpBlack[i] + sharpWhite[i])/2);
  }
}

void drawRx(){
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
  txBuffer[byteTx] = byte( (on << 6) + (game  << 5) + (((sync) ? 1 : 0) << 4) + (((e3Tx) ? 1 : 0) << 3) + (((e2Tx) ? 1 : 0) << 2) + (((e1Tx) ? 1 : 0) << 1) + ((e0Tx) ? 1 : 0) );
  byteTx++;
}

// SIN IMPLEMENTAR

void encodeCam(){
  int camOp = 0;
  int camArg= 0;
  
  if(NO_pack.isFail()){
    camOp = NO_pack.getCamOp();
  }
  if(M_pack.isFail()){
    camOp = M_pack.getCamOp();
  }
  if(C_pack.isFail()){
    camOp = C_pack.getCamOp();
  }
  
  txBuffer[byteTx] = byte( ((camOp & 0x0F) << 4) + camArg);
  byteTx++;
  
  switch(camArg){
    case 0: //NO_ARG:
      
      break;
    case 1: //ONE_ARG:
      
      break;
    case 2: //TWO_ARG:
      
      break;
    case 3: //COLOR_ARG:
      
      break;
    default:
      break;
    
  }

}

//*********************************************** RECEPCION DE DATOS ***************************************************//
 
void serialEvent(Serial myPort) {
  println("SERIAL");
               // CUIDADO: CONSIDERAR SINCRONIZACION
  if(txOK){    // Si los datos para el envio estan listos...
    myPort.write(txBuffer);
    txOK = false;
  }
  
  byteRx = 0;
  //println("sync = " + sync);
  myPort.readBytes(rxBuffer);                  // Lectura del buffer de entrada
  //println("rxBuffer = ");
  //printArray(rxBuffer);
  syncronize();                                // Verifica si el buffer está sincronizado
  if(sync){
    if(rxBuffer[0] >= 0){                      // Si hay sincronizacion y si no se está leyendo un encabezado...
      println("----NUEVO PAQUETE----" + onRx);
      if(pwmRx){
        decodePWM();                           // Decodifica las señales de los PWM: M1+, M1-, M2+ ,M2-
        println("duty = " + dutyRx);
        println("dutySide = " + dutySideRx);
        println("dutyFix = " + dutyFixRx);
        println("M1m = " + M1mRx);
        println("M2m = " + M2mRx);
      }
      
      if(sensRx){        
        decodeSens();                          // Decodifica los sensores digitales y la medida del potenciómetro (10 bits)
        println("dig1 = " + dig1);
        println("dig2 = " + dig2);
        println("dig3 = " + dig3);
        println("dig4 = " + dig4);
        println("pot = " + pot);
      }
      
      if(eventRx){        
        decodeEvent();                         // Decodifica los eventos
        println("on = " + onRx);
        println("game = " + gameRx);
        println("e0Rx = " + e0Rx);
        println("e1Rx = " + e1Rx);
        println("e2Rx = " + e2Rx);
        println("e3Rx = " + e3Rx);
        println("e4Rx = " + e4Rx);
      }
      
      if(camBytesRx != 0 ){
        decodeCam();                           // Decodifica los resultados de la CMUcam
      }
      
      println("sharpVolt = " + (rxBuffer[byteRx] & 0x7F));
      sharpBuffer.append(decodeSharp());    // Decodifica la señal del infrarrojo (7 bits)

      if(sharpBuffer.size() > 100){
        sharpBuffer.remove(0);
      }
      println("sharpDist = " + sharpBuffer.get(sharpBuffer.size()-1));
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
  int pack;
  int camOp;
  boolean CK;

  camOp = ((rxBuffer[byteRx] & 0x78) >> 3);
  CK = ((rxBuffer[byteRx] & 0x04) == 0x04) ? true : false;
  pack = rxBuffer[byteRx] & 0x03;
  byteRx += 1;
  switch(pack){
    case NO_PACK:
      if(!CK){NO_pack.setFail(true);}else{
        NO_pack.setReaded(false);
      }
      NO_pack.setCamOp(camOp);
      break;
    case M_PACK:
      if(!CK){M_pack.setFail(true);}else{
        M_pack.setMx((rxBuffer[byteRx] << 1) + (rxBuffer[byteRx + 8] & 0x40) >> 6);
        M_pack.setMy((rxBuffer[byteRx+1] << 1) + (rxBuffer[byteRx + 8] & 0x20) >> 5);
        M_pack.setX1((rxBuffer[byteRx+2] << 1) + (rxBuffer[byteRx + 8] & 0x10) >> 4);
        M_pack.setY1((rxBuffer[byteRx+3] << 1) + (rxBuffer[byteRx + 8] & 0x08) >> 3);
        M_pack.setX2((rxBuffer[byteRx+4] << 1) + (rxBuffer[byteRx + 8] & 0x04) >> 2);
        M_pack.setY2((rxBuffer[byteRx+5] << 1) + (rxBuffer[byteRx + 8] & 0x02) >> 1);
        M_pack.setPix((rxBuffer[byteRx+6] << 1) + (rxBuffer[byteRx + 8] & 0x01));
        M_pack.setCnf((rxBuffer[byteRx+7] << 1));
        byteRx += 9;
        M_pack.setReaded(false);
      }
      M_pack.setCamOp(camOp);
      break;
    case C_PACK:
      if(!CK){C_pack.setFail(true);}else{
        C_pack.setX1((rxBuffer[byteRx] << 1) + (rxBuffer[byteRx + 6] & 0x20) >> 5);
        C_pack.setY1((rxBuffer[byteRx+1] << 1) + (rxBuffer[byteRx + 6] & 0x10) >> 4);
        C_pack.setX2((rxBuffer[byteRx+2] << 1) + (rxBuffer[byteRx + 6] & 0x08) >> 3);
        C_pack.setY2((rxBuffer[byteRx+3] << 1) + (rxBuffer[byteRx + 6] & 0x04) >> 2);
        C_pack.setPix((rxBuffer[byteRx+4] << 1) + (rxBuffer[byteRx + 6] & 0x02) >> 1);
        C_pack.setCnf((rxBuffer[byteRx+5] << 1) + (rxBuffer[byteRx + 6] & 0x01));
        byteRx += 7;
        C_pack.setReaded(false);
      }
      C_pack.setCamOp(camOp);
      break;
    default:
      break;
  }
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

  /**
   * PENDIENTE ENVIO SERIAL DE LA CAMARA
   * Interrupción por teclado para la barra espaciadora (caracter " ")
   * Detiene o arranca el procesamiento de datos al presionar la barra espaciadora.
   */
