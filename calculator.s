//Programming Assignment 1
//  calculator program for CDA 3101
//  buckley_jorge.s
//
//  Created by Jorge Buckley on 1/22/19.
//

.data
    //Create placeholders for values to be used in program
    flush: //Used to flush the load when needed
        .asciz "\n"
    answer:
        .asciz "%d"
    intA_buffer:
        .word 0
    intB_buffer:
        .word 0
    sign_buffer:
        .space 1
    inputNum: //accept number input to be used
        .asciz "%d"
    inputSign: //accept sign input for calculator
        .asciz "%c"
    request: //format used as request for input from user, two ints and a sign
        .asciz "%d %d %c"
    welcome: //
        .asciz "Please input the function you would like to perform:\n"
    err: //Print error if divide by zero
        .asciz "You may NOT divide by Zero!"


.global main
.text

main:
    //Print string asking for user input
    ldr x0, =welcome
    bl printf

    //Get registers ready for user input, set 3 buffers for two integers and one sign
    ldr x0, =request
    ldr x1, =intA_buffer
    ldr x2, =intB_buffer
    ldr x3, =sign_buffer
    //Take user input
    bl scanf


    //Move the values into new registers for later use
    //Load register x23 with address of int A input
    ldr x23, =intA_buffer
    //Use to get actual value, not just address
    ldr x23, [x23]
    //load register x24 with address of int B input
    ldr x24, =intB_buffer
    ldr x24, [x24]
    //Get x3 register back because of segFault happening otherwise
    ldr x3, =sign_buffer
    //load sign from x3 into w25
    ldrb w25, [x3, #0]

    //Follow Switch case model from class to choose operation
    bl switch

    //Now that we're back from the math operation, print our answer
    //Set x0 to %d type
    ldr x0, =answer
    //Bring our answer from x25 to x1
    mov x1, x26
    //Print
    bl printf
    //Exit the program
    b done


//This will be the switch case used to pick which arithmetic function to use
switch:
    //*****************BEGIN SWITCH CASES*********************
    //OPTION "+"
    //If w25 register has '+' value, branch to add function (ASCII of + is 43)
    cmp w25, #43
    //branch to add function
    beq ADD

    //OPTION "-"
    //If w25 = '-', branch to sub function (ASCII of - is 45)
    cmp w25, #45
    //branch to sub function
    beq SUB

    //OPTION "*"
    //If w25 = '*', branch to mul function (ASCII of * is 42)
    cmp w25, #42
    //branch to mul function
    beq MUL

    //OPTION "/"
    //If w25 = '/', branch to div function (ASCII of / is 47)
    cmp w25, #47
    //branch to div function
    beq DIV
    //*******************END OF SWITCH CASES*******************


done:
    //flush
    ldr x0, =flush
    bl printf
    //exit program same way as always
    mov x0, #0
    mov x8,#93
    svc #0

//Use wn instead of xn for registers to handle negative values
ADD:
    //Load x26 with sum of values from x23 and x24 (A+B)
    add w26, w23, w24
    //return to main
    br x30

SUB:
    //Load x26 with subtraction of x24 from x23 (A-B)
    sub w26, w23, w24
    //return to main
    br x30

MUL:
    //Load x26 with product of values from x23 and x24 (A*B)
    mul w26, w23, w24
    //return to main
    br x30

DIV:
    //First check if trying to divide by zero, if so go to divZero function
    cbz w24, divZero
    //Load x26 with division of of x24 from x23 (A/B)
    sdiv w26, w23, w24
    //return to main
    br x30

divZero:
    //use for when user tries to divide by zero
    //Print error message to log
    ldr x0, =err
    bl printf
    //exit program since we received error
    b done



