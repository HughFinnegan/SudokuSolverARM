  .syntax unified
  .cpu cortex-m3
  .fpu softvfp
  .thumb

  .global  Init_Test
  .global  Main
  .global  testGrid

@
@ Main
@
@ An implementation of Main to test each of our subroutines
@ You should "comment out" all but one subroutine call
@   to test individual subroutines as you develop them.
@
@ Modify the tests to suit your needs.
@
Main:

  PUSH  {LR}


  @LDR   R0, =testGrid
  @LDR   R1, =2        @ row number
  @LDR   R2, =5        @ value to look for
  @BL    countInRow    @ countInRow(grid, row, value)

  @LDR   R0, =testGrid
  @LDR   R1, =8        @ row number
  @LDR   R2, =9        @ value to look for
  @BL    countInRow    @ countInRow(grid, row, value)

  @LDR   R0, =testGrid
  @LDR   R1, =0        @ column number
  @LDR   R2, =9        @ value to look for
  @BL    countInCol    @ countInCol(grid, row, value)

  @LDR   R0, =testGrid
  @LDR   R1, =6        @ column number
  @LDR   R2, =1        @ value to look for
  @BL    countInCol    @ countInCol(grid, row, value)

  @LDR   R0, =testGrid
  @LDR   R1, =3        @ row number
  @LDR   R2, =6        @ column number
  @LDR   R3, =1        @ value to look for
  @BL    countIn3x3    @ countIn3x3(grid, row, col, value)

  @LDR   R0, =testGrid
  @LDR   R1, =8        @ row number
  @LDR   R2, =4        @ column number
  @LDR   R3, =2        @ value to look for
  @BL    countIn3x3    @ countIn3x3(grid, row, col, value)

  @LDR   R0, =testGrid
  @LDR   R1, =1        @ row number
  @LDR   R2, =7        @ column number
  @BL    nextInCell    @ nextInCell(grid, row, col)

  @LDR   R0, =testGrid
  @LDR   R1, =6        @ row number
  @LDR   R2, =0        @ column number
  @BL    nextInCell    @ nextInCell(grid, row, col)

  @LDR   R0, =testGrid
  @LDR   R1, =1        @ row number
  @LDR   R2, =6        @ column number
  @BL    nextInCell    @ nextInCell(grid, row, col)

  LDR   R0, =testGrid
  LDR   R1, =0        @ row number
  LDR   R2, =0        @ column number
  BL    solveSudoku   @ solveSudoku(grid, 0, 0)


  @
  @ Finally, let's try to solve the puzzle ...
  @ (The initial call to the resursive solveSudoku subroutine
  @   should always start in the top-left corner.)
  @




End_Main:

  POP   {PC}


  .section  .data.test
@ Sudoku Test Grid
testGrid:
  .byte 0, 0, 0, 2, 6, 0, 7, 0, 1
  .byte 6, 8, 0, 0, 7, 0, 0, 9, 0
  .byte 1, 9, 0, 0, 0, 4, 5, 0, 0
  .byte 8, 2, 0, 1, 0, 0, 0, 4, 0
  .byte 0, 0, 4, 6, 0, 2, 9, 0, 0
  .byte 0, 5, 0, 0, 0, 3, 0, 2, 8
  .byte 0, 0, 9, 3, 0, 0, 0, 7, 4
  .byte 0, 4, 0, 0, 5, 0, 0, 3, 6
  .byte 7, 0, 3, 0, 1, 8, 0, 0, 0


.end