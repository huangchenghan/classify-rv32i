.globl dot

.text
# =======================================================
# FUNCTION: Strided Dot Product Calculator
#
# Calculates sum(arr0[i * stride0] * arr1[i * stride1])
# where i ranges from 0 to (element_count - 1)
#
# Args:
#   a0 (int *): Pointer to first input array
#   a1 (int *): Pointer to second input array
#   a2 (int):   Number of elements to process
#   a3 (int):   Skip distance in first array
#   a4 (int):   Skip distance in second array
#
# Returns:
#   a0 (int):   Resulting dot product value
#
# Preconditions:
#   - Element count must be positive (>= 1)
#   - Both strides must be positive (>= 1)
#
# Error Handling:
#   - Exits with code 36 if element count < 1
#   - Exits with code 37 if any stride < 1
# =======================================================
dot:
    li t0, 1
    blt a2, t0, error_terminate  
    blt a3, t0, error_terminate   
    blt a4, t0, error_terminate  

    li t0, 0        # dot product value
    li t1, 0        # counter 

    slli a3, a3, 2  # a3 * 4 (stride0 * 4)
    slli a4, a4, 2  # a4 * 4 (stride1 * 4)

loop_start:
    # TODO: Add your own implementation
    lw t2, 0(a0)    # Get arr0[i * stride0]
    lw t3, 0(a1)    # Get arr1[i * stride1]
    li t4, 0        # sum

multiply_loop_start:
    andi t5, t3, 1                  # Get LSB of t3
    beqz t5, multiply_loop_next     # If the LSB of t3 == 0, do nothing
    add t4, t4, t2                  # sum += t2

multiply_loop_next:
    slli t2, t2, 1                  # t2 << 1
    srli t3, t3, 1                  # t3 >> 1
    bnez t3, multiply_loop_start    # If t3 != 0, loop

multiply_loop_end:
    add t0, t0, t4          # dot product value += sum

loop_next:
    add a0, a0, a3          # array0 index += stride0
    add a1, a1, a4          # array1 index += stride1
    addi t1, t1, 1          # counter++
    bne t1, a2, loop_start  # If counter != array length, loop

loop_end:
    mv a0, t0
    jr ra

error_terminate:
    blt a2, t0, set_error_36
    li a0, 37
    j exit

set_error_36:
    li a0, 36
    j exit
