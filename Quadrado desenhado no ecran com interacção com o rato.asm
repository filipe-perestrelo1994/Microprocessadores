; multi-segment executable file template.

data segment


  strDentro db "Click dentro do quadrado",0Dh,00h
  strFora db   "Click fora do quadrado  ",0Dh,00h
  strSpace db  "                        ",0Dh,00h

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

    
    mov al,13h
    mov ah,0
    int 10h


    mov cx,20
    mov dx,20
    
        
    CicloLinha1:
    mov al, 0011b
    mov ah,0Ch
    int 10h
    
    add dx,1
    cmp dx,100
    je CicloColuna1
    
    jmp CicloLinha1
    
    
    
    
    CicloColuna1:
    mov al, 1101b
    mov ah,0Ch
    int 10h
    
    add cx,1
    cmp cx,100
    je CicloLinha2
   
    jmp CicloColuna1
    
    
    
    
    CicloLinha2:
    mov al, 1111b
    mov ah,0Ch
    int 10h
    
    sub dx,1
    cmp dx,20
    je CicloColuna2
   
    jmp CicloLinha2
    
    
    
    
    CicloColuna2:
    mov al, 1100b
    mov ah,0Ch
    int 10h
    
    sub cx,1
    cmp cx,20
    je IniciaRato
   
    jmp CicloColuna2
    
;-------------------------------------RATO---------------------------------------    
    IniciaRato:
    
    mov ax,0
    int 33h
    
    
    CicloRato:
    
    mov ax,3
    int 33h
    
    cmp bx,2
    jae FimDoPrograma
    cmp bx,1
    je VerificaX
    jmp CicloRato
    
    
    
    
    VerificaX:
    cmp cx,40
    jae VerificaX1
    jmp EscreveFora
    
    VerificaX1:
    cmp cx,200
    jbe VerificaY
    jmp EscreveFora
    
    
    VerificaY:
    cmp dx,20
    jae VerificaY1
    jmp EscreveFora
    
    VerificaY1:
    cmp dx,100
    jbe EscreveDentro
    jmp EscreveFora
    
   
    
    EscreveFora:
    mov si, offset strFora
    call printStr
    jmp BIOS
    
    
    EscreveDentro:
    mov si, offset strDentro
    call printStr
    jmp BIOS
    
    
    
    BIOS:
    mov ah,86h
    mov cx,0
    mov dx,2000
    int 15h
    
    mov si,offset strSpace
    call printStr
    jmp CicloRato
    
    
    
    FimDoPrograma:
    
    
    mov ax, 4c00h ; exit to operating system.
    int 21h
 
 
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
    
    
    
    
    
    
    
    
    
        
ends

end start ; set entry point and stop the assembler.
