; multi-segment executable file template.

data segment

      Tab1 db "Bola      ",0
      Tab11 db "Salto     ",0
      Tab12 db "Futebol   ",0
      
       
      Tab2 db "Bola      ",0
      Tab21 db "Golo      ",0
      Tab22 db "Futebol   ",0

      
      nl db 0Ah,0Dh,0
      
      
      StrResults db "Results:",0
      StrTrue db "True",0
      StrFalse db "False",0
      
      letra db 0
      
      


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

;    mov si,offset StrResults
;    call printStr
;    mov si,offset nl
;    call printStr
;    
;    mov si,offset Tab1
;    mov di,offset Tab2
;    call cmpString
;    
;    mov si,offset nl
;    call printStr
;    
;    mov si,offset Tab11
;    mov di,offset Tab21
;    call cmpString
;    
;    mov si,offset nl
;    call printStr
;    
;    mov si,offset Tab12
;    mov di,offset Tab22
;    call cmpString
 

     mov ah,1
     int 21h
     mov letra,al
     
     mov si,offset StrResults
     call printStr
     mov si,offset nl
     call printStr
     
     mov di,offset Tab2
     call cmpChar
     mov si,offset nl
     call printStr
     
     mov di,offset Tab21
     call cmpChar
     mov si,offset nl
     call printStr
     
     mov di,offset Tab22
     call cmpChar




    
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

;*****************************************************************
;Compara String
;*****************************************************************
cmpString proc
    
    mov cx,10
    
    
    repe cmpsb    
    jz Tratamento
   

    Tratamento:
    cmp cx,00h
    je printTrue
    jmp printFalse
    
    
    printTrue:
    mov si, offset StrTrue
    call printStr
    jmp fim    
    
    printFalse:                             
    mov si,offset StrFalse
    call printStr
    
    fim:
    ret    
cmpString endp
;***********************************************************
;Compara char
;***********************************************************
cmpChar proc
    
    mov al,letra
    mov cx,10
    repne scasb
    jz Tratamento2
    
    
    Tratamento2:
    cmp cx,00h
    je printFalse2
    mov si, offset StrTrue
    call printStr
    jmp fim2
    
    
    
    printFalse2:                             
    mov si,offset StrFalse
    call printStr
    
    fim2:
    ret
cmpChar endp








ends

end start ; set entry point and stop the assembler.
