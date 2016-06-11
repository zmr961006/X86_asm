         ;代码清单8-1
         ;文件名：c08_mbr.asm
         ;文件说明：硬盘主引导扇区代码（加载程序） 
         ;创建日期：2011-5-5 18:17
         
         app_lba_start equ 100           ;声明常数（用户程序起始逻辑扇区号)方便以后修改
                                         ;常数的声明不会占用汇编地址
                                    
SECTION mbr align=16 vstart=0x7c00       ;所有汇编地址都从这里开始，                              

         ;设置堆栈段和栈指针 ,ss:sp = 0x0000 ~ 0xFFFF,共64KB
         mov ax,0      
         mov ss,ax
         mov sp,ax
      
         mov ax,[cs:phy_base]            ;计算用于加载用户程序的逻辑段地址 ax:dx 保存32位地址，起始最多20位
         mov dx,[cs:phy_base+0x02]
         mov bx,16                       ;将该地址转换成16位段地址，并传送到es,ds 
         div bx            
         mov ds,ax                       ;令DS和ES指向该段以进行操作
         mov es,ax                        
    
         ;以下读取程序的起始部分 
         xor di,di
         mov si,app_lba_start            ;程序在硬盘上的起始逻辑扇区号 
         xor bx,bx                       ;加载到DS:0x0000处 
         call read_hard_disk_0
      
         ;以下判断整个程序有多大
         mov dx,[2]                      ;读取用户程序头，保存数据长度
         mov ax,[0]
         mov bx,512                      ;512字节每扇区
         div bx
         cmp dx,0
         jnz @1                          ;未除尽，因此结果比实际扇区数少1 
         dec ax                          ;已经读了一个扇区，扇区总数减1 
   @1:
         cmp ax,0                        ;考虑实际长度小于等于512个字节的情况 
         jz direct
         
         ;读取剩余的扇区
         push ds                         ;以下要用到并改变DS寄存器 

         mov cx,ax                       ;循环次数（剩余扇区数）
   @2:
         mov ax,ds
         add ax,0x20                     ;得到下一个以512字节为边界的段地址
         mov ds,ax                       ;加0x20好偏移  
                              
         xor bx,bx                       ;每次读时，偏移地址始终为0x0000 
         inc si                          ;下一个逻辑扇区 
         call read_hard_disk_0
         loop @2                         ;循环读，直到读完整个功能程序 

         pop ds                          ;恢复数据段基址到用户程序头部段 
      
         ;计算入口点代码段基址 
   direct:
         mov dx,[0x08]                   ;读取加载文件头，计算段地址
         mov ax,[0x06]
         call calc_segment_base
         mov [0x06],ax                   ;回填修正后的入口点代码段基址 
      
         ;开始处理段重定位表
         mov cx,[0x0a]                   ;需要重定位的项目数量
         mov bx,0x0c                     ;重定位表首地址
          
 realloc:
         mov dx,[bx+0x02]                ;32位地址的高16位 
         mov ax,[bx]
         call calc_segment_base
         mov [bx],ax                     ;回填段的基址
         add bx,4                        ;下一个重定位项（每项占4个字节） 
         loop realloc 
      
         jmp far [0x04]                  ;转移到用户程序  
 
;-------------------------------------------------------------------------------
read_hard_disk_0:                        ;从硬盘读取一个逻辑扇区
                                         ;输入：DI:SI=起始逻辑扇区号
                                         ;      DS:BX=目标缓冲区地址
         push ax
         push bx
         push cx
         push dx
      
         mov dx,0x1f2                    ;0x1f2 端口,这个端口保存入的扇区数量
         mov al,1
         out dx,al                       ;读取的扇区数

         inc dx                          ;0x1f3  
         mov ax,si
         out dx,al                       ;LBA地址7~0

         inc dx                          ;0x1f4
         mov al,ah
         out dx,al                       ;LBA地址15~8

         inc dx                          ;0x1f5
         mov ax,di
         out dx,al                       ;LBA地址23~16

         inc dx                          ;0x1f6
         mov al,0xe0                     ;LBA28模式，主盘 
         or al,ah                        ;LBA地址27~24   高三位为111
         out dx,al

         inc dx                          ;0x1f7   向这个端口写入等与请求读取硬盘
         mov al,0x20                     ;读命令
         out dx,al

  .waits:
         in al,dx                        ;硬盘开始忙碌
         and al,0x88
         cmp al,0x08                     ;比较是否就绪 
         jnz .waits                      ;不忙，且硬盘已准备好数据传输 

         mov cx,256                      ;总共要读取的字数
         mov dx,0x1f0                    ;连续取出接口
  .readw:
         in ax,dx                        ;读取一个字，2字节
         mov [bx],ax
         add bx,2                        ;循环256次共512字节 
         loop .readw

         pop dx
         pop cx
         pop bx
         pop ax
      
         ret                             ;读取函数返回

;-------------------------------------------------------------------------------
calc_segment_base:                       ;计算16位段地址
                                         ;输入：DX:AX=32位物理地址
                                         ;返回：AX=16位段基地址 
         push dx                          
         
         add ax,[cs:phy_base]           
         adc dx,[cs:phy_base+0x02]
         shr ax,4
         ror dx,4
         and dx,0xf000
         or ax,dx
         
         pop dx
         
         ret

;-------------------------------------------------------------------------------
         phy_base dd 0x10000             ;用户程序被加载的物理起始地址，也可以是别的地址但是必须空闲，并且16对齐
         
 times 510-($-$$) db 0
                  db 0x55,0xaa
