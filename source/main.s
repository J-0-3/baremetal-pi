.global _start

.section .data
.align 4
EnableGreen:
    //Message Header
    .int EnableGreenEnd-EnableGreen
    .int 0
    //Tag Header (0x00038041 = SET_GPIO_SET)
    .int 0x00038041
    .int 8
    .int 0
    //Tag Data (GPIO 29 = ACT LED)
    .int 29
    .int 1
    .int 0
EnableGreenEnd:

.align 4
EnableRed:
     //Message Header
     .int EnableRedEnd-EnableRed
     .int 0
     .int 0x00038041
     .int 8
     .int 0
     .int 130
     .int 1
     .int 0
EnableRedEnd:

.section .text
_start:
    //0x3f00b880 = GPU Mailbox 1 (write) Stack Address
    ldr r0,=0x3f00b880
    wait1$:
        //Status register for mailbox 1 is at 0x38 offset
        ldr r1, [r0, #0x38]
        tst r1, #0x80000000
        bne wait1$
    //Load message data address into r1
    //(previous value not in use, save registers)
    ldr r1, =EnableGreen
    //8 = PropertyTag GPU channel
    add r1, #8
    //Write register for mailbox 1 is at 0x20 offset
    str r1, [r0, #0x20]

    wait2$:
	ldr r1, [r0, #0x38]
	tst r1, #0x80000000
	bne wait2$
    ldr r1,=EnableRed
    add r1, #8
    str r1, [r0, #0x20]
    hang:
        b hang
