
extern add

section .data

num1  dd  3
num2  dd  4

section .text

global __start

global myprint

__start:
    push dword [num1]
    push dword [num2]
    call add
    add esp,8
    mov ebx,0
    mov eax,1

    int 0x80

myprint:
    mov edx,[esp+8]
    mov ecx,[esp+4]
    mov ebx,1
    mov eax,4
    int 0x80
    ret 



