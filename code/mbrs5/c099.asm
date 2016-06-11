app_lba_start equ 100

SECTION mbr align=16  vstart=0x7c00

    mov ax,0      ;设置段地址，在设置段地址的时候，CPU禁止中断
    mov ss,ax
    mov sp,ax

    mov ax,[cs:phy_base]             ;计算程序加载的地址 AX：DX  32位 
    mov dx,[cs:phy_base + 0x02]

    mov bx,16                        ;使用32/16位除法得出,程序段开始的地址
    div bx
    mov ds,ax
    mov es,ax
    
    xor di,di                        ;读取第一个扇区  
    mov si,app_lba_start 
    xor bx,bx 
    call read_hard_disk_0

    mov dx,[2]                       ;读取整个程序大小
    mov ax,[0]
    mov bx,512      
    div bx 

    cmp dx,0                         ;是否能除尽，如果余数为0则跳转进一步判断是否是小于512
    jnz @1                           ;
    dec ax 

@1:
    cmp ax,0                  
    jz direct 

    push ds                          ;读取剩余扇区
    mov cx,ax                        ;循环次数
    
@2:
    mov ax,ds
    add ax,0x20                      ;确定下一个扇区的地址，每次重新构建一个逻辑段，512 大小
    mov ds,ax                        ;设置新的逻辑段地址

    xor bx,bx                        ;清空bx 寄存器
    inc si                           ; si 保存的是扇区个数
    call read_hard_disk_0 
    loop @2

    pop ds 

direct:                              ;目标文件段地址重定位

        mov dx,[0x08]                ;计算开始地址
        mov ax,[0x06]
        call calc_segment_base 
        mov [0x06],ax                ;将新的段地址写回

        mov cx,[0x0a]                ;确定重定位的项目数量 
        mov bx,0x0c                  ;重定位表首地址

realloc:

        mov dx,[bx+0x02]             ;设置段的重定位地址  
        mov ax,[bx]                  
        call calc_segment_base 
        mov [bx],ax 
        add bx,4 
        loop realloc 

        jmp far [0x04]


read_hard_disk_0:                ;从硬盘读取一个逻辑扇区
        push ax                  ;  di:si  ->  ds:bx
        push bx
        push cx
        push dx 

        mov dx,0x1f2             ;dx 保存端口号 
        mov al,1
        out dx,al 

        inc dx 
        mov ax,si
        out dx,al                ;LBA 地址0～7
        
        inc dx 
        mov al,ah 
        out dx,al                ;LBA 15~8 

        inc dx                  
        mov ax,di 
        out dx,al                ;LBA 23~16

        inc dx 
        mov al,0xe0              ;LBA  
        or al,ah 
        out dx,al                ;LBA   111   27~24 

        inc dx                   ;向这个端口写入等与请求读取硬盘 
        mov al,0x20 
        out dx,al                 

    .waits: 
        in al,dx                 ;从硬盘读取数据出来
        and al,0x88            
        cmp al,0x80              ;判段是不是准备好传输数据了
        jnz .waits

        mov cx,256 
        mov dx,0x1f0   

    .readw:

        in ax,dx 
        mov [bx],ax 
        add bx,2
        loop .readw 

        pop dx 
        pop cx 
        pop bx 
        pop ax 

        ret 

calc_segment_base:              ;计算16位地址 输入dx:ax 32 位
                                ; AX = 16位段地址  
        push dx 

        add ax,[cs:phy_base]     ;这里dd 是一个32位数据，我们分别做16位
        adc dx,[cs:phy_base+0x02]

        shr ax,4 
        ror dx,4 
        and dx,0xf000            ;清除低12位 
        or ax,dx                 ;结合两个地址
        pop dx

        ret 

phy_base dd 0x10000

times 510-($-$$) db 0
                 db 0x55,0xaa 
