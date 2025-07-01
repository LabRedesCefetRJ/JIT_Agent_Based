// RFID Readers RDM6300 and RDM630 (Arduino-Tutorial)
// (c) Michael Schoeffler 2018, 
// https://mschoeffler.com/2018/01/05/arduino-tutorial-how-to-use-the-rdm630-rdm6300-rfid-reader/
// https://www.youtube.com/watch?v=l8RDbHd1cak
#include <SoftwareSerial.h>
#include <Javino.h>		// https://javino.chon.group
Javino javino;

const int BUFFER_SIZE = 14; 		// RFID DATA FRAME FORMAT: 1byte head (value: 2), 10byte data (2byte version + 8byte tag), 2byte checksum, 1byte tail (value: 3)
const int DATA_SIZE = 10; 		// 10byte data (2byte version + 8byte tag)
const int DATA_VERSION_SIZE = 2;// 2byte version (actual meaning of these two bytes may vary)
const int DATA_TAG_SIZE = 8; 	// 8byte tag
const int CHECKSUM_SIZE = 2; 	// 2byte checksum

SoftwareSerial rfidReader = SoftwareSerial(11,12); 

uint8_t buffer[BUFFER_SIZE]; // used to store an incoming data frame 
int buffer_index = 0;

void serialEvent(){
  javino.readSerial();
}

void setup() {
 pinMode(13,OUTPUT);
 pinMode(12,OUTPUT);
 digitalWrite(12,LOW); 
 rfidReader.begin(9600);
 javino.start(9600);
 javino.perceive(getRFIDPerceptions);

}

void loop(){
	javino.run();
	readInput();

}

/* 
  It sends the exogenous environment's perceptions to the agent. 
*/
void getRFIDPerceptions(){ 
    javino.addPercept("device(rfidReader)");
}

/* It implements the commands to be executed in the exogenous environment. 
*
* NOTE: Every command must reflect in a function. 
*
*/

void readInput() {
	rfidReader.listen();  
  if (rfidReader.available() > 0){
	digitalWrite(13,HIGH);
	digitalWrite(12,HIGH);      
    bool call_extract_tag = false;
    int ssvalue = rfidReader.read(); // read 
    if (ssvalue == -1) { // no data was read
      return;
    }
    if (ssvalue == 2) { // RDM630/RDM6300 found a tag => tag incoming 
      buffer_index = 0;
    } else if (ssvalue == 3) { // tag has been fully transmitted       
      call_extract_tag = true; // extract tag at the end of the function call
    }
    if (buffer_index >= BUFFER_SIZE) { // checking for a buffer overflow (It's very unlikely that an buffer overflow comes up!)
		digitalWrite(13,LOW);      
		digitalWrite(12,LOW);      
		return;
    }
    buffer[buffer_index++] = ssvalue; // everything is alright => copy current value to buffer
    if (call_extract_tag == true) {
      if (buffer_index == BUFFER_SIZE) {
		javino.addPercept("newTag("+String(millis())+","+String(extract_tag())+")");
		digitalWrite(13,LOW);      
		digitalWrite(12,LOW);      
      } else { // something is wrong... start again looking for preamble (value: 2)
        buffer_index = 0;
        return;
      }
    }    
  }    
}

long extract_tag() {
    uint8_t msg_head = buffer[0];
    uint8_t *msg_data = buffer + 1; // 10 byte => data contains 2byte version + 8byte tag
    uint8_t *msg_data_version = msg_data;
    uint8_t *msg_data_tag = msg_data + 2;
    uint8_t *msg_checksum = buffer + 11; // 2 byte
    uint8_t msg_tail = buffer[13];

    long checksum = 0;
    for (int i = 0; i < DATA_SIZE; i+= CHECKSUM_SIZE) {
      long val = hexstr_to_value(msg_data + i, CHECKSUM_SIZE);
      checksum ^= val;
    }

    if (checksum == hexstr_to_value(msg_checksum, CHECKSUM_SIZE)) { // compare calculated checksum to retrieved checksum  
    	return hexstr_to_value(msg_data_tag, DATA_TAG_SIZE);
    }else{
		return 0;
	}
}

long hexstr_to_value(char *str, unsigned int length) { // converts a hexadecimal value (encoded as ASCII string) to a numeric value
  char* copy = malloc((sizeof(char) * length) + 1); 
  memcpy(copy, str, sizeof(char) * length);
  copy[length] = '\0'; 
  // the variable "copy" is a copy of the parameter "str". "copy" has an additional '\0' element to make sure that "str" is null-terminated.
  long value = strtol(copy, NULL, 16);  // strtol converts a null-terminated string to a long value
  free(copy); // clean up 
  return value;
}

