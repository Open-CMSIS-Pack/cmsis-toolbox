/* Use CMSE intrinsics */
#include <arm_cmse.h>
 
#include "RTE_Components.h"
#include CMSIS_device_header
 
#ifndef START_NS
#define START_NS (0x200000U)
#endif
 
typedef void (*funcptr) (void) __attribute__((cmse_nonsecure_call));
 
int main(void) {
  funcptr ResetHandler;

  __TZ_set_MSP_NS(*((uint32_t *)(START_NS)));
  ResetHandler = (funcptr)(*((uint32_t *)((START_NS) + 4U)));
  ResetHandler();

  while (1) {
    __NOP();
  }
}

