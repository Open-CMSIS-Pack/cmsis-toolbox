#include "RTE_Components.h"
#include CMSIS_device_header
#include "cmsis_os2.h"

int main(void) {
  osKernelInitialize();                 // Initialize CMSIS-RTOS2
  osKernelStart();                      // Start thread execution
  return 0;
}
