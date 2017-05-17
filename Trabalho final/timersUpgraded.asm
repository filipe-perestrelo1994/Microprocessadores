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
    mov controlo, 0
    mov controlo2, 0
    
    
    Timer: 
           
        mov ah,2ch
        int 21h ;interrupt para tirar o tempo do sistema
        mov cl, controlo2
        cmp cl, 0 ;verifica se 
        ja MsecCheck
        mov cl, controlo
        cmp cl, 0 ; verifica se guardou tempo inicial
        ja CheckSec
        mov tempos, dh ;tempos tem tempo inicial (s)
        mov tempoms, dl ;tempoms tem tempo inicial (ms)
        add controlo, 1
        jmp timer
        
        CheckSec:
            mov cl, timer1
            cmp cl, 0
            je MsecCheck
        
        SecCheck:
            mov bh, tempos
            cmp dh, bh
            jae gettimers
            add dh, 60
            jmp gettimers
            
        gettimers:
            sub dh, bh ; novo tempo - tempo inicial (s)
            mov ch, timer1                
            cmp dh, ch
            je CheckMsec
            jmp timer
        
        CheckMsec:
            
            mov ah, 02h
            mov dl, dh
            add dl, '0'
            int 21h
            
            add controlo2, 1
            mov cl, timer2
            cmp cl, 0
            ja MsecCheck
            jmp endf
            
            
        MsecCheck:
           
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
            cmp al, cl
            je endt
            jmp timer
            

endt:     

    mov ah, 02h
    mov dl, al
    add dl, '0'
    int 21h
    jmp endf
       
endf:    
    jmp timerinicio
    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

end start ; set entry point and stop the assembler.
