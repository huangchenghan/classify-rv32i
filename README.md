# Assignment 2: Classify

## Part A: Mathematical Functions

### Task 1: ReLU
The purpose of the ReLU function is to convert negative values in an array to 0.  
In my implementation, I use a loop to iterate through all the values in the array and replace the negative values with 0.
```s
    li t1, 0    # 0 for sw
    li t2, 0    # counter

loop_start:
    # TODO: Add your own implementation
    lw t3, 0(a0)    # Get a[i]
    bgez t3, next   # If a[i] >= 0, do nothing
    sw t1, 0(a0)    # If a[i] < 0, a[i] = 0
    
next:
    addi a0, a0, 4          # array index++
    addi t2, t2, 1          # counter++
    bne t2, a1, loop_start  # If counter != array length, loop
    ret
```

### Task 2: ArgMax
The purpose of the ArgMax function is to find the index of the maximum value in a vector (1D array).  
In my implementation, I use a loop to iterate through all the values in the array, keeping track of the current maximum value and its index at each step.
```s
    lw t0, 0(a0)        # current maximum
    li t1, 0            # position of maximum

    li t2, 0            # counter

    addi a0, a0, 4      # array index++
    addi t2, t2, 1      # counter++
    beq t2, a1, finish  # If array length == 1, finish

loop_start:
    # TODO: Add your own implementation
    lw t3, 0(a0)        # Get a[i]
    ble t3, t0, next    # If a[i] <= current maximum, do nothing
    mv t0, t3           # Update current maximum
    mv t1, t2           # Update position of maximum

next:
    addi a0, a0, 4          # array index++
    addi t2, t2, 1          # counter++
    bne t2, a1, loop_start  # If counter != array length, loop

finish:
    mv a0, t1
    ret
```

### Task 3.1: Dot Product
The purpose of the dot product function is to compute the dot product of two vectors (1D array).  
In my implementation, I use a loop to iterate through all the values in two arrays (a0 and a1) and apply a multiplier to compute a0[i]*a1[i].
```s
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
```

### Task 3.2: Matrix Multiplication
In matmul.s, we need to implement Matrix Multiplication. Since most of the content in matmul.s is already completed, we only need to implement the sections under the labels inner_loop_end and outer_loop_end.

In inner_loop_end, since the pointer for M0 is currently pointing to a row that has finished its calculations, we need to move the pointer to the next row.

In outer_loop_end, we need to complete the epilogue section.
```s
inner_loop_end:
    # TODO: Add your own implementation
    mv t2, a2           # t2 = column count of M0
    slli t2, t2, 2      # t2 *= 4 (each value is 4 bytes)
    add s3, s3, t2      # Incrememtning pointer for M0 (move to next row)

    addi s0, s0, 1      # outer loop counter += 1
    j outer_loop_start

outer_loop_end:
    lw ra, 0(sp)   
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    addi sp, sp, 28
    jr ra
```

## Part B: File Operations and Main
In Part B, since most of the content in read_matrix.s, write_matrix.s, and classify.s is already completed, we only need to replace the mul instruction with our own multiplier implementation.

### Task 1: Read Matrix
```s
    # mul s1, t1, t2   # s1 is number of elements
    # FIXME: Replace 'mul' with your own implementation
    # ################ my implementation ################
my_mul:
    li s1, 0        # sum

multiply_loop_start:
    andi t3, t2, 1                  # Get LSB of t2
    beqz t3, multiply_loop_next     # If the LSB of t2 == 0, do nothing
    add s1, s1, t1                  # sum += t1

multiply_loop_next:
    slli t1, t1, 1                  # t1 << 1
    srli t2, t2, 1                  # t2 >> 1
    bnez t2, multiply_loop_start    # If t2 != 0, loop
    # ################ my implementation ################
```

