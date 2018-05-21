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
int M1p = 0;
int M2p = 0;
boolean M1m = false;
boolean M2m = false;
boolean camBusy;                                                        // Indica si la camara está ocupada
boolean pwmRx = true;
boolean sensRx = true;
boolean eventRx = true;
boolean camRx = false;
boolean sharpRx = true;
boolean onRx;
boolean gameRx;
boolean e4Rx;                                                            // Indica si la recepción del DEMO está sincronizada 
boolean e3Rx;
boolean e2Rx;
boolean e1Rx;
boolean e0Rx;
boolean dig1=false;                                                      // Sensor digital 1
boolean dig2=false;                                                      // Sensor digital 2
boolean dig3=false;                                                      // Sensor digital 3
boolean dig4=false;                                                      // Sensor digital 4
boolean sync=false;                                                    // Indica si la comunicacion serial esta sincronizada
IntList sharpBuffer = new IntList();

// Variables de transmision de datos
byte[] txBuffer= new byte[32];
boolean pwmTx;
boolean sensTx;
boolean eventTx;
boolean camTx;
int camBytesTx;                                                      // Numero de argumentos para la camara + encabezado
boolean e4Tx;                                                            // Indica si la recepción del DEMO está sincronizada 
boolean e3Tx;
boolean e2Tx;
boolean e1Tx;
boolean e0Tx;
int camOPTx;

// Variables de juego
boolean on;                                // Estado del sistema
boolean game;                              // Juego actual

// Variables de detección de tono
int dataSize = 512;                                                      // Cantidad de datos a procesar por el algoritmo YIN
int refSize = int(dataSize/60) + 1;                                      // Cantidad de muestras para referencia del potenciómetro
float sampleRate = 3640.89158153;                                        // Frecuencia de muestreo
float myPitch;                                                           // Resultado de la detección de frecuencia
IntList pitchBuffer = new IntList();                                     // Guarda los tonos detectados

// Variables de interfaz de usuario
PFont font;                                                              // Tipo de letra
int ls = 24;                                                             // Constante para espaciado
int[] refTone = new int[1];                                              // El tono asociado a la medida del potenciómetro
int refVolt = 2350;                                                      // Maxima excursion de voltaje que ofrece el potenciometro
int mode;                                                                // Modo de operacion del afinador
int holdTone;                                                            // Tono mantenido para el modo HOLD
FloatList refFrec = new FloatList();                                     // Lista de las frecuencias que se usan para delimitar los tonos musicales
float xLevels = 50;                                                      // Número máximo de rectangulos en la gráfica = Resolución en X
float yLevels;                                                           // Cantidad de tonos = Resolución en Y
float rectWidth;                                                         // Ancho de rectángulos
float rectHeight;                                                        // Alto de rectángulos
String modeMsg = "";                                                     // Mensaje del modo de operación
String down = "02C5";                                                    // Caracter Unicode. Flecha hacia abajo
String up = "02C4";                                                      // Caracter Unicode. Flecha hacia arriba
boolean stop=false;                                                      // Cuando es true, deja de dibujar
float xLabel, yLabel;                                                    // Longitud de los ejes X e Y
float xLength, yLength;                                                  // Espacio entre puntos del eje X e Y

void setup(){
  size(600,500);                                                        // Inicializa el tamaño de la ventana
  background(255);
  sharpBuffer.append(15);
  textSize(18);
//CMUCam carCam = new CMUCam();                                            // Ajusta el tamaño del buffer serial, por defecto 1
  initRef();
}

