jmp near start

message db '1+2+3+...+100='   ;数据声明方式基本兼容masm

start:

        mov ax,0x7c0          ;设置加载的数据段地址 
        mov ds,ax

        mov ax,0xb800         ;设置显示的段地址
        mov es,ax

        mov si,message        ;设置偏移量
        mov di,0 
        mov cx,start-message

    @g:
        mov al,[si]              ;打印函数
        mov [es:di],al
        inc di
        mov byte [es:di],0x07
        inc di
        inc si
        loop @g

        xor ax,ax
        mov cx,1
    @f:
        add ax,cx             ;计算高斯数列
        inc cx
        cmp cx,100
        jle @f

        xor cx,cx             
        mov ss,cx
        mov sp,cx

        mov bx,10             
        xor cx,cx

    @d:
        inc cx      ;计算每个数位转化成ASCII码，并且入栈
        xor dx,dx
        div bx
        or dl ,0x30
        push dx
        cmp ax,0
        jne @d

    @a:
        pop dx      ;显示每个数位
        mov [es:di],dl
        inc di
        mov byte [es:di],0x07
        inc di
        loop @a

        jmp near $         ;死循环

times 510-($-$$) db 0      ;$当行，$$当节
                 db 0x55,0xaa   ;设置最后的


