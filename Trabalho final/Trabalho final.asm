; multi-segment executable file template.

data segment
    
  strMenu db "-Identificacao do jogador",0Ah,0Dh,"-Consultar Top 5",0Ah,0Dh,"-Novo Jogo",0Ah,0Dh,"-Sair",0  
    
  opcao db 0  
    
  var1 db 0 ;Variavel que verifica se o nome foi introduzido antes de comecar o jogo (1-sim,0-nao)
  
  var2 db 0 ;variavel que verifica se o jogador jogou o jogo (1-sim, 0-nao)
  
  var3 db 0 ;variavel que verifica se o genero pode ser definido (1-sim, 0-nao)
    
  strAviso db "Tem de introduzir um nome antes de iniciar o jogo!"
  
  BufNome db 100 dup (?)      
    
  nl db 0Ah,0Dh,0
  
  space db 6 dup (' '),0
  
  space2 db 4 dup (09h),0 
  
  BufPalavras db 100 dup (?)
  
  genero db 0 ;(1-Masculino, 2-Feminino)
  
  
  
  
  strPontos db "Pontos:",0   
    
  pontos db 0  
  
  
  
  strNivel db "Nivel:",0
  
  nivel db 1
  
  cnt db 0 ;Contador para o procedimento Write Unsigned
  
  
  
  contador db 0 ;contador para o numero de espacos 
  
  
  
  FHndl dw 0
  Filename dw "C:\Palavras.txt"
  
  ResultsHandle dw 0
  Results dw "C:\Resultados.txt"
   
    
    
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


;------------------------CODIGO DO JOGO---------------------------

    
    
    inicio:
    mov si, offset strMenu
    call printStr

    call menu
   
    mov bl,opcao
    cmp bl,4
    je FimDoPrograma
    cmp bl,3
    je NovoJogo
    cmp bl,2
    je Top5
    cmp bl,1
    je IntroduzNome




    IntroduzNome:
    call clrScreen
    mov si, offset BufNome
    call readk
    jmp inicio





    
    
    
    
    
    
    
    
    Top5:
    

    
    
    
    
    
    
    
    
    
    
    
    NovoJogo:
    mov dl,var1
    cmp dl,1
    jb Aviso
    
    mov dh,1
    mov var2,dh
    
     
    call Newgame
    jmp FimDoPrograma
    
    Aviso:
    call clrScreen
    mov si, offset strAviso    
    call printStr
    call clrScreen
    jmp inicio














    FimDoPrograma:

    mov dh,var2
    cmp dh,1
    jb Saida
            
;    ;Data e hora,pontuacao, Nome do Jogador
;    
;    mov ah,2Ah
;    int 21h 
;    
;    ;Tratar do ano????
;
;    mov ah,2Ch
;    int 21h
;    
;    
;    
;    
;    
;    
;    
;            
;            
;            
;    mov al, 1           ;Open for writing
;    lea dx, Results     ;Presume DS points at Results
;    call fOpen
;    mov ResultsHandle,ax ;save Resultados' Handle
;   
;   
;    mov al,2           ;end of file
;    mov bx,ResultsHandle
;    mov cx,0
;    mov dx,0
;    call fseek
;    
;    mov bx,ResultsHandle
;    mov cx,1;TamanhoString
;    lea dx,Results
;    call fwrite
;    
;    
;    
;    
;    
    
    
    Saida:
    
    mov ax, 4c00h ; exit to operating system.
    int 21h




    
;-----------------------PROCEDIMENTOS-----------------------------    
    






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
    
;--------------------------------Menu-----------------------------    
proc menu    
    
    rato:
    mov ax, 0000
    int 33h
    mov ax,0003
    int 33h
    
    cmp bx,1
    je opcoes

    jmp rato    
    
    opcoes:
    
    cmp dx,32
    ja rato     
    
    cmp dx,23
    jae VerificaSair
    
    cmp dx,16
    jae VerificaNovoJogo
    
    cmp dx,8
    jae VerificaTop5
    
    cmp cx,200
    jbe opcaoIntroduzNomeJogador
    ja rato
    
    VerificaTop5:
    cmp cx,129
    jbe opcaoTop5
    ja rato
    
    VerificaNovoJogo:
    cmp cx,81
    jbe opcaoNovoJogo
    ja rato
    
    VerificaSair:
    cmp cx,40
    jbe opcaoSair
    ja rato
    
    jmp rato
    
    
    
    opcaoIntroduzNomeJogador:
    mov al,1
    mov opcao,al
    jmp FimDoMenu 
    
    opcaoTop5:
    mov al,2
    mov opcao,al
    jmp FimDoMenu
    
    opcaoNovoJogo:
    mov al,3
    mov opcao,al
    jmp FimDoMenu
    
    opcaoSair:
    mov al,4
    mov opcao,al
    jmp FimDoMenu
    
    
    
    FimDoMenu:ret 
    
    
