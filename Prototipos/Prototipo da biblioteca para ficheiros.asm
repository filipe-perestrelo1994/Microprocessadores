; multi-segment executable file template.

data segment

    Filename db "Recordes.txt"
    FHndl dw ?
    Buffer db 100 dup ?
    
    
    palavras db 4 dup ('a')




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


;---------------------fOpen-------------------------------
    
     mov ah, 3dh         ;Open the file
     mov al, 2           ;Open for reading/writing
     lea dx, Filename    ;Presume DS points at filename
     int 21h             ; segment.
     jc  BadOpen
     mov FHndl, ax       ;Save file handle

;---------------------------------------------------------


;------------------------fseek----------------------------
     mov ah,42h
     mov al,0
     mov bx,FHndl
     mov cx,0
     mov dx,50
     int 21h
          
     jc ReadError
;---------------------------------------------------------


;-----------------------fwrite----------------------------
     mov bx,FHndl
     mov cx,4
     mov dx,offset palavras
     mov ah,40h
     int 21h 

     
     jc ReadError
;---------------------------------------------------------


     mov ah,42h
     mov al,0
     mov bx,FHndl
     mov cx,0
     mov dx,0
     int 21h
          
     jc ReadError


;-----------------------fread-----------------------------

LP:  mov     ah,3fh          ;Read data from the file
     lea     dx, Buffer      ;Address of data buffer
     mov     cx, 1           ;Read one byte
     mov     bx, FHndl       ;Get file handle value
     int     21h
     jc      ReadError
     cmp     ax, cx          ;EOF reached?
     jne     EOF
     mov     al, Buffer      ;Get character read
     call    co                    ;Print it
     jmp     LP              ;Read next byte

EOF: mov     bx, FHndl
     mov     ah, 3eh         ;Close file
     int     21h
     jc      CloseError
    
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
    


ReadError:    
BadOpen:
CloseError:    
    









            
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