### Task 2: Write Matrix
```s
    # mul s4, s2, s3   # s4 = total elements
    # FIXME: Replace 'mul' with your own implementation
    # ################ my implementation ################
my_mul:
    li s4, 0        # sum

multiply_loop_start:
    andi t1, s3, 1                  # Get LSB of s3
    beqz t1, multiply_loop_next     # If the LSB of s3 == 0, do nothing
    add s4, s4, s2                  # sum += s2

multiply_loop_next:
    slli s2, s2, 1                  # s2 << 1
    srli s3, s3, 1                  # s3 >> 1
    bnez s3, multiply_loop_start    # If s3 != 0, loop
    # ################ my implementation ################
```

### Task 3: Classification
```s
    # mul a0, t0, t1 
    # FIXME: Replace 'mul' with your own implementation
    # ################ my implementation ################
my_mul_1:
    li a0, 0        # sum

multiply_loop_start_1:
    andi t2, t1, 1                  # Get LSB of t1
    beqz t2, multiply_loop_next_1   # If the LSB of t1 == 0, do nothing
    add a0, a0, t0                  # sum += t0

multiply_loop_next_1:
    slli t0, t0, 1                  # t0 << 1
    srli t1, t1, 1                  # t1 >> 1
    bnez t1, multiply_loop_start_1  # If t1 != 0, loop
    # ################ my implementation ################
```

```s
    # mul a1, t0, t1 # length of h array and set it as second argument
    # FIXME: Replace 'mul' with your own implementation
    # ################ my implementation ################
my_mul_2:
    li a1, 0        # sum

multiply_loop_start_2:
    andi t2, t1, 1                  # Get LSB of t1
    beqz t2, multiply_loop_next_2   # If the LSB of t1 == 0, do nothing
    add a1, a1, t0                  # sum += t0

multiply_loop_next_2:
    slli t0, t0, 1                  # t0 << 1
    srli t1, t1, 1                  # t1 >> 1
    bnez t1, multiply_loop_start_2  # If t1 != 0, loop
    # ################ my implementation ################
```

```s
    # mul a0, t0, t1 
    # FIXME: Replace 'mul' with your own implementation
    # ################ my implementation ################
my_mul_3:
    li a0, 0        # sum

multiply_loop_start_3:
    andi t2, t1, 1                  # Get LSB of t1
    beqz t2, multiply_loop_next_3   # If the LSB of t1 == 0, do nothing
    add a0, a0, t0                  # sum += t0

multiply_loop_next_3:
    slli t0, t0, 1                  # t0 << 1
    srli t1, t1, 1                  # t1 >> 1
    bnez t1, multiply_loop_start_3  # If t1 != 0, loop
    # ################ my implementation ################
```

```s
    # mul a1, t0, t1 # load length of array into second arg
    # FIXME: Replace 'mul' with your own implementation
    # ################ my implementation ################
my_mul_4:
    li a1, 0        # sum

multiply_loop_start_4:
    andi t2, t1, 1                  # Get LSB of t1
    beqz t2, multiply_loop_next_4   # If the LSB of t1 == 0, do nothing
    add a1, a1, t0                  # sum += t0

multiply_loop_next_4:
    slli t0, t0, 1                  # t0 << 1
    srli t1, t1, 1                  # t1 >> 1
    bnez t1, multiply_loop_start_4  # If t1 != 0, loop
    # ################ my implementation ################
```