void draw() {
  background(255);
  drawRx();
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
  int byteTx;
  byteTx = 0;
  txBuffer[0] = byte((1 << 7) + (((pwmTx) ? 1 : 0) << 6) + (((sensTx) ? 1 : 0) << 5) + (((eventTx) ? 1 : 0) << 4) + camBytesTx & 0x000F);
  byteTx++;
  if(eventTx){
    txBuffer[byteTx] = byte((((on) ? 1 : 0) << 6) + (((game) ? 1 : 0) << 5) + (((e4Tx) ? 1 : 0) << 4) + (((e3Tx) ? 1 : 0) << 3) + (((e2Tx) ? 1 : 0) << 2) + (((e1Tx) ? 1 : 0) << 1) + ((e0Tx) ? 1 : 0));
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

//*********************************************** RECEPCION DE DATOS ***************************************************//
 
void serialEvent(Serial myPort) { 
  byteRx = 0;
  println("sync = " + sync);
  myPort.readBytes(rxBuffer);                  // Lectura del buffer de entrada
  println("rxBuffer = ");
  printArray(rxBuffer);
  syncronize();                                // Verifica si el buffer está sincronizado
  if(sync){
    if(rxBuffer[0] >= 0){                      // Si hay sincronizacion y si no se está leyendo un encabezado...
    byteRx += 1;
      if(pwmRx){
        decodePWM();                           // Decodifica las señales de los PWM: M1+, M1-, M2+ ,M2-
      }
      if(sensRx){        
        decodeSens();                          // Decodifica los sensores digitales y la medida del potenciómetro (10 bits)
      } 
      if(eventRx){        
        decodeEvent();                         // Decodifica los eventos
      } 
      if(camRx){
        decodeCam();                           // Decodifica los resultados de la CMUcam
      }
      if(sharpRx){
        sharpBuffer.append(decodeSharp());    // Decodifica la señal del infrarrojo (7 bits)
        if(sharpBuffer.size() > 100){
          sharpBuffer.remove(0);
        }
      }
    }
  }
    if(sync){
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

int decodeSharp(){              // Devuelve distancia en cm entre 1 y 21 (solo impares)
  int sharpVolt;
  sharpVolt = rxBuffer[byteRx] & 0x7F;
  byteRx += 1;
  for(int i=0; i < sharpRef.length -1; i++){
    if((sharpVolt >= sharpRef[i]) && (sharpVolt <= sharpRef[i+1])){
      return 2*i+1;
    }
  }
  return -1;
}

void decodePWM(){
  M1m = ((rxBuffer[byteRx] & 0x20) == 0x20) ? true : false;
  M2m = ((rxBuffer[byteRx] & 0x10) == 0x10) ? true : false;
  M1p = ((rxBuffer[byteRx] & 0x07) << 12) + ((rxBuffer[byteRx+1] & 0x7F) << 5) + ((rxBuffer[byteRx+2] & 0x7C) >> 2);
  M2p = ((rxBuffer[byteRx+2] & 0x03) << 14) + ((rxBuffer[byteRx+3] & 0x7F) << 7) + (rxBuffer[byteRx+4] & 0x7F);
  byteRx += 5;
}

void decodeSens(){
  dig1 = ((rxBuffer[byteRx] & 0x40) == 0x40) ? true : false;
  dig2 = ((rxBuffer[byteRx] & 0x20) == 0x20) ? true : false;
  dig3 = ((rxBuffer[byteRx] & 0x10) == 0x10) ? true : false;
  dig4 = ((rxBuffer[byteRx] & 0x08) == 0x08) ? true : false;
  pot = ((rxBuffer[byteRx] & 0x07) << 9) + ((rxBuffer[byteRx+1] & 0x08) << 2);
  byteRx += 2;
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
  
  if(ACK){
    /*
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
    */
  }
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
      sharpRx = true;
      nextBS += 1;
      
    if((rxBuffer[bufferSize-1] & 0x40) == 0x40){
      pwmRx = true;
      nextBS += 5;
    }
    
    if((rxBuffer[bufferSize-1] & 0x20) == 0x20){
      sensRx = true;
      nextBS += 2;
    }
    
    if((rxBuffer[bufferSize-1] & 0x10) == 0x10){
      eventRx = true;
      nextBS += 1;
    }
    
    if((rxBuffer[bufferSize-1] & 0x0F) != 0x00){
      camRx = true;
      camBytesRx = int(rxBuffer[bufferSize-1] & 0x0F);
      nextBS += camBytesRx;
    }
  }
  println("bufferSize = " + bufferSize);
  println("nextBS = " + nextBS);
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