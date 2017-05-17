; multi-segment executable file template.

data segment


    num1 db 5
    num2 db 6


    
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


    mov bl,num1
    mov bh,num2
    call soma
    
    mov al,num2
    mov ah,0

    
    push bx  
    call multiplicacao
            
    call trocavalores
  
              fim:
    mov ax, 4c00h ; exit to operating system.
    int 21h
    
    
;-----------------------------Soma-----------------------------    
proc soma
    
    add bl,bh
    mov bh,0
    ret

soma endp    
;--------------------------------------------------------------

;------------------------multiplicacao-------------------------
proc multiplicacao 
     
    mov bp,sp
    mul word ptr [bp+2]
    
    ret 2
    
multiplicacao endp
;--------------------------------------------------------------

;-------------------------trocavalores-------------------------
proc trocavalores
    
    mov bp,sp
    push bp                       
                        
    sub sp,2
    
    mov word ptr [bp-2],ax
    mov ax,bx
    mov bx,word ptr [bp-2]
    
    pop bp
    mov sp,bp
    
    ret 
    
trocavalores endp
;--------------------------------------------------------------
    
        
ends

end start ; set entry point and stop the assembler.
