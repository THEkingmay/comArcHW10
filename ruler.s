    .data
line:      .string "- "
nextline:  .string "\n"

    .text
main:
    addi x20, x0, 1       # tmp = 1
    addi x25, x0, 4       # parameter = 4
    jal ruler             # call ruler function
    addi a0, x0, 10       # syscall code 10 for exit
    ecall

# Recursive ruler function
ruler:
    addi x18, x0, 0       # i = 0
    addi sp, sp, -8       # allocate space on stack
    sw ra, 4(sp)          # save return address
    sw x25, 0(sp)         # save parameter

    lw x19, 0(sp)         # load parameter into x19 (n)
    bne x19, x20, notbasecase  # if n != 1, jump to notbasecase

# Base case: n = 1
basecase:
    lw ra, 4(sp)          # restore return address
    lw x25, 0(sp)         # restore x25 (parameter)
    addi a0, x0, 4        # syscall code 4 for print string
    la a1, line           # load address of line string
    ecall
    addi a0, x0, 4        # syscall code 4 for newline
    la a1, nextline       # load address of newline
    ecall
    addi sp, sp, 8        # deallocate stack
    jr ra                 # return to caller

# Recursive case
notbasecase:
    addi x25, x25, -1     # parameter - 1
    jal ruler             # recursive call

    lw x25, 0(sp)         # restore parameter after recursive call
loop:
    bge x18, x25, exitloop  # if i >= parameter, exit loop
    addi a0, x0, 4        # syscall code 4 for print string
    la a1, line           # load address of line string
    ecall
    addi x18, x18, 1      # i++
    j loop                # jump to loop

exitloop:
    addi a0, x0, 4        # syscall code 4 for newline
    la a1, nextline       # load address of newline
    ecall

    addi x25, x25, -1     # parameter - 1
    jal ruler             # recursive call

    lw ra, 4(sp)          # restore return address
    lw x25, 0(sp)         # restore parameter
    addi sp, sp, 8        # deallocate stack
    jr ra                 # return to caller
