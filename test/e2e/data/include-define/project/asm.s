
   .syntax unified
   .arch armv7-m

   .include "target.s"
   .include "group.s"
   .include "file.s"

   .ifndef TARGET_ASM_DEF
   .error "TARGET_ASM_DEF is not defined!"
   .endif

   .ifndef GROUP_ASM_DEF
   .error "GROUP_ASM_DEF is not defined!"
   .endif

   .ifndef FILE_ASM_DEF
   .error "FILE_ASM_DEF is not defined!"
   .endif

   .end
