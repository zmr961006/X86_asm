
mov edi ,salt
mov ecx ,salt_items

.b3:
    push ecx 
    mov  eax,[edi+256]
    mov  bx,[edi+260]
    mov  cx,1_11_0_1100_000_00000B

    call sys_routine_seg_sel:make_gate_descriptor
    call sys_routine_seg_sel:set_up_gdt_descriptor
    mov [edi+260],cx
    add edi,salt_item_len
    pop ecx 
    loop .b3

