; multi-segment executable file template.

data segment
    var1 db 5
    var2 db 2
    res db ?

   
   
   
    pkey db "press any key...$"
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax
    
    mov al,var1
    mov ah,var2
    add al,ah
    mov res,al


            
   
    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

end start ; set entry point and stop the assembler.
