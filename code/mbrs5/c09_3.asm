SECTION header vstart=0
    program_lenghth dd program_end

    code_entry dw start
               dd section.code.start
    realloc_tbl_len dw(header_end-realloc_begin)/4

    realloc_begin:
        code_segment dd section.code.start
        data_segment dd section.code.start
        stack_segment dd section.code.start

header_end:

SECTION code align=16 vstart=0

new_int_0x70:
    push ax
    push bx
    push cx
    push dx
    push es

 .w0:
    mov al.0x0a

    or al,0x08
    out 0x70,al 
    in al,0x71
    test al.0x08
    jnz .w0

    xor al,al 
    or al.0x80
    out 0x70,al 
    in al,0x71
    push ax

    mov al,2
    or al.0x80
    out 0x70,al
    in al,0x71
    push ax

    mov al,4
    or al,0x80
    out 0x70,al 
    in al,0x71
    push ax
    
    mov al,0x0c

    out 0x70,al 
    in al,0x71 

    mov ax,0xb800
    mov es,ax

    pop ax
    call bcd_to_ascii
    mov bx,12*160 + 36*2

    mov [es:bx],ah
    mov [es:bx+2],al 

    mov al,':'
    mov [es:bx+4],al 
    not byte [es:bx+5]

    pop ax
    call bcd_to_ascii
    mov [es:bx+6],ah
    mov [es:bx+8],al 

    mov al,':'
    mov [es:bx+10],al 

    pop ax
    call bcd_to_ascii
    mov [es:bx+12],ah
    mov [es:bx+14],al 

    mov al,0x20
    out 0xa0,al 
    out 0x20,al 

    pop es
    pop dx
    pop cx
    pop bx
    pop ax

    iret

bcd_to_ascii:

        mov ah,al 
        and al,0x0f
        add al,0x30

        shr ah,4
        and ah,0x0f
        add ah,0x30

        ret

start:
    mov ax,[stack_segment]
    mov ss,ax
    mov sp,ss_pointer
    mov ax,[data_segment]
    mov ds,ax

    mov bx,init_msg

    call put_string

    mov bx,inist_msg
    call put_string

    mov al,0x70
    mov  bl,4
    mul bx

    mov bx,ax

    cli

    push es
    mov ax,0x0000
    mov es,ax
    mov word [es:bx],new_int_0x70
    mov word [es:bx+2],cs
    pop es

    mov al,0x0b
    or al,0x80
    out 0x70,al 
    mov al.0x12

    out 0x71,al 
    mov al,0x0c
    out 0x70,al 
    in al,0x71

    in al,0xa1

    and al,0xfe
    out 0xa1,al 
    sti

    mov bx,done_msg
    call put_string

    mov bx,tips_msg
    call put_string

    mov cx,0xb800
    mov ds,cx
    mov byte [12*160 + 33*2],'@'

.idle:
    hlt
    not byte [12*160 + 33 *2 +1]
    jmp .idle

put_string:
    mov cl,[bx]
    or cl,cl 
    jz .exit
    call put_char
    inc bx
    jmp put_string 

    .exit
        ret

put_char:
        push ax
        push bx
        push cx
        push dx
        push ds
        push es

        mov dx,0x3d4
        mov al,0x0e
        out dx,al 
        in al,dx
        mov ah,al 

        mov dx,0x3d4
        mov al,0x0f
        out dx,al 
        mov dx,0x3d5
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
        mov ax,0xb800
        mov es,ax
        shl bx,1
        mov [es:bx],cl 

        shr bx,1
        add bx,1

    .roll_screen:
        cmp bx,2000
        jl .set_cursor 
        mov ax,0xb800
        mov ds,ax
        mov es,ax
        cld

        mov si,0xa0
        mov di,0x00 
        mov cx,1920
        rep movsw
        mov bx,3840
        mov cx,80

    .cls:
        mov word[es:bx],0x0720
        add bx,2
        loop .cls

        mov bx,1920
    .set_cursor:

        mov dx,0x3d4
        mov al,0x0e
        out dx,al 
        mov dx,0x3d5
        mov al,bh
        out dx,al 
        mov dx,0x3d4
        mov al,0x0f
        out dx,al 
        mov dx,0x3d5
        mov al,bl
        out dx,al 

        pop es
        pop ds
        pop dx
        pop cx
        pop bx
        pop ax

        ret

SECTION data align=16 vstart=0

    init_msg   db 'Starting',0x0d,0x0a,0
    inst_msg   db  'Install a new inter',0
    done_msg   db  'Done',0x0d,0x0a,0
    tips_msg   db  'Clock is now working',0



SECTION stack align=16 vstart=0

        resb 256

ss_pointer:

SECTION program_trail

program_end:
    

