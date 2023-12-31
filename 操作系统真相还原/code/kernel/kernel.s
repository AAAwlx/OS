[bits 32]
%define ERROR_CODE nop  

%define ZERO push 0

extern idt_table
section .data
global intr_entry_table
intr_entry_table:
%macro VECTOR 2
section .text 
intr%1entry:
    %2
    push ds
    push es 
    push gs
    push fs
    pushad
;向8259A写入中断结束的信息
    mov al,0x20
    out 0xa0, al    ;向从片上发送
    out 0x20, al    ;向从片上发送
    push %1;将中断号入栈
    call [idt_table+%1*4];调用中断号对应的处理程序
    jmp intr_exit;结束后跳到结束退出程序
section .data  
    dd intr%1entry
%endmacro

section .text 
global intr_exit 
intr_exit:    
;返回中断发生的地址
    add esp,4
    popad
    pop fs
    pop gs 
    pop es 
    pop ds 
    add esp,4
    iretd
VECTOR 0x00, ZERO
  VECTOR 0x01, ZERO
  VECTOR 0x02, ZERO
  VECTOR 0x03, ZERO
  VECTOR 0x04, ZERO
  VECTOR 0x05, ZERO
  VECTOR 0x06, ZERO
  VECTOR 0x07, ZERO
  VECTOR 0x08,ERROR_CODE
  VECTOR 0x09,ZERO
  VECTOR 0x0a,ERROR_CODE
  VECTOR 0x0b,ERROR_CODE 
  VECTOR 0x0c,ZERO
  VECTOR 0x0d,ERROR_CODE
  VECTOR 0x0e,ERROR_CODE
  VECTOR 0x0f,ZERO 
  VECTOR 0x10,ZERO
  VECTOR 0x11,ERROR_CODE
  VECTOR 0x12,ZERO
  VECTOR 0x13,ZERO 
  VECTOR 0x14,ZERO
  VECTOR 0x15,ZERO
  VECTOR 0x16,ZERO
  VECTOR 0x17,ZERO 
  VECTOR 0x18,ERROR_CODE
  VECTOR 0x19,ZERO
  VECTOR 0x1a,ERROR_CODE
  VECTOR 0x1b,ERROR_CODE 
  VECTOR 0x1c,ZERO
  VECTOR 0x1d,ERROR_CODE
  VECTOR 0x1e,ERROR_CODE
  VECTOR 0x1f, ZERO
  VECTOR 0x20, ZERO    ;时钟中断对应的入口
  VECTOR 0x21, ZERO    ;键盘中断对应的入口 
  VECTOR 0x22, ZERO    ;级联用的
  VECTOR 0x23, ZERO    ;串口2对应的入口
  VECTOR 0x24, ZERO    ;串口1对应的入口
  VECTOR 0x25, ZERO    ;并口2对应的
  VECTOR 0x26, ZERO    ;软盘对应的入口
  VECTOR 0x27, ZERO    ;并口 1 对应的入口
  VECTOR 0x28, ZERO    ;实时时钟对应的入口
  VECTOR 0x29, ZERO    ;重定向
  VECTOR 0x2a, ZERO    ;保留
  VECTOR 0x2b, ZERO    ;保留
  VECTOR 0x2c, ZERO    ;ps/2 鼠标
  VECTOR 0x2d, ZERO    ;fpu 浮点单元异常
  VECTOR 0x2e, ZERO    ;硬盘
  VECTOR 0x2f, ZERO    ;保留