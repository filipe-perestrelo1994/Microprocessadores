; multi-segment executable file template.

data segment
    ; add your data here!
    timer1 db 2  
    timer2 db 5
    controlo db 1
    controlo2 db 1 
    tempos db 0
    tempoms db 0
   
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
  timerinicio:  
    push bx
    push cx 
    mov controlo, 0
    mov controlo2, 0
    Timer: 
           
        mov ah,2ch
        int 21h
        mov cl, controlo2
        cmp cl, 0
        mov controlo2, cl
        ja mseccheck
        mov cl, controlo
        cmp cl, 0
        mov controlo, cl
        ja checksec
        jmp storage
        
        
        storage:
          
            mov tempos, dh ;bh tem tempo inicial (s)
            mov tempoms, dl ;bl tem tempo inicial (ms)
            add controlo, 1
            jmp timer
        
        
        checksec:
            mov bh, tempos
            cmp dh, bh
            jae gettimers
            add dh, 60
            jmp gettimers
            
            gettimers:
            sub dh, bh ; novo tempo - tempo inicial (s)
            mov ch, timer1                
            cmp dh, ch
            je checkmsec
            jmp timer
        
        checkmsec:
            mov ah, 02h
            mov dl, dh
            add dl, '0'
            int 21h
            cmp timer2, 0
            add controlo2, 1
            ja mseccheck
            jmp endt
            
            
        mseccheck:
            mov bl, tempoms
            cmp dl, bl
            jae gettimerms
            add dl, 100
            jmp gettimerms
            
            gettimerms:  
            sub dl, bl
            mov dh, 0    ; dx somente fica com milisegundos
            mov ax, dx
            mov dx, 0
            mov cx, 10        
            div cx   
            mov cl, timer2
            cmp dl, cl
            je endt
            jmp timer
            

endt:     

    mov ah, 02h
    add dl, '0'
    int 21h     
  
    pop dx
    pop cx
    jmp timerinicio
    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

end start ; set entry point and stop the assembler.
