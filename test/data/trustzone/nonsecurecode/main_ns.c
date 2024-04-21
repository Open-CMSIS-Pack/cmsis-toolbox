#include "interface.h"        // Interface API
#include "cmsis_os2.h"        // ARM::CMSIS:RTOS2:Keil RTX5

static osStatus_t Status;

static osThreadId_t ThreadAdd_Id;
static osThreadId_t ThreadMul_Id;

static const osThreadAttr_t ThreadAttr = {
  .tz_module = 1U,
};

void AddThread (void *argument);
void MulThread (void *argument);

extern volatile int valueA;
extern volatile int valueB;

volatile int valueA;
volatile int valueB;


static int Addition (int val1, int val2) {
  return (val1 + val2);
}

__attribute__((noreturn))
void AddThread (void *argument)  {
  (void)argument;

  for (;;) {
    valueA = function_1 (valueA);
    valueA = function_2 (Addition, valueA, 2);
    osDelay(2U);
  }
}

static int Multiply (int val1, int val2)  {
  uint32_t flags;

  flags = osThreadFlagsWait (1U, osFlagsWaitAny, osWaitForever);
  if (flags == 1U) {
    return (val1*val2);
  }
  else {
    return (0);
  }
}


__attribute__((noreturn))
void MulThread (void *argument)  {
  (void)argument;

  for (;;) {
    valueB = function_1 (valueB);
    valueB = function_2 (Multiply, valueB, 2);
  }
}


int main (void) {
  Status = osKernelInitialize();

  ThreadAdd_Id = osThreadNew(AddThread, NULL, &ThreadAttr);
  ThreadMul_Id = osThreadNew(MulThread, NULL, &ThreadAttr);

  Status = osKernelStart();

  for(;;);
}



