#include "RTE_Components.h"
#include CMSIS_device_header
#include "tz_context.h"

__attribute__((cmse_nonsecure_entry))
uint32_t TZ_InitContextSystem_S(void) {
  return 1U;
}

__attribute__((cmse_nonsecure_entry))
TZ_MemoryId_t TZ_AllocModuleContext_S(TZ_ModuleId_t module) {
  (void)module;
  return 1U;
}

__attribute__((cmse_nonsecure_entry))
uint32_t TZ_FreeModuleContext_S(TZ_MemoryId_t id) {
  (void)id;
  return 1U;
}


__attribute__((cmse_nonsecure_entry))
uint32_t TZ_LoadContext_S(TZ_MemoryId_t id) {
  (void)id;
  return 2U;
}

__attribute__((cmse_nonsecure_entry))
uint32_t TZ_StoreContext_S(TZ_MemoryId_t id) {
  (void)id;
  return 2U;
}

