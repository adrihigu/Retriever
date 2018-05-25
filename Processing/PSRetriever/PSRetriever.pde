import processing.serial.*;

// Variables de recepcion de datos
Serial myPort;                                                           // Puerto Serial
byte[] rxBuffer= new byte[32];                                            // Bytes de entrada del puerto serial
int pot = 0;                                                             // medida del potenciometro
int bufferSize=1;                                                        // Tamaño del buffer de entrada
int baudRate = 9620;
float[] sharpRef = new float[11]; // INTRODUCIR VALORES
int byteRx;
int camBytesRx;                                                          // Numero de argumentos del resultado de la camara + encabezado
int M1p;
int M2p;
boolean M1m;
boolean M2m;
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
int camBytesTx;                                                                 // Numero de argumentos para la camara + encabezado
int camOPTx;


// Variables de juego
boolean on;                                // Estado del sistema
boolean game;                              // Juego actual
int dutySide;                              // Factor de giro
int duty;                                  // Velocidad de movimiento frontal
int leftDuty = 0;                          // Corrección añadida a la rueda izquierda

// Variables de interfaz de usuario
PFont font;                                                              // Tipo de letra
int ls = 24;                                                             // Constante para espaciado

void setup(){
  size(100,70);                                                        // Inicializa el tamaño de la ventana
  background(255);
  printArray(Serial.list());                                             // Muestra los puertos seriales disponibles
//CMUCam carCam = new CMUCam();
  myPort = new Serial(this, Serial.list()[0], baudRate);                 // Inicializa el puerto usado para recepción serial
  myPort.buffer(bufferSize);                                             // Ajusta el tamaño del buffer serial, por defecto 1
  initRef();
}

void draw() {
  background(255);
  //drawRx();
}

void initRef(){
  float[] sharpBlack = {360,1340,1540,1660,1560,1200,1040,1040,800,660,480,300};  // 20 cm con color negro (mV)
  float[] sharpWhite = {400,1000,1760,1800,1760,1500,1320,1200,1100,860,800,700};  // 20 cm con color blanco (mV)
  
  for(int i = 0 ; i < sharpRef.length; i++){
    sharpRef[i] = ((128/3000) * (sharpBlack[i] + sharpWhite[i])/2);
  }
}

void drawRx(){
  fill(50);
  text("Estado del carrito: " + ((onRx) ? "ENCENDIDO" : "APAGADO") + "; Juego: " + ((gameRx) ? "BUSCAR PELOTA" : "AGRUPAR PELOTAS"), ls, ls);
  text("Distancia: " + sharpBuffer.get(sharpBuffer.size()-1) + "cm", ls, 2* ls);
  text("M1+: " + M1p + "   M1-: " + M1m + "  (Izquierdo)", ls, 3 * ls);
  text("M2+: " + M2p + "   M2-: " + M2m + "  (Derecho)", ls, 4 * ls);
  text("Dig1: " + dig1 + "   Dig2: " + dig2 + "   Dig3: " + dig3 + "   Dig4: " + dig4, ls, 5 * ls);
  text("Potenciómetro = " + pot, ls, 6 * ls);
}

void PC2DemoQE(){
  byteTx = 0;
  camTx = false;
  eventTx = true;
  
  txBuffer[0] = byte((1 << 7) + (((askTx) ? 1 : 0) << 6) + (((movTx) ? 1 : 0) << 5) + (((eventTx) ? 1 : 0) << 4) + camBytesTx & 0x000F);
  byteTx++;
  
  if(movTx){
    encodeMov();
  }
  
  if(eventTx){
    txBuffer[byteTx] = byte((((on) ? 1 : 0) << 6) + (((game) ? 1 : 0) << 5) + (((sync) ? 1 : 0) << 4) + (((e3Tx) ? 1 : 0) << 3) + (((e2Tx) ? 1 : 0) << 2) + (((e1Tx) ? 1 : 0) << 1) + ((e0Tx) ? 1 : 0));
    byteTx++;
  }
  
  if(camTx){
    txBuffer[byteTx] = byte(((camOPTx & 0x0007) << 4) + (camBytesTx & 0x000F) + 1);
    byteTx++;
    for(int i = 0; i < camBytesTx -1; i++){
    // txBuffer[byteTx] = ARREGLO DE ARGUMENTOS DE LA INSTRUCCION[i]
      byteTx++;
    }
  }
  myPort.write(txBuffer);
}

