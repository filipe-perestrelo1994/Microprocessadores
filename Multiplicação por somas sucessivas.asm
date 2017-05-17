; multi-segment executable file template.

data segment

 var1 db 2
 var2 db 5
 res db 0





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
    mov al, 0
    mov ah, var1
    mov bl, var2
    cmp ah,bl ;Qual o maior
    jb eficiente
    jmp ciclo
    
    
    eficiente:
    mov ch,ah
    mov ah,bl
    mov bl,ch
    
    
    ciclo:
    inc cl
    add al,ah    
    cmp cl,bl
    je fim
    jmp ciclo


    
    fim:
    mov res,al
    
            
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
