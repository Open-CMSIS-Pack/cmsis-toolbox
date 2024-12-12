                MODULE   ?Asm

#ifndef IAR_ASM_DEF
#error "IAR_ASM_DEF is not defined!"
#endif

#ifndef GROUP_ASM_IAR_DEF
#error "GROUP_ASM_IAR_DEF is not defined!"
#endif

                EXTERN   Reset_Handler_C

                PUBWEAK  Reset_Handler
                SECTION  .text:CODE:REORDER:NOROOT(2)
Reset_Handler
                LDR      R0, =Reset_Handler_C
                BX       R0

                END
