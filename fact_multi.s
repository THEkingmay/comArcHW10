.data
text: .string "Factorial of "
is: .string " is "
nextline: .string "\n"

.text
main:
    addi x19, x0, 0        # i = 0
    addi x30, x0, 9        # n = 9
loop:
    bge x19, x30, exit     # if i >= n, exit
    add x25, x0, x19      # parameter1 = i
    addi x18, x0, 1        # result = 1 (initial value)

    addi sp, sp, -8        # allocate 8 bytes on stack
    sw x25, 0(sp)          # save parameter1 on stack
    sw ra, 4(sp)           # save return address on stack

    jal fact               # call factorial function

    lw x25, 0(sp)          # restore parameter1
    lw ra, 4(sp)           # restore return address
    addi sp, sp, 8         # deallocate 8 bytes on stack

    # Print "Factorial of "
    addi a0, x0, 4         # syscall code 4 for printing a string
    la a1, text            # load address of text string
    ecall

    # Print the value of i (factorial input)
    addi a0, x0, 1         # syscall code 1 for printing integer
    mv a1, x19             # move i to a1
    ecall

    # Print " is "
    addi a0, x0, 4         # syscall code 4 for printing a string
    la a1, is              # load address of "is" string
    ecall

    # Print the factorial result
    addi a0, x0, 1         # syscall code 1 for printing integer
    mv a1, x18             # move result to a1
    ecall

    # Print newline
    addi a0, x0, 4         # syscall code 4 for printing a string
    la a1, nextline        # load address of newline string
    ecall

    addi x19, x19, 1       # i++
    j loop

exit:
    addi a0, x0, 10        # syscall code 10 for exit
    ecall

fact:
    addi sp, sp, -8        # allocate 8 bytes on stack (save x25 and ra)
    sw x25, 0(sp)          # save parameter1
    sw ra, 4(sp)           # save return address

    addi x29, x25, 0        # t0 = parameter1
    beq x29, x0, base_case  # if parameter1 == 0, go to base_case
    addi x29, x25, -1       # t0 = parameter1 - 1
    beq x29, x0, base_case  # if parameter1 == 1, go to base_case

    addi x25, x25, -1      # parameter1 = parameter1 - 1
    jal fact               # call fact(parameter1 - 1)

    lw x25, 0(sp)          # restore original parameter1
    mul x18, x18, x25      # result *= parameter1

    lw ra, 4(sp)           # restore return address
    lw x25, 0(sp)          # restore parameter1
    addi sp, sp, 8         # deallocate 8 bytes on stack
    jalr x0, ra, 0         # return

base_case:
    addi x18, x0, 1        # result = 1 (base case)
    lw ra, 4(sp)           # restore return address
    lw x25, 0(sp)          # restore parameter1
    addi sp, sp, 8         # deallocate 8 bytes on stack
    jalr x0, ra, 0         # return
