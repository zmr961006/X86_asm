.section .data
output:
    .ascii "The processsor Vendor ID is 'xxxxxxxxxxxxxxxxxxxxxxxxxxxx\n' \n"

.section .text
.global __start
__start:
    movq $0,%rbx 
    cpuid
    movq $output,%rdi
    movq %rbx,28(%rdi)
    movq %rdx,32(%rdi)
    movq %rcx,36(%rdi)
    movq $4,%rax
    movq $1,%rbx 
    movq $output,%rcx 
    movq $42,%rdx
    int  $0x80
    movq $1,%rax
    movq $0,%rbx
    int  $0x80


