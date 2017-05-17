; multi-segment executable file template.

data segment
    c1 db '1';variavel de controlo 
    c2 db '0';variavel de controlo
    x2 db 0 ; variavel de escolha
    x1 db 0 ;variavel de escolha (opcional, nao esta em uso atm)
    controlo1 db 0 ; controlo para buffer 
    controlo2 db 0 ; controlo para coordenadas
    buffer dw (2) ; string na qual sao colocados os numeros
    tab dw 0dh, 0ah,0
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

;----------------------RNG--------------------------------------

RNG:; gera numero de 3 digitos aleatorios
   
   mov si, offset buffer
   push bx        


Randomstart:

    mov ah, 2ch  ; obtem tempo do sistema        
    int 21h      ; dl tem milisegundos
   
    mov dh, 0    ; dx somente fica com milisegundos
    mov ax, dx
    mov dx, 0
    mov cx, 10    
    div cx       ; dx contem o resto da divisao (0 a 9)

    add  dl, '0'  ; converte para ASCII o que esta em dl 
   
    push bx
    mov bh, x2
    cmp bh, 0     ;verifica se passou por numum
    je numum
    pop bx        ;pop realzado para nao danificar algum valor guardado em bx
    jmp adicionanumero

   
   numum:
   
    cmp c1, dl ; verifica se numero maior que 1
    jae ifz
    jmp randomstart ; repete ciclo

    
   ifz:
    cmp c2, dl
    jne preparacao
    inc bh
    mov x2, bh
    pop bx
    jmp controlo 
          
    
   preparacao:  ;proximo ciclo vai diretamente par adicionanumero
   
    inc bh
    mov x2, bh
    pop bx
    jmp adicionanumero
   

   adicionanumero:  ;adiciona o numero gerado a buffer
   
    mov byte ptr[si], dl
    inc si     
    jmp controlo
    
   controlo: 
    push bx
    mov bl, controlo1
    inc bl 
    cmp bl, 2 ;verifica se adicionou 2 digitos
    jae fim  
    mov controlo1, bl
    pop bx
    jmp randomstart ; repete ciclo    
   
  
; ;-----CONTINUACAO PARA VERIFICACAO COORDENADAS-------
;                                                        
;                                                        
; push bx
; mov bl, controlo2
; cmp 1,bl
; jbe verficaX
; jmp verificaY 
; 
; 
; verificaX:
;  mov bh, dl ;random number
;  cmp Z, bh; comparacao de limite superior
;  jbe verificaX2:
;  jmp overboard   
;  
; 
; verificaX2:
;  cmp z, bh; comparacao limite inferior
;  pop bx
;  jae aplicaX
;  jmp overboard
; 
;
; aplicaX:
;  ...........;codigo para meter as coordenadas onde a palavra sera escrita
;  inc bl
;  mov controlo2, bl
;  pop bx
;  jmp randomstart
;  
; 
; verificaY:
;  mov bh, dl ;random number
;  cmp Z, bh; comparacao de limite superior
;  jbe verificaY2:
;  jmp overboard
;  
;     
; verificaY2:
;  cmp z, bh; comparacao limite inferior
;  pop bx
;  jae aplicaY
;  jmp overboard   
;  
;  
; aplicaY:
;  ...........;codigo para meter as coordenadas onde a palavra sera escrita
;  mov controlo2, bl
;  pop bx
;
;  RET; retorna ao programa principal
;  
;           
; overboard:
;  mov controlo2, bl
;  pop bx
;  jmp randomstart
;
  
 fim:
  pop bx
  mov si, offset buffer 
  call printStr ; escreve no ecra o que esta no buffer          
  jmp randomstart 
  
  
  
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends
 
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
    
 
 
end start ; set entry point and stop the assembler.
