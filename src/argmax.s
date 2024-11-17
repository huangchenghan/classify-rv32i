.globl argmax

.text
# =================================================================
# FUNCTION: Maximum Element First Index Finder
#
# Scans an integer array to find its maximum value and returns the
# position of its first occurrence. In cases where multiple elements
# share the maximum value, returns the smallest index.
#
# Arguments:
#   a0 (int *): Pointer to the first element of the array
#   a1 (int):  Number of elements in the array
#
# Returns:
#   a0 (int):  Position of the first maximum element (0-based index)
#
# Preconditions:
#   - Array must contain at least one element
#
# Error Cases:
#   - Terminates program with exit code 36 if array length < 1
# =================================================================
argmax:
    li t6, 1
    blt a1, t6, handle_error

    lw t0, 0(a0)        # current maximum
    li t1, 0            # position of maximum

    li t2, 0            # counter

    addi a0, a0, 4      # array index++
    addi t2, t2, 1      # counter++
    beq t2, a1, finish  # If array length == 1, finish

loop_start:
    # TODO: Add your own implementation
    lw t3, 0(a0)        # Get a[i]
    ble t3, t0, next    # If a[i] <= current maximum, not thing happen
    mv t0, t3           # Update current maximum
    mv t1, t2           # Update position of maximum

next:
    addi a0, a0, 4          # array index++
    addi t2, t2, 1          # counter++
    bne t2, a1, loop_start  # If counter != array length, loop

finish:
    mv a0, t1
    ret

handle_error:
    li a0, 36
    j exit
