/*引导代码*/

core_base_address equ 0x00040000
core_start_sector equ 0x00000001

mov ax,cs
mov ss,ax
mov sp,0x7c00

mov eax,[cs:pgdt+0x7c00+0x02]
xor edx,edx
mov ebx,16
div ebx

mov ds,eax
mov ebx,edx 

mov dword [ebx+0x08],0x0000ffff
mov dword [ebx+0x0c],0x00cf9200

mov dword [ebx+0x10],0x7c0001ff
mov dword [ebx+0x14],0x00409800

mov dword [ebx+0x18],0x7c00fffe
mov dword [ebx+0x1c],0x00cf9600

mov dword [ebx+0x20],0x80007fff
mov dword [ebx+0x24],0x0040920b

mov word [cs:pgdt+0x7c00],39

ldgt [cs:pgdt+0x7c00]

in al,0x92
or al,0000_0010B
out 0x92,al

cli

mov eax,cr0
or eax,1
mov cr0,eax

jmp dowrd 0x0010:flush

[bits 32]

flush:
    mov eax,0x0018
    mov ds,eax

    mov eax,0x0018
    mov ss,eax 
    xor esp,esp

    mov edi,core_base_address 
    mov eax,core_start_sector 

    mov ebx,edi 
    call read_hard_disk_0

    mov eax,[edi]
    xor edx,edx
    mov ecx,512
    div ecx

    or edx,edx
    jnz @1
    dec eax 
@1:
    or eax,eax 
    jz setup

    mov ecx,eax 
    mov eax,core_start_sector 
    inc eax 
@2:
    call read_hard_disk_0 
    inc eax 
    loop @2

setup: 
    
    mov esi,[0x7c00+pgdt+0x02]

    mov eax,[edi+0x04]
    mov ebx,[edi+0x08]
    sub ebx,eax 
    dec ebx 
    add eax,edi 
    mov ecx,0x00409800 
    call make_gdt_descriptor 
    mov [esi+0x28],eax            /*默认知道段位置*/
    mov [esi+0x2c],edx 

    mov eax,[edi+0x08]
    mov ebx.[edi+0x0c]
    sub ebx,eax 
    dec ebx
    add eax,edi 
    mov ecx,0x00409200 
    call make_gdt_descriptor 
    mov [esi+0x30],eax 
    mov [esi+0x34],edx 

    mov eax,[edi+0x0c]
    mov ebx,[edi+0x00]
    sub ebx,eax 
    dec ebx 
    add eax,edi 
    mov ecx,0x00409800 
    call make_gdt_descriptor 
    mov [esi+0x38],eax 
    mov [esi+0x3c],edx 
    mov word [0x7c00+pgdt],63

    ldgt [0x7c00+pgdt]

    jmp far [edi+0x10]



make_gdt_descriptor:

    mov edx,eax 
    shl eax,16
    or ax,bx 

    and edx,0xffff0000
    rol edx,8
    bswap edx 

    xor bx,bx 
    or edx,ebx 
    or edx,ecx 
    ret 

