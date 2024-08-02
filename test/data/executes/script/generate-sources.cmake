
message("Generating Sources")
message("INPUT_1: ${INPUT_1}")
message("OUTPUT_0: ${OUTPUT_0}")
message("OUTPUT_1: ${OUTPUT_1}")

file(READ ${INPUT_1} CONTENT_0)
file(WRITE ${OUTPUT_0} "${CONTENT_0}")

set(CONTENT_1 "
#include \"RTE_Components.h\"
#include CMSIS_device_header
int function(void) {
  return 0;
}
")
file(WRITE ${OUTPUT_1} "${CONTENT_1}")
