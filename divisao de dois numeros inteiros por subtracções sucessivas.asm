; multi-segment executable file template.

data segment
    
     num1 db 5
     num2 db 5
    
     quoc db 0
     resto db 0
    
    
    
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

    mov al,num1
    mov ah,num2 
    mov cl,0
    
    divisao:
    cmp al,ah
    jb resultado
    
    inc cl
    sub al,ah
    jmp divisao

    resultado:
    mov resto,al 
    mov quoc,cl

            
    lea dx, pkey
    mov ah, 9
    int 21h        ; output string at ds:dx
    
    ; wait for any key....    
    mov ah, 1
    int 21h
    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

end start ; set entry point and stop the assembler.
