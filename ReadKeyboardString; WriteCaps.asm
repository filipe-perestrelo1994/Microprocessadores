; multisegment executable file template.


data segment

;strola db "Ola malta, tudo bem???",0dH,0aH,0
;strpri db "Vamos iniciar a nossa aula!!!",0dH,0aH,0

buffer db 100 dup ?


ends


stack segment

dw 128 dup(0)

ends


code segment
start:
; set segment registers:
mov ax, data
mov ds, ax
mov es, ax




;mov si, offset strola
;call printStr
;mov si,offset strpri
;call printStr 

mov si, offset buffer

call readK

mov si, offset buffer

call writeCaps




mov ax,4c00h ; terminate program
int 21h


;****************************************************************
;Read Keyboard
;****************************************************************
proc readK

ciclo:
mov ah,01h
int 21h
cmp al,0Dh
je terminar
mov byte ptr si,al
inc si
jmp ciclo 

terminar:
ret



readK endp

;*****************************************************************
;WriteCapsString
;*****************************************************************
proc writeCaps
    
    write:
    mov dl,byte ptr si
    cmp dl,61h
    jae verifica
    jmp escreve
    
    verifica:
    cmp dl,7Ah
    jbe tratamento
    jmp escreve
    
    tratamento:
    sub dl,20h
     
    
    escreve:
    mov ah,2
    int 21h
    inc si
    mov al,byte ptr si
    cmp al,00h
    je retorno
    jmp write
    
    retorno:
    ret
    
writeCaps endp
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