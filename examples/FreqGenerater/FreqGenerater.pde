#include <FrequencyTimer2.h>

void setup() {
  pinMode(11,OUTPUT);

  Serial.begin(19200);
  delay(2);
  Serial.print("Ready");

  FrequencyTimer2::setPeriod(200);
  FrequencyTimer2::enable();
}

long burpCount = 0;
void Burp(void) {
  burpCount++;
}

void loop() {
  static unsigned long v = 0;
  if ( Serial.available()) {
    char ch = Serial.read();
    switch(ch) {
      case '0'...'9':
        v = v * 10 + ch - '0';
        break;
      case 'p':
        FrequencyTimer2::setPeriod(v);
        Serial.print("set ");
        Serial.print((long)v, DEC);
        Serial.print(" = ");
        Serial.print((long)FrequencyTimer2::getPeriod(), DEC);
        Serial.println();
        v = 0;
        break;
      case 'e':
        FrequencyTimer2::enable();
        break;
      case 'd':
        FrequencyTimer2::disable();
        break;
      case 'o':
        FrequencyTimer2::setOnOverflow( Burp);
        break;
      case 'n':
        FrequencyTimer2::setOnOverflow(0);
        break;
      case 'b':
        Serial.println(burpCount,DEC);
        break;
      case 'x':
#if defined(__AVR_ATmega168__) || defined(__AVR_ATmega328P__)
        Serial.print("TCCR2A:");
        Serial.println(TCCR2A,HEX);        
        Serial.print("TCCR2B:");
        Serial.println(TCCR2B,HEX);
        Serial.print("OCR2A:");
        Serial.println(OCR2A,HEX);
#else
        Serial.print("TCCR2:");
        Serial.println(TCCR2,HEX);
        Serial.print("OCR2:");
        Serial.println(OCR2,HEX);
#endif
        Serial.print("TCNT2:");
        Serial.println(TCNT2,HEX);

        break;
    }
  }
}
