/*创建保护模式下的段描述符*/

mov ax,cs
mov ss,ax
mov sp,0x7c00

mov ax,[cs:gdt_base+0x7c00]
mov dx,[cs:gdt_base+0x7c00 + 0x02]
mov bx,16
div bx

mov ds,ax
mov bx,dx

mov dword [bx+0x00],0x00     /*第一个段描述符NULL*/
mov dword [bx+0x04],0x00 

mov dword [bx+0x08],0x7c0001ff    /*代码段描述符*/
mov dword [bx+0x0c],0x00409800

mov dword [bx+0x10],0x8000ffff    /*保护模式下数据段描述符*/
mov dword [bx+0x14],0x0040920b    

mov dword [bx+0x18],0x00007a00
mov dword [bx+0x1c],0x00409600

mov word [cs:gdt_base+0x7c00],31 
ldgt [cs:gdt_size + 0x7c00]

in al,0x92
or al,0000_0010B
out 0x92,al 

cli

mov eax,cr0
or eax,1
mov cr0,eax 

jmp dword 0x0008:flush 

[bits 32]

flush: 
    mov cx,00000000000_10_000B
    mov ds,cx 

    mov byte [0x00],'P'
    mov byte [0x02],'r'
    mov byte [0x04],'o'

    mov cx,00000000000_11_000B
    mov ss,cx
    mov esp,0x7c00

    mov ebp,esp
    push byte ','

    sub ebp ,4
    cmp ebp,esp 
    jnz ghalt 
    pop eax 
    mov [0x1e],al

ghalt:
    hlt


gdt_size  dw 0
gdt_base  dd 0x00007e00

times 510-($-$$) db 0
                 db 0x55,0xaa 


