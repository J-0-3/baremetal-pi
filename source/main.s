.global _start

.section .data
.align 4
PropertyTag:
    //Message Header
    .int PropertyTagEnd-PropertyTag
    .int 0
    //Tag Header (0x00038041 = SET_GPIO_STATE)
    .int 0x00038041
    .int 8
    .int 0
    //Tag Data (GPIO 29 = ACT LED, GPIO 130 = PWR LED)
    .int 130
    .int 1
    .int 0
PropertyTagEnd:

.section .text

waitForFree:
    ldr r1, [r0, #0x38]
    tst r1, #0x80000000
    bne waitForFree
    mov r15, r14

setPinR2toR3:
    ldr r0, =0x3f00b880
    ldr r1, =PropertyTag
    mov r4, #0
    str r4, [r1, #0x4]
    str r4, [r1, #0x10]
    str r2, [r1, #0x14]
    str r3, [r1, #0x18]
    add r1, #8
    str r1, [r0, #0x20]
    mov r1, #0
    mov r15, r14

readMailbox:
    ldr r0, =0x3f00b880
    readloop$:
        ldr r1, [r0, #0x18]
        tst r1, #0x40000000
        bne readloop$

        ldr r1, [r0]
        and r2, r1, #0b1111 //Extract last 4 bits via AND to check channel
        teq r2, #8
        bne readloop$
    
    mov r0, r1
    mov r15, r14

delay:
    mov r0, #0
    countloop$:
        add r0, #1
        cmp r0, #0x300000
        bne countloop$
    mov r15, r14
.section .init
_start:
    //0x3f00b880 = GPU Mailbox 1 (write) Stack Address
    mov r2, #29
    mov r3, #1
    bl waitForFree
    bl setPinR2toR3
    bl readMailbox

    mov r2, #130
    bl waitForFree
    bl setPinR2toR3
    bl readMailbox

    bl delay

    mov r2, #29
    mov r3, #0
    bl waitForFree
    bl setPinR2toR3
    bl readMailbox

    mov r2, #130
    bl waitForFree
    bl setPinR2toR3
    bl readMailbox

    bl delay

    b _start
