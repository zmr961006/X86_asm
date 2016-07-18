.section .data
output:
    .asciz "The value is :%d\n"

.section .text
.globl main
.globl __start

main:
__start:
    movl $0,%ecx
    movl $0,%eax
    jrcxz done

loop1:
    addl %ecx,%eax
    loop loop1

done:
    pushq %rax
    pushq $output
    call printf
    movl $1,%eax
    movl $0,%ebx
    int $0x80

