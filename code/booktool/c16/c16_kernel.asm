core_code_seg_sel       equ     0x38
core_data_seg_sel       equ     0x30 
sys_routine_seg_sel     equ     0x28
video_ram_seg_sel       equ     0x18 
core_stack_seg_sel      equ     0x08


core_length      dd  core_end
sys_routine_seg  dd  section.sys_routine.start
core_data_seg    dd  section.core_data.start 
core_code_seg    dd  section.core_code.start 
core_entry       dd  start
                 dw  core_code_seg_sel 

    [bits 32]

SECTION sys_routine  vstart = 0

put_string:

put_char:

read_hard_disk_0: /*读程序*/

put_hex_dword:   /*调试*/

set_up_gdt_descriptor:    /*GDT 安装一个新的描述符*/

make_seg_descriptor:      /*构造存储器和系统的段描述符*/

make_gate_descriptor:     /*构造门描述符*/

allocate_a_4K_page:       /*分配一个4KB的页*/

alloc_inst_a_page:        /*分配一个页，并安装在当前活动的层级分页结构中*/

create_copy_cur_pdir:     /*创建新页目录，并复制当前页目录内容*/

terminate_current_task:   /*终止当前任务*/

SECTION core_data vstart = 0

    pgdt  dw 0
          dd 0 

    page_bit_map 

    page_map_len  equ  $-page_bit_map 

    salt:  /*若干地址符号检索表*/

    message : /*字符串*/


SECTION core_code vstart=0

fill_descriptor_in_ldt:    /*在LDT内安装一个新的描述符*/
 
load_relocate_program:     /*加载并重定位用户程序*/

append_to_tcb_link:        /*在TCB链上追加任务控制块*/

start:

    mov ecx,1024           /*清零页目录*/
    mob ebx,0x00020000
    xor esi,esi 
 .b1:
    mov dword [es:ebx+esi],0x00000000
    add esi,4
    loop .b1

    


