/*保护模式的应用实例*/

mov eax,cs
mov ss,eax
mov sp,0x7c00


mov eax,[cs:gdt_base+0x7c00+0x02]
xor ebx
mov ebx,16
div ebx

mov cs,eax
mov ebx,edx 


mov dword [ebx+0x00],0x00000000
mov dword [ebx+0x04],0x00000000

mov dword [ebx+0x08],0x0000ffff
mov dword [ebx+0x0c],0x00cf9200

mov dword [ebx+0x10],0x7c0001ff
mov dword [exb+0x14],0x00409800

mov dword [ebx+0x18],0x7c00fffe
mov dword [ebx+0x24],0x00cf9600

mov word [cs:pgdt+0x7c00],39



pgdt    dw 0
        dd 0x00007e00


lgdt [cs:pgdt+0x7c00]

in al,0x92 
or al,0000_0010B
out 0x92,al

cli

mov eax,cr0
or  eax,1
mov cro,eax 


jmp dword 0x0010:flush 

[bits 32]

flush:

    mov eax,0x0018
    mov ds,eax 

    mov eax,0x0008
    mov es,eax
    mov fs,eax 
    mov gs,eax 

    mov eax,0x0020
    mov ss,eax
    xor esp,esp 


    mov ecx,gdt-string-1
    @@1:
        push ecx
        xor bx,bx 
    @@2:
        mov ax,[string+bx]
        cmp ah,al
        jge @@3
        xchg al,ah
        mov [string+bx],ax
    @@3:
        inc bx 
        loop @2
        pop  ecx 
        loop @@1

        mov ecx,pgdt-string
        xor ebx,ebx 

    @@4:
        mov ah,0x07 
        mov al.[string+ebx]
        mov [es:0xb80a0+ebx*2],ax
        inc ebx 
        loop @4

        hlt

    
    string db 'asdasdasdasd8098039284093adss'
    pgdt dw 0
         dd 0x00007e00 

times 510-($-$$) db 0 
                 db 0x55,0xaa
