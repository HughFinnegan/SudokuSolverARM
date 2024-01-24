  .syntax unified
  .cpu cortex-m3
  .fpu softvfp
  .thumb
  
  .global  countInRow
  .global  countInCol
  .global  countIn3x3
  .global  nextInCell
  .global  solveSudoku


@ countInRow subroutine
@ Count the number of occurrences of a specified value in one row of a Sudoku
@   grid.
@
@ Parameters:
@   R0: start address of 2D array representing the Sudoku grid
@   R1: row number
@   R2: value to count
@ Return:
@   R0: number of occurrences of value in specified row
countInRow:
  PUSH    {LR}
  PUSH {R1-R12}
  @PUSH {R1, R2, R4}

  MOV R4, #0
  MOV R12, R0
  MOV R10, #9
  MUL R1, R1, R10
  @ADD R1, R1, #1
  ADD R12, R12, R1
  MOV R0, #0
.LwhicoIR:
  LDRB R5, [R12]
  CMP R5, R2
  BNE .LskipAddCIR
  ADD R0, R0, #1
  .LskipAddCIR:
  ADD R4, R4, #1
  ADD R12, R12, #1
  CMP R4, #8
  BLE .LwhicoIR

  @POP {R1, R2, R4}
  POP {R1-R12}
  POP     {PC}



@ countInCol subroutine
@ Count the number of occurrences of a specified value in one column of a Sudoku
@   grid.
@
@ Parameters:
@   R0: start address of 2D array representing the Sudoku grid
@   R1: column number
@   R2: value to count
@ Return:
@   R0: number of occurrences of value in specified column
countInCol:
  PUSH    {LR}
  PUSH {R1-R12}

  MOV R4, #0
  MOV R12, R0
  ADD R12, R12, R1
  MOV R0, #0
.LwhicoIC:
  LDRB R5, [R12]
  CMP R5, R2
  BNE .LskipAddCIC
  ADD R0, R0, #1
  .LskipAddCIC:
  ADD R4, R4, #1
  ADD R12, R12, #9
  CMP R4, #8
  BLE .LwhicoIC

  POP {R1-R12}
  POP     {PC}



@ countIn3x3 subroutine
@ Count the number of occurrences of a specified value in one 3x3 subgrid
@   of a Sudoku grid.
@
@ Parameters:
@   R0: start address of 2D array representing the Sudoku grid
@   R1: row number of any row in the 3x3 subgrid
@   R2: column number of any column in the 3x3 subgrid
@   R3: value to count
@ Return:
@   R0: number of occurrences of value in specified 3x3 subgrid
countIn3x3:
  PUSH    {LR}
  PUSH {R1-R12}
  MOV R12, #0

  CMP R1, #2
  BLE .LrowZero
  CMP R1, #5
  BLE .LrowTwo
  CMP R1, #8
  BLE .LrowFive

  .LrowZero:
  MOV R1, #0
  B .LtoColumn

  .LrowTwo:
  MOV R1, #3
  B .LtoColumn

  .LrowFive:
  MOV R1, #6

  .LtoColumn:
  CMP R2, #2
  BLE .LcolZero
  CMP R2, #5
  BLE .LcolTwo
  CMP R2, #8
  BLE .LcolFive

  .LcolZero:
  MOV R2, #0
  B .LpreThree

  .LcolTwo:
  MOV R2, #3
  B .LpreThree

  .LcolFive:
  MOV R2, #6

  .LpreThree:

  MOV R11, #0
  MOV R10, #9
  MUL R1, R1, R10
  ADD R9, R1, R2
  @ADD R9, R9, #1
  ADD R0, R0, R9

  .LwhiThree:

  LDRB R6, [R0]
  ADD R0, R0, #1
  CMP R6, R3
  BNE .LskipWhiThree1
  ADD R12, R12, #1
  .LskipWhiThree1:

  LDRB R7, [R0]
  ADD R0, R0, #1
  CMP R7, R3
  BNE .LskipWhiThree2
  ADD R12, R12, #1
  .LskipWhiThree2:

  LDRB R8, [R0]
  ADD R0, R0, #1
  CMP R8, R3
  BNE .LskipWhiThree3
  ADD R12, R12, #1
  .LskipWhiThree3:

  ADD R0, R0, #6
  ADD R11, R11, #1

  CMP R11, #3
  BNE .LwhiThree

  MOV R0, R12


  POP {R1-R12}
  POP     {PC}