void encodeMov(){
    txBuffer[byteTx] = byte((dutySide & 0x000C000) >> 14);
    txBuffer[byteTx+1] = byte((dutySide & 0x00003F80) >> 7);
    txBuffer[byteTx+2] = byte(dutySide & 0x0000007F);
    txBuffer[byteTx+3] = byte((duty & 0x000C000) >> 14);
    txBuffer[byteTx+4] = byte((duty & 0x00003F80) >> 7);
    txBuffer[byteTx+5] = byte(duty & 0x0000007F);
    txBuffer[byteTx+6] = byte((leftDuty & 0x000C000) >> 14);
    txBuffer[byteTx+7] = byte((leftDuty & 0x00003F80) >> 7);
    txBuffer[byteTx+8] = byte(leftDuty & 0x0000007F);
    byteTx += 9;
}

void encodeCam(){
  txBuffer[byteTx] = byte(((camOPTx & 0x00000007) << 4) + (camBytesTx & 0x0000000F));
  /*
  camArg
  */
  
}

//*********************************************** RECEPCION DE DATOS ***************************************************//
 
void serialEvent(Serial myPort) {
  byteRx = 0;
  //println("sync = " + sync);
  myPort.readBytes(rxBuffer);                  // Lectura del buffer de entrada
  //println("rxBuffer = ");
  //printArray(rxBuffer);
  syncronize();                                // Verifica si el buffer está sincronizado
  if(sync){
    if(rxBuffer[0] >= 0){                      // Si hay sincronizacion y si no se está leyendo un encabezado...
    byteRx += 0;
      if(pwmRx){
        decodePWM();                           // Decodifica las señales de los PWM: M1+, M1-, M2+ ,M2-
        println("duty = " + M1p);
        println("M1- = " + M1m);
        println("dutySide = " + M2p);
        println("M2- = " + M2m);
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

      decodeCam();                           // Decodifica los resultados de la CMUcam
      
      if(sharpRx){
        println("sharpVolt = " + (rxBuffer[byteRx] & 0x7F));
        sharpBuffer.append(decodeSharp());    // Decodifica la señal del infrarrojo (7 bits)

        if(sharpBuffer.size() > 100){
          sharpBuffer.remove(0);
        }
        println("sharpDist = " + sharpBuffer.get(sharpBuffer.size()-1));
      }
    }
  }
    if(sync){
      //println("NXTHeader = " + rxBuffer[bufferSize-1]);
      readNextHeader();                        // Lee el encabezado del siguiente bloque
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
  M1m = ((rxBuffer[byteRx] & 0x20) == 0x20) ? true : false;
  M2m = ((rxBuffer[byteRx] & 0x10) == 0x10) ? true : false;
  M1p = ((rxBuffer[byteRx] & 0x07) << 12) + ((rxBuffer[byteRx+1] & 0x7F) << 5) + ((rxBuffer[byteRx+2] & 0x7C) >> 2);
  M2p = ((rxBuffer[byteRx+2] & 0x03) << 14) + ((rxBuffer[byteRx+3] & 0x7F) << 7) + (rxBuffer[byteRx+4] & 0x7F);
  M2p += (((M2p & 0x00008000) == 0x00008000) ? 0xFFFF0000 : 0);
  byteRx += 5;
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

// INCOMPLETO
void decodeCam(){ // OP: \r (stop stream) = 1, CR (change register) = 2,  GM (Get the Mean color) = 3, MM (Middle Mass) = 4, SW (Set Window) = 5, TC (Track a Color) = 6
  int pack, opCam;
  boolean ACK;
  opCam = ((rxBuffer[byteRx] & 0x70) >> 4);
  pack = (rxBuffer[byteRx] & 0x0C) >> 2;
  camBusy = ((rxBuffer[byteRx] & 0x02) == 0x02) ? true : false;
  ACK = ((rxBuffer[byteRx] & 0x01) == 0x01) ? true : false;
  byteRx += 1;
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
      nextBS += 5;
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
   * 
   * Interrupción por teclado para la barra espaciadora (caracter " ")
   * Detiene o arranca el procesamiento de datos al presionar la barra espaciadora.
   */
void keyPressed(){
    if(key == 32){
      stop = !stop;
    }
    
}