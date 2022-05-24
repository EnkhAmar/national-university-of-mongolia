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

    ;;
    push ax
    push cx
    push dx  
      
    mov ah, 0
    mov cx, 0
    mov dx, 0 
    mov al, buffer[si]

    start1:
        aam
  
        mov bl, al 
        mov bh, ah 
            
        mov ax, 0
        mov al, bl 
    
        push ax 
        inc cx

        mov al, bh 
        mov ah, 0 
    
        cmp al, 0 
        jnz start1   
    start2: 

    pop dx
    add dx, 30h
    mov ah, 2
    int 21h
    loop start2
    
    pop dx
    pop cx
    pop ax  
    ;;
    mov dl, ' '
    mov ah, 2
    int 21h     
       
    inc si       
                
    loop loop1            


buffer DB 20,?, 20 dup(' ')
ret