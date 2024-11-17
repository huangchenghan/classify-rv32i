.globl relu

.text
# ==============================================================================
# FUNCTION: Array ReLU Activation
#
# Applies ReLU (Rectified Linear Unit) operation in-place:
# For each element x in array: x = max(0, x)
#
# Arguments:
#   a0: Pointer to integer array to be modified
#   a1: Number of elements in array
#
# Returns:
#   None - Original array is modified directly
#
# Validation:
#   Requires non-empty array (length ≥ 1)
#   Terminates (code 36) if validation fails
#
# Example:
#   Input:  [-2, 0, 3, -1, 5]
#   Result: [ 0, 0, 3,  0, 5]
# ==============================================================================
relu:
    li t0, 1             
    blt a1, t0, error     
    li t1, 0    # 0 for sw
    li t2, 0    # counter

loop_start:
    # TODO: Add your own implementation
    lw t3, 0(a0)    # get a[i]
    bgez t3, next   # if a[i] >= 0, not thing happen
    sw t1, 0(a0)    # if a[i] < 0, a[i] = 0
    
next:
    addi a0, a0, 4  # array index++
    addi t2, t2, 1  # counter++
    bne t2, a1, loop_start  # check if counter == Number of elements in array
    ret

error:
    li a0, 36          
    j exit          
