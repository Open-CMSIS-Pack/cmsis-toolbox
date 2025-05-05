
     AREA   DATA

     IF     HEXADECIMAL_TEST != 11259375 ; 0xABCDEF
     INFO   1, "HEXADECIMAL_TEST failed!"
     ENDIF

     IF     DECIMAL_TEST != 1234567890
     INFO   1, "DECIMAL_TEST failed!"
     ENDIF

     IF     STRING_TEST != "String0"
     INFO   1, "STRING_TEST failed!"
     ENDIF

     IF     :LNOT::DEF:GROUP_ASM_AC6_DEF
     INFO   1, "GROUP_ASM_AC6_DEF is not defined!"
     ENDIF

     END
