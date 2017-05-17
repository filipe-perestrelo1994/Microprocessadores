; multi-segment executable file template.

data segment
    
     array db 100 db dup(0) 
     maior db 0
     
    
    
    
    
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
    
    
    
    
    mov cl, 0
    mov si, offset array
    mov al, 5
    mov bl, 0
    
    ciclo:
    mov byte ptr [si],al
    mov ah, byte ptr [si]
    cmp ah,bl
    ja tratamento
    
    continua:
    add al, 5    
    inc si
    inc cl
    cmp cl, 99
    je fim
    jmp ciclo
    
    tratamento:
    mov bl,ah
    jmp continua



    fim:
    mov maior,bl

            
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
