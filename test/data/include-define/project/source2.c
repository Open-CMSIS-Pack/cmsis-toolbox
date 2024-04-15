#include "inc.h"

#ifdef INC1
#error "INC1 is defined"
#endif

#ifndef INC2
#error "INC2 is not defined"
#endif

#ifdef DEF1
#error "DEF1 is defined"
#endif

#ifndef DEF2
#error "DEF2 is not defined"
#endif

int source2(void) {
  return 0;
}
