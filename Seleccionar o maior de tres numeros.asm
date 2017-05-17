; multi-segment executable file template.

data segment
    
    num1 db 5
    num2 db 5
    num3 db 20
    
    maior db ?
    
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
    cmp al,ah
    jae comparacao
    jb troca
    
    comparacao:
    mov ah,num3
    cmp al,ah
    jae res1
    jb res2
    
    
    troca:
    mov al,ah
    jmp comparacao
    
    
    res1:
    mov maior,al
    jmp fim
    
    res2:
    mov maior,ah
    
    
    
    fim:
            
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
