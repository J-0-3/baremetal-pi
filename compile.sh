arm-none-eabi-as source/main.s -o build/kernel.o
arm-none-eabi-ld build/kernel.o -o build/kernel.elf -T kernel.ld
arm-none-eabi-objcopy build/kernel.elf -O binary kernel.img