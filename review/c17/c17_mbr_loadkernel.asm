core_base_address   equ  0x00040000
core_start_sector   equ  0x00000001 


SECTION  mbr  vstart=0x00007c00

    mov ax,cs
    mov ss,ax
    mov sp,0x7c00





pgdt  dw 0
      dd 0x00008000


