
message("Archiving artifacts")
message("INPUT: ${INPUT}")
message("OUTPUT: ${OUTPUT}")

set(CONTENT "
# Dummy File Content
# ${OUTPUT}
")
file(WRITE ${OUTPUT} ${CONTENT})
