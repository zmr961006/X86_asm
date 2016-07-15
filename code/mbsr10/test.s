.section .data
data:
     .int 0

.section .text
.globl __start
__start:
    nop
    movq $100,%rax
    movq $100,%rbx
    addq  %rax,%rbx
    int $0x80


    
