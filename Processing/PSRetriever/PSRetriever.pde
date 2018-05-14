import processing.serial.*;

// Variables de recepcion de datos
Serial myPort;                                                           // Puerto Serial
byte[] inBuffer= new byte[5];                                            // Bytes de entrada del puerto serial
int pot = 0;                                                             // medida del potenciometro
int bufferSize=1;                                                        // Tamaño del buffer de entrada
int baudRate = 9600;
int[] sharpRef = {0}; // INTRODUCIR VALORES
int byteRx;
int n;                                                                   // Numero de asciis del resultado de la camara
int M1p;
int M2p;
boolean M1m;
boolean M2m;
boolean camBusy;                                                        // Indica si la camara está ocupada
boolean pwmRx = false;
boolean sensRx = false;
boolean eventRx = false;
boolean camRx = false;
boolean sharpRx = false;
boolean onRx;
boolean gameRx;
boolean e4Rx;
boolean e3Rx;
boolean e2Rx;
boolean e1Rx;
boolean e0Rx;
boolean dig1=false;                                                      // Sensor digital 1
boolean dig2=false;                                                      // Sensor digital 2
boolean dig3=false;                                                      // Sensor digital 3
boolean dig4=false;                                                      // Sensor digital 4
boolean sync=false;                                                    // Indica si la comunicacion serial esta sincronizada
boolean ADC2=false;                                                      // Indica si hay datos por recibir del can//al de adquisición 2
IntList sharpBuffer = new IntList();

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
int refVolt = 2350;                                                       // Maxima excursion de voltaje que ofrece el potenciometro
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
  size(1024,700);                                                        // Inicializa el tamaño de la ventana
  printArray(Serial.list());                                             // Muestra los puertos seriales disponibles
//CMUCam carCam = new CMUCam();
  myPort = new Serial(this, Serial.list()[0], baudRate);                   // Inicializa el puerto usado para recepción serial
  myPort.buffer(bufferSize);                                             // Ajusta el tamaño del buffer serial, por defecto 1
}

void draw() {
println("DRAW");
}

//*********************************************** RECEPCION DE DATOS ***************************************************//
 
void serialEvent(Serial myPort) { 
  byteRx = 0;
  myPort.readBytes(inBuffer);                  // Lectura del buffer de entrada
  println("inBuffer = ");
  printArray(inBuffer);
  syncronize();                                // Verifica si el buffer está sincronizado
  if(sync){
    if(inBuffer[0] >= 0){                      // Si hay sincronizacion y si no se está leyendo un encabezado...
    byteRx += 1;
      if(sharpRx){
        sharpBuffer.append(decodeSharp());// Decodifica la señal del infrarrojo (7 bits)
        if(sharpBuffer.size() > 100){
          sharpBuffer.remove(0);
        }
      }
      if(pwmRx){
        decodePWM();                           // Decodifica las señales de los PWM: M1+, M1-, M2+ ,M2-
      }
      if(sensRx){        
        decodeSens();                          // Decodifica los sensores digitales y la medida del potenciómetro (10 bits)
      } 
      if(eventRx){        
        decodeEvent();                         // Decodifica los eventos
      } 
      camRx = false; ////////////////////////////QUITAR
      if(camRx){
        decodeCam();                           // Decodifica los resultados de la CMUcam
      } 
    }                                  
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
    if((inBuffer[0] & 0x80) == 0x80){
      sync=true;
    }
  }
}

int decodeSharp(){              // Devuelve distancia en cm entre 1 y 21 (solo impares)
  int sharpVolt;
  sharpVolt = inBuffer[byteRx] & 0x7F;
  byteRx += 1;
  for(int i=0; i < sharpRef.length -1; i++){
    if((sharpVolt >= sharpRef[i]) && (sharpVolt <= sharpRef[i+1])){
      return 2*i+1;
    }
  }
  return -1;
}

void decodePWM(){
  M1m = ((inBuffer[byteRx] & 0x20) == 0x20) ? true : false;
  M2m = ((inBuffer[byteRx] & 0x10) == 0x10) ? true : false;
  M1p = ((inBuffer[byteRx] & 0x07) << 12) + ((inBuffer[byteRx+1] & 0x7F) << 5) + ((inBuffer[byteRx+2] & 0x7C) >> 2);
  M2p = ((inBuffer[byteRx+2] & 0x03) << 14) + ((inBuffer[byteRx+3] & 0x7F) << 7) + (inBuffer[byteRx+4] & 0x7F);
  byteRx += 5;
}

void decodeSens(){
  dig1 = ((inBuffer[byteRx] & 0x40) == 0x40) ? true : false;
  dig2 = ((inBuffer[byteRx] & 0x20) == 0x20) ? true : false;
  dig3 = ((inBuffer[byteRx] & 0x10) == 0x10) ? true : false;
  dig4 = ((inBuffer[byteRx] & 0x08) == 0x08) ? true : false;
  pot = ((inBuffer[byteRx] & 0x07) << 9) + ((inBuffer[byteRx+1] & 0x08) << 2);
  byteRx += 2;
}

void decodeEvent(){
  onRx = ((inBuffer[byteRx] & 0x40) == 0x40) ? true : false;
  gameRx = ((inBuffer[byteRx] & 0x20) == 0x20) ? true : false;
  e4Rx = ((inBuffer[byteRx] & 0x10) == 0x10) ? true : false;
  e3Rx = ((inBuffer[byteRx] & 0x08) == 0x08) ? true : false;
  e2Rx = ((inBuffer[byteRx] & 0x04) == 0x04) ? true : false;
  e1Rx = ((inBuffer[byteRx] & 0x02) == 0x02) ? true : false;
  e0Rx = ((inBuffer[byteRx] & 0x01) == 0x01) ? true : false;
  byteRx += 1;
}

void decodeCam(){ // OP: \r (stop stream) = 1, CR (change register) = 2,  GM (Get the Mean color) = 3, MM (Middle Mass) = 4, SW (Set Window) = 5, TC (Track a Color) = 6
  int pack, opCam;
  boolean ACK;
  opCam = ((inBuffer[byteRx] & 0x70) >> 4);
  pack = (inBuffer[byteRx] & 0x0C) >> 2;
  camBusy = ((inBuffer[byteRx] & 0x02) == 0x02) ? true : false;
  ACK = ((inBuffer[byteRx] & 0x01) == 0x01) ? true : false;
  
  if(ACK){
    /*
    switch(pack){
    case 1:
      packageS(inBuffer,n,opCam);
      break;
    case 2:
      packageC(inBuffer,n,opCam);
      break;
    case 3:
      packageM(inBuffer,n,opCam);
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
  
  if((inBuffer[bufferSize-1] & 0x80) != 0x80){
    sync = false;
  }
  else{
      sharpRx = true;
      nextBS += 1;
      
    if((inBuffer[bufferSize-1] & 0x40) == 0x40){
      pwmRx = true;
      sensRx = true;
      nextBS += 5;
      nextBS += 2;
    }
    if((inBuffer[bufferSize-1] & 0x20) == 0x20){
      eventRx = true;
      nextBS += 1;
    }
    if((inBuffer[bufferSize-1] & 0x1F) != 0x00){
      camRx = true;
      n = int(inBuffer[bufferSize-1] & 0x1F);
      nextBS += n;
    }
  }
  
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