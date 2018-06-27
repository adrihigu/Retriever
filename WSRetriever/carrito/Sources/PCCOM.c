#include "PCCOM.h"
#include "AS1.h"

void print(char *text){
  unsigned short count = 0;
  while(text[count] != '\0'){
    AS1_SendChar(text[count++]);
  };
}

void printLn(char *text){
  unsigned short count = 0;
  while(text[count] != '\0'){
    AS1_SendChar(text[count++]);
  };
  AS1_SendChar('\n');
  AS1_SendChar('\r');
}

void printNumLn(int num, char* buf){
  unsigned short count = 0;
  char jejexd =buf[0];
  itoa(num, buf, 10);
  while(buf[count] != '\0'){
    jejexd = buf[count];
	AS1_SendChar(buf[count++]);
  };
  AS1_SendChar('\n');
  AS1_SendChar('\r');
}

void printNum(int num, char* buf){
  unsigned short count = 0;
  char jejexd =buf[0];
  itoa(num, buf, 10);
  while(buf[count] != '\0'){
    jejexd = buf[count];
  AS1_SendChar(buf[count++]);
  };
}
// Implementation of itoa()
void itoa(int num, char* str, int base)
{
    int i = 0;
    bool isNegative = FALSE;
  
    int start;
    int end;
    char temp;

    /* Handle 0 explicitely, otherwise empty string is printed for 0 */
    if (num == 0)
    {
        str[i++] = '0';
        str[i] = '\0';
        return;
    }
 
    // In standard itoa(), negative numbers are handled only with 
    // base 10. Otherwise numbers are considered unsigned.
    if (num < 0 && base == 10)
    {
        isNegative = TRUE;
        num = -num;
    }
 
    // Process individual digits
    while (num != 0)
    {
        int rem = num % base;
        str[i++] = (rem > 9)? (rem-10) + (int)'a' : rem + (int)'0';
        num = num/base;
    }
 
    // If number is negative, append '-'
    if (isNegative)
        str[i++] = '-';
 
    str[i] = '\0'; // Append string terminator
 
    // Reverse the string
    //reverse(str, i);
    start = 0;
    end = --i;
    while(start <= end){
      temp = str[start];
      str[start] = str[end];
      str[end] = temp;
      start++;
      end--;
    }
    return;
}
