; multi-segment executable file template.

data segment
    
    op1 db ?
    op2 db ?
    res dw ?
    
    cnt db 0
    
    nl db 0Dh,0Ah,0
    
    str1 db "Bem vindo/a a nossa calculadora!",0Dh,0Ah,"Introduza o primeiro operando:",0Dh,0Ah,0
    
    str2 db "Introduza o segundo operando",0Dh,0Ah,0 
    
    str3 db "O resultado de ",0
    
    str4 db " + ",0
    
    str5 db " e: ",0Dh,0Ah,0
    
    Serro db "Introduza um valor mais baixo",0Dh,0Ah,0
    
    Final db "Obrigado",0
    
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
    
;    mov si, offset str1
;    call printStr
    
    call ReadUns
    mov op1,cl
    
    mov si,offset nl
    call printStr
    
    mov si, offset str2
    call printStr
    
    call ReadUns
    mov op2,cl 
    
    mov si,offset nl
    call printStr
    

    mov bh,0       ;Fazer a conta
    mov ah,0
    mov bl,op1
    mov al,op2
    add ax,bx
    
    mov res,ax
    
    
    mov si,offset str3
    call printStr
    
    mov ah,0
    mov al,op1
    call WriteUns  ;Escreve o primeiro numero
    
    mov si,offset str4
    call printStr
    
    mov ah,0
    mov al,op2
    call WriteUns  ;Escreve o segundo numero
    
    mov si,offset str5
    call printStr
    
    
    mov ax,res
    call WriteUns
    
    mov si,offset nl
    call printStr
    
    mov si,offset Final
    call printStr
    
    
    
    
    
    mov ax, 4c00h ; exit to operating system.
    int 21h 
 
 
;********************************************************
proc ReadUns
    


    mov cl,0
     
    ciclo:
    mov ah,1
    int 21h ;le o numero
    
    
    cmp al,0dh
    je retorno
    
    cmp al,30h
    jb ciclo
    cmp al,39h
    ja ciclo
    
    sub al,30h
    mov bh,al 
    mov ah,0
    mov ch,0
    mov al,10
    mul cl
    jc erro      ;Carry flag activa na multiplicacao -> numero > 255
    mov cx,ax
    add cl,bh
    
    jc erro      ;Carry flag activa na soma -> numero > 255
    
    jmp ciclo    
    
    
    erro:
    mov si,offset nl   ;ERRO
    call printStr
    mov si,offset Serro
    call printStr
    mov cx,0
    jmp ciclo
    
    
    retorno:
    cmp ch,1 
    jle fimRotina
    
    
    
    
    
    fimRotina:
    ret
    
 ReadUns endp
;********************************************************    
    
;********************************************************    
proc WriteUns
    
    mov bl,10 
    mov bh,0
    mov ch,cnt
    
    divisao:
    mov dx,0
    div bx
    push dx
    inc ch
    cmp ax,0
    je tratamento
    
    jmp divisao
    
    
    tratamento:
    pop ax
    add ax,30h
    mov ah,2
    mov dl,al
    int 21h
    dec ch
    cmp ch,0
    je fim
    jmp tratamento
    
    
    fim:
    ret    
    
WriteUns endp


;*****************************************************************
; co caracter output
; descricao: rotina que faz o output de um caracter para o ecran
; input al= caracter a escrever
; output nenhum
; destroi nada
;*****************************************************************
co proc
push ax
push dx
mov ah,02H
mov dl,al
int 21H
pop dx
pop ax
ret
co endp

;*****************************************************************
; printStr string output
; descricao: rotina que faz o output de uma string para o ecran
; input si= endereco da string a escrever
; output nenhum
; destroi al, si
;*****************************************************************   
printStr proc

L1:
mov al,byte ptr [si]
or al,al
jz fimprtstr
push si
call co
pop si
inc si
jmp L1
fimprtstr: ret
printStr endp
;****************************************************************            
    
ends

end start ; set entry point and stop the assembler.