## Result
execute ```bash ./test.sh all```
```
test_abs_minus_one (__main__.TestAbs.test_abs_minus_one) ... ok
test_abs_one (__main__.TestAbs.test_abs_one) ... ok
test_abs_zero (__main__.TestAbs.test_abs_zero) ... ok
test_argmax_invalid_n (__main__.TestArgmax.test_argmax_invalid_n) ... ok
test_argmax_length_1 (__main__.TestArgmax.test_argmax_length_1) ... ok
test_argmax_standard (__main__.TestArgmax.test_argmax_standard) ... ok
test_chain_1 (__main__.TestChain.test_chain_1) ... ok
test_classify_1_silent (__main__.TestClassify.test_classify_1_silent) ... ok
test_classify_2_print (__main__.TestClassify.test_classify_2_print) ... ok
test_classify_3_print (__main__.TestClassify.test_classify_3_print) ... ok
test_classify_fail_malloc (__main__.TestClassify.test_classify_fail_malloc) ... ok
test_classify_not_enough_args (__main__.TestClassify.test_classify_not_enough_args) ... ok
test_dot_length_1 (__main__.TestDot.test_dot_length_1) ... ok
test_dot_length_error (__main__.TestDot.test_dot_length_error) ... ok
test_dot_length_error2 (__main__.TestDot.test_dot_length_error2) ... ok
test_dot_standard (__main__.TestDot.test_dot_standard) ... ok
test_dot_stride (__main__.TestDot.test_dot_stride) ... ok
test_dot_stride_error1 (__main__.TestDot.test_dot_stride_error1) ... ok
test_dot_stride_error2 (__main__.TestDot.test_dot_stride_error2) ... ok
test_matmul_incorrect_check (__main__.TestMatmul.test_matmul_incorrect_check) ... ok
test_matmul_length_1 (__main__.TestMatmul.test_matmul_length_1) ... ok
test_matmul_negative_dim_m0_x (__main__.TestMatmul.test_matmul_negative_dim_m0_x) ... ok
test_matmul_negative_dim_m0_y (__main__.TestMatmul.test_matmul_negative_dim_m0_y) ... ok
test_matmul_negative_dim_m1_x (__main__.TestMatmul.test_matmul_negative_dim_m1_x) ... ok
test_matmul_negative_dim_m1_y (__main__.TestMatmul.test_matmul_negative_dim_m1_y) ... ok
test_matmul_nonsquare_1 (__main__.TestMatmul.test_matmul_nonsquare_1) ... ok
test_matmul_nonsquare_2 (__main__.TestMatmul.test_matmul_nonsquare_2) ... ok
test_matmul_nonsquare_outer_dims (__main__.TestMatmul.test_matmul_nonsquare_outer_dims) ... ok
test_matmul_square (__main__.TestMatmul.test_matmul_square) ... ok
test_matmul_unmatched_dims (__main__.TestMatmul.test_matmul_unmatched_dims) ... ok
test_matmul_zero_dim_m0 (__main__.TestMatmul.test_matmul_zero_dim_m0) ... ok
test_matmul_zero_dim_m1 (__main__.TestMatmul.test_matmul_zero_dim_m1) ... ok
test_read_1 (__main__.TestReadMatrix.test_read_1) ... ok
test_read_2 (__main__.TestReadMatrix.test_read_2) ... ok
test_read_3 (__main__.TestReadMatrix.test_read_3) ... ok
test_read_fail_fclose (__main__.TestReadMatrix.test_read_fail_fclose) ... ok
test_read_fail_fopen (__main__.TestReadMatrix.test_read_fail_fopen) ... ok
test_read_fail_fread (__main__.TestReadMatrix.test_read_fail_fread) ... ok
test_read_fail_malloc (__main__.TestReadMatrix.test_read_fail_malloc) ... ok
test_relu_invalid_n (__main__.TestRelu.test_relu_invalid_n) ... ok
test_relu_length_1 (__main__.TestRelu.test_relu_length_1) ... ok
test_relu_standard (__main__.TestRelu.test_relu_standard) ... ok
test_write_1 (__main__.TestWriteMatrix.test_write_1) ... ok
test_write_fail_fclose (__main__.TestWriteMatrix.test_write_fail_fclose) ... ok
test_write_fail_fopen (__main__.TestWriteMatrix.test_write_fail_fopen) ... ok
test_write_fail_fwrite (__main__.TestWriteMatrix.test_write_fail_fwrite) ... ok

----------------------------------------------------------------------
Ran 46 tests in 43.395s

OK
```