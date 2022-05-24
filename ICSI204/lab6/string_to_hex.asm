ORG 100h   
mov cx, 0 
mov dx, OFFSET buffer 
mov ah, 0Ah 
int 21h
mov cl,buffer[1]  
mov si, 2
loop1:
    push ax
    push dx
    
    
    
    mov ah, 2 
    mov dx, 10
    int 21h 
    mov dl, 13
    int 21h
    mov dl, buffer[si]
    int 21h
    mov dl, ' '
    int 21h 
  
    pop dx
    pop dx    

    ;;;
    push ax
    push cx
    push dx  
      
    mov ah, 0
    mov cx, 0
    mov dx, 0
    
     
    mov al, buffer[si] 
    mov cl, 9h 
    mov bl, al
    
    shr al, 4 
    cmp al, cl 
    jg jmp1
        add al, 30h
    jmp exit 
    jmp1: 
        add al, 37h
    exit:
    
    mov ah, 2 
    mov dl, al
    int 21h
    
    mov al, bl 
    shl al, 4
    shr al, 4 
    
    cmp al, cl 
    jg jmp2 
        add al, 30h 
    jmp exit1
    jmp2:
        add al, 37h 
    exit1:  
    
    mov ah, 2 
    mov dl, al
    int 21h 
    
    pop dx
    pop cx
    pop ax
    ;;;
    
    mov dl, ' '
    mov ah, 2
    int 21h       
       
    inc si       
                
    loop loop1            


buffer DB 20,5 dup('?')
ret