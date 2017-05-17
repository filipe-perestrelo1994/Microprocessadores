; multi-segment executable file template.

data segment

    Filename db "C:\Recordes.txt"
    FHndl dw ?
    Buffer db 100 dup ?
    
    
    palavras db 4 dup ('a')

    Buffer2 db 100 dup ?


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

    call fOpen
    call fread

    mov ax, 4c00h ; exit to operating system.
    int 21h
    
;---------------------fOpen-------------------------------
proc fOpen    
     
     mov ah, 3dh         ;Open the file
     mov al, 2           ;Open for reading/writing
     lea dx, Filename    ;Presume DS points at filename
     int 21h             ; segment.
     jc  BadOpen
     mov FHndl, ax       ;Save file handle
     ret
     
     BadOpen:
     call fcreate
     
fOpen endp     
;---------------------------------------------------------


;------------------------fseek----------------------------
proc fseek     
     
     mov ah,42h
     mov al,0
     mov bx,FHndl
     mov cx,0
     mov dx,50
     int 21h
          
     jc ReadError2
     
     ReadError2:
     
     ret
     
fseek endp     
;---------------------------------------------------------


;-----------------------fwrite----------------------------
proc fwrite

     mov bx,FHndl
     mov cx,4
     lea dx, palavras
     mov ah,40h
     int 21h 

     
     jc ReadError1
     
     
     ReadError1:
     
     ret
     
fwrite endp     



;-----------------------fread-----------------------------
proc fread

     mov di, offset buffer2
     
     
LP:  mov     ah,3fh          ;Read data from the file
     lea     dx, Buffer      ;Address of data buffer
     mov     cx, 1           ;Read one byte
     mov     bx, FHndl       ;Get file handle value
     int     21h
     jc      ReadError
     
     cmp     ax, cx          ;EOF reached?
     jne     EOF
     
     

     mov ah,0
     call fReadLine
     cmp ah,1
     je CloseError
     
     
     mov ah,0
     call freadNum
     cmp ah,1              ;ah=1 (nao e um numero) -> LP
     je LP                 ;ah=0 (e um numero) -> print it
     
     
     
     
     
     
     
     
     mov     al, Buffer      ;Get character read
     
     
     
     call    co                    ;Print it
     jmp     LP              ;Read next byte

EOF: mov     bx, FHndl
     mov     ah, 3eh         ;Close file
     int     21h
     jc      CloseError
                       
     ReadError:              
     CloseError:
     ret

fread endp                       
;--------------------------------------------------------

;------------------------fcreate-------------------------
proc fcreate 
    mov cx,0
    
    mov dh,0
    lea dx, Filename
    
    mov ah,3Ch
    int 21h
    
    jc CreateError
    
    mov FHndl,ax
    
    CreateError:
    ret
    
    
fcreate endp
;--------------------------------------------------------


;-----------------------freadNum-------------------------
proc freadNum
    mov si,offset buffer
    
    mov al, byte ptr [si]
    
    cmp al,39h
    ja numError
    cmp al,30h
    jb numError
    jmp fimNum
                                                             
    numError:
    mov ah,1
    
    fimNum:
    ret                                                     
                                                         
freadNum endp                                                         
;--------------------------------------------------------

;----------------------fReadLine-------------------------
proc freadLine
    
    mov si,offset buffer
    
    mov al, byte ptr [si]
 
    cmp al, 0Ah
    je fimdalinha
    mov byte ptr di,al
    inc di
    jmp Fimfreadline
    
    
    fimdalinha:
    mov ah,1
    
    
    Fimfreadline:
    ret
    
    
;--------------------------------------------------------
    
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
