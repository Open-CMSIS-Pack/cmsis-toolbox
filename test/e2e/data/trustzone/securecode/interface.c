#include <arm_cmse.h>

#include "interface.h"

/* typedef for non-secure callback functions */
typedef funcptr funcptr_NS __attribute__((cmse_nonsecure_call));

/* Non-secure callable (entry) function */
int function_1(int x) __attribute__((cmse_nonsecure_entry)) { 
  return x+5; 
}

/* Non-secure callable (entry) function, calling a non-secure callback function */
int function_2(funcptr callback, int x, int y)  __attribute__((cmse_nonsecure_entry))	{
  funcptr_NS callback_NS;               // non-secure callback function pointer
  int res;

  /* return function pointer with cleared LSB */
  callback_NS = (funcptr_NS)cmse_nsfptr_create(callback);
  res = callback_NS (x, y);

  return (res*10);
}

