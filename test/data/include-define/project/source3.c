#include "inc.h"

#ifdef INC1
#error "INC1 is defined"
#endif

#ifdef INC2
#error "INC2 is defined"
#endif

#ifndef INC3
#error "INC3 is not defined"
#endif

#ifdef DEF1
#error "DEF1 is defined"
#endif

#ifdef DEF2
#error "DEF2 is defined"
#endif

#ifndef DEF3
#error "DEF3 is not defined"
#endif

int source3(void) {
  return 0;
}