menu endp    
    
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
mov dl,1
mov var1,dl
ret

readK endp

;-------------------------------CLEAR SCREEN-------------------------------
 clrScreen proc
        
    push ax
    mov al, 03h ;video mode
    mov ah,0; set video mode
    int 10h
    pop ax
 
    ret
 clrScreen endp
;--------------------------------------------------------------------------




                                ;NEWGAME



;**************************************************************************
proc Newgame
    
    
    call clrScreen
    
    mov si, offset BufNome
    call printStr
    
    
    mov si, offset space
    call printStr
    
    
    mov si, offset strNivel
    call printStr
    
    
    mov ah,0
    mov al,nivel
    call writeUns
    
    
    mov si, offset space
    call printStr
    
    
    mov si, offset strPontos
    call printStr
    
        
    mov ah,0
    mov al,pontos
    call writeUns
    
    
    
    
    
    
    
    
    
    mov al, 0           ;Open for reading
    lea dx, Filename    ;Presume DS points at filename
    call fOpen
    mov FHndl, ax       ;Save file handle
    
    
    
    
    mov si, offset nl
    call printStr
    
    

    mov si, offset space2
    call printStr
    
    
    
    mov     bx, FHndl       ;Get file handle value
    lea     dx, BufPalavras      ;Address of data buffer
    call fread
    
    mov si, offset BufPalavras
    call printStr
    
    
    
    
    
    

    
    ret
Newgame endp 
;**************************************************************************







;------------------------fOpen-------------------------------
proc fOpen    
     
     mov ah, 3dh         ;Open the file
     int 21h             ; segment.
     jc  BadOpen
     
     ret
     
     BadOpen:
     call fcreate
     
fOpen endp     
;---------------------------------------------------------
;------------------------fseek----------------------------
proc fseek     
     
     mov ah,42h
     int 21h
          
     jc ReadError2
     
     ReadError2:
     
     ret
     
fseek endp     
;---------------------------------------------------------
;------------------------fcreate-------------------------
proc fcreate 
    mov cx,0
    
    mov dh,0
    
    mov ah,3Ch
    int 21h
    
    jc CreateError
    
    
    CreateError:
    ret
    
    
fcreate endp
;---------------------------------------------------------
;-----------------------fwrite----------------------------
proc fwrite

     
     mov ah,40h
     int 21h 

     
     jc ReadError1
     
     
     ReadError1:
     
     ret
     
fwrite endp
;---------------------------------------------------------
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
;---------------------------Random-----------------------
proc Random
    




Random endp
;--------------------------------------------------------
;---------------------------Timer------------------------
proc Timer
    
    
    
    
    
    

Timer endp
;--------------------------------------------------------
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
    je tratamento1
    
    jmp divisao
    
    
    tratamento1:
    pop ax
    add ax,30h
    mov ah,2
    mov dl,al
    int 21h
    dec ch
    cmp ch,0
    je fim
    jmp tratamento1
    
    
    fim:
    ret    
    
WriteUns endp


;*****************************************************************    
    



;-----------------------fread-----------------------------
proc fread

     
     
     
LP:  mov     ah,3fh          ;Read data from the file
     
     mov     cx, 1           ;Read one byte
     
     int     21h
     jc      ReadError
     
     
     
     cmp     ax, cx          ;EOF reached?
     jne     EOF

     
     
     mov     al, BufPalavras      ;Get character read
     
     mov dl,var3
     cmp dl,1
     je DefineGeneroMasculino
     
     
     
     cmp al,3Ah
     je defineGenero
     
     cmp al,0Dh
     je  CloseError
     
     call co

     jmp     LP
     
     defineGenero:
     mov var3,1
     jmp LP
     
     Genero1:
     cmp al,4Dh
     je defineGeneroMasculino
     mov genero,2
     jmp Close
     
     
     defineGeneroMasculino:
     mov genero,1
     jmp Close
     
                   ;Read next byte

EOF: mov     bx, FHndl
     mov     ah, 3eh         ;Close file
     int     21h
     jc      CloseError
                       
     ReadError:              
     CloseError:
     Close:
     ret

fread endp                       
;--------------------------------------------------------








    
    
        
ends

end start ; set entry point and stop the assembler.
