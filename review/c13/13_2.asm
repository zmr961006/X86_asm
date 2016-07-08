/*一个小内核*/

core_code_seg_sel   equ  0x38     /*固定代码段选择子*/
core_data_seg_sel   equ  0x30
sys_routine_seg_sel equ  0x28
video_ram_seg_sel   equ  0x20
core_stack_seg_sel  equ  0x18
mem_0_4_gb_seg_sel  equ  0x08 

core_length             dd  core_end    /*各个系统段头部*/
sys_routine_seg_sel     dd  section.sys_routine.start
core_data_seg           dd  section.core_data_seg.start
core_code_seg           dd  section.core_code.start 
core_entry              dd  start       /*32位偏移地址，内核代码段选择子*/
                        dw  core_code_seg_sel 

[32 bits]

SECTION sys_routine vstart = 0
put_string:
    push ecx
    .getc
        mov cl,[ebx]
        or cl,cl
        jz .exit
        call put_char 
        inc ebx 
        jmp .getc 
    .exit:
        pop ecx 
        retf 

put_char:
    pushad 
    mov dx,0x3d4
    mov al,0x0e 
    out dx,al 
    inc dx 
    in al,dx 
    mov ah,al 

    dec dx 
    mov al,0x0f 
    out dx,al 
    inc dx
    in al,dx 
    mov bx,ax 
    
    cmp cl,0x0d
    jnz .put_0a
    mov ax,bx 
    mov bl,80 
    div bl
    mul bl 
    mov bx,ax 
    jmp .set_cursor 

.put_0a:
    cmp cl,0x0a
    jnz .put_other 
    add bx,80 
    jmp .roll_screen 
.put_other:
    push es 
    mov eax,video_ram_seg_sel 
    mov es,eax 
    shl bx,1
    mov [es:bx],cl
    pop es 

    shr bx,1 
    inc bx 
.roll_screen:
    cmp bx,2000
    jl .set_cursor 

    push ds
    push es 
    mov ds,eax 
    mov es,eax 

    cld 
    mov esi,0xa0 
    mov edi,0x00
    mov ecx,1920 
    rep movsd 
    mov bx,3840
    mov ecx,80 

.cls
    mov word[es:bx],0x0720
    add bx,2
    loop .cls 

    pop es 
    pop ds 
    mov bx,1920 

.set_cursor:

    /*.......*/


load_relocate_program:


make_descriptor:

set_up_descriptor:

reload_fun_and_descriptor:

start:

    mov ecx,core_data_seg_sel 
    mov ds,ecx

    mov ebx,message_1
    call sys_routine_seg_sel:put_string 
    
