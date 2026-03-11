#include "RTE_Components.h"
#include CMSIS_device_header

#include RANDOM_CONFIG_FILE_1
#include RANDOM_CONFIG_FILE_2

#ifndef RANDOM_CONFIG1_INCLUDED
#error "Header <random_config1.h> include failed"
#endif
#ifndef RANDOM_CONFIG2_INCLUDED
#error "Header \"random_config2.h\" include failed"
#endif

int main(void) {
  return 0;
}