@ nextInCell subroutine
@ Find the next higher valid value that can be placed in a specified cell in a
@   Sudoku grid.
@
@ Parameters:
@   R0: start address of 2D array representing the Sudoku grid
@   R1: row number of cell
@   R2: column number of cell
@ Return:
@   R0: next higher value or 0 if there is no valid higher value
nextInCell:
  PUSH    {LR}
  PUSH    {R1-R12}
  @LDRB R4, [R0]
  MOV R12, R0
  MOV R11, R2
  MOV R10, R1
  MOV R0, #1
  MOV R7, #9
  MUL R8, R1, R7
  ADD R8, R8, R2
  ADD R9, R8, R12
  LDRB R4, [R9]
  @MOV R4, #0
  MOV R5, #0

  .LwhiNIC:
  
  .LforRow:
  CMP R4, #9
  BEQ .LreturnZero
  ADD R4, R4, #1
  MOV R2, R4
  MOV R0, R12
  MOV R1, R10
  PUSH {R1-R12}
  BL countInRow
  POP {R1-R12}
  CMP R0, #1
  BGE .LforRow

  .LforColumn:
  ADD R5, R5, #1
  MOV R2, R4
  MOV R0, R12
  MOV R1, R11
  PUSH {R1-R12}
  BL countInCol
  POP {R1-R12}
  CMP R0, #1
  BGE .LforRow
  B .Lfor3x3

  .Lfor3x3:
  MOV R3, R4
  MOV R1, R10
  MOV R2, R11
  MOV R0, R12
  PUSH {R1-R12}
  BL countIn3x3
  POP {R1-R12}
  CMP R0, #0
  BNE .LforRow
  B .LmatchFound

  .LreturntoRow:
  MOV R5, #0
  B .LforRow


  .LreturnZero:
  MOV R4, #0

  .LmatchFound:
  MOV R0, R4

  POP {R1-R12}
  POP     {PC}



@ solveSudoku subroutine
@ Solve a Sudoku puzzle.
@
@ Parameters:
@   R0: start address of 2D array representing the Sudoku grid
@   R1: row number of next cell to modify
@   R2: column number of next cell to modify
@ Return:
@   R0: 1 if a solution was found, zero otherwise
solveSudoku:
  PUSH    {LR}
  PUSH    {R1-R12}
  MOV R12, #9
  MOV R11, R0
  
  CMP R1, #9
  BLT .LresultNot1
  MOV R0, #1
  .LresultNot1:
  CMP R0, #1
  BEQ .LendCurrentSolve

  MOV R0, #0
  ADD R4, R2, #1
  MOV R3, R1

  CMP R4, #9
  BLT .LskipRowAdd
  MOV R4, #0
  ADD R3, R3, #1
  .LskipRowAdd:

  MUL R5, R1, R12
  ADD R5, R5, R2
  ADD R10, R11, R5
  LDRB R5, [R10]

  CMP R5, #0
  BEQ .LskipResultCheck
  MOV R1, R3
  MOV R2, R4
  MOV R0, R11
  BL solveSudoku
  .LskipResultCheck:

  CMP R1, #9
  BLT .LresultNot2
  MOV R0, #1
  .LresultNot2:
  CMP R0, #1
  BEQ .LendCurrentSolve
  MOV R0, R11
  BL nextInCell
  MOV R6, R0

  .LwhiLoop:
  CMP R7, #1
  BEQ .LkillWhile
  CMP R6, #0
  BEQ .LkillWhile


  MUL R5, R1, R12
  ADD R5, R5, R2
  ADD R10, R11, R5
  STRB R6, [R10]

  PUSH {R1,R2}
  MOV R1, R3
  MOV R2, R4
  MOV R0, R11
  BL solveSudoku
  POP {R1,R2}
  MOV R7, R0

  MOV R0, R11
  BL nextInCell
  MOV R6, R0
  B .LwhiLoop
  .LkillWhile:

  CMP R0, #0
  BNE .LendCurrentSolve
  CMP R7, #1
  BEQ .Lresultequals1
  MOV R6, #0
  MUL R5, R1, R12
  ADD R5, R5, R2
  ADD R10, R11, R5
  STRB R6, [R10]
  B .LendCurrentSolve



  
  .Lresultequals1:
  MOV R0, #1
  .LendCurrentSolve:
  POP {R1-R12}
  POP     {PC}
  

  .end