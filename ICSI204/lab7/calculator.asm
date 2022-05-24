putc macro char
    push ax
    mov al, char
    mov ah, 0Eh
    int 10h     
    pop AX
endm

org 100h

    jmp start

    msg1 db "enter first number: $"
    msg2 db "enter the operator:(+,-,*,/): $"
    msg3 db "enter second number: $"
    msg4 db  0dh,0ah, 'the result of my calculations is : $' 
    err1 db  "Unknown operator!", 0Dh,0Ah , '$'
    smth db  " and something.... $"

    opr db '?'

    num1 dw ?
    num2 dw ?


start:


lea dx, msg1
mov ah, 09h  
int 21h  
                          
call scan_num
mov num1, cx 

putc 0Dh
putc 0Ah

lea dx, msg2
mov ah, 09h    
int 21h  

mov ah, 1   
int 21h
mov opr, al


putc 0Dh
putc 0Ah


cmp opr, 'q'
je exit

cmp opr, '*'
jb wrong_opr
cmp opr, '/'
ja wrong_opr


lea dx, msg3
mov ah, 09h
int 21h  



call scan_num

mov num2, cx 




lea dx, msg4
mov ah, 09h     
int 21h  



cmp opr, '+'
je do_plus

cmp opr, '-'
je do_minus

cmp opr, '*'
je do_mult

cmp opr, '/'
je do_div


wrong_opr:
    lea dx, err1
    mov ah, 09h     
    int 21h  


exit: 


mov ah, 0
int 16h


ret  

do_plus:
    mov ax, num1
    add ax, num2
    call print_num   
jmp exit



do_minus:
    mov ax, num1
    sub ax, num2
    call print_num    
jmp exit


do_mult:
    mov ax, num1
    imul num2 
    call print_num    
jmp exit




do_div:

    mov dx, 0
    mov ax, num1
    idiv num2  2.
    cmp dx, 0
    jnz approx
        call print_num    
        jmp exit
    approx:
        call print_num   
        lea dx, smth
        mov ah, 09h   
        int 21h  
jmp exit











SCAN_NUM        PROC    NEAR
        PUSH    DX
        PUSH    AX
        PUSH    SI
        
        MOV     CX, 0

     
        MOV     CS:make_minus, 0

next_digit:


        MOV     AH, 00h
        INT     16h

        MOV     AH, 0Eh
        INT     10h

        CMP     AL, '-'
        JE      set_minus

        CMP     AL, 0Dh  
        JNE     not_cr
        JMP     stop_input
not_cr:


        CMP     AL, 8                  
        JNE     backspace_checked
        MOV     DX, 0                   
        MOV     AX, CX                  
        DIV     CS:ten                  
        MOV     CX, AX
        PUTC    ' '                   
        PUTC    8                       
        JMP     next_digit
backspace_checked:


        
        CMP     AL, '0'
        JAE     ok_AE_0
        JMP     remove_not_digit
ok_AE_0:        
        CMP     AL, '9'
        JBE     ok_digit
remove_not_digit:       
        PUTC    8     
        PUTC    ' '   
        PUTC    8             
        JMP     next_digit       
ok_digit:


        PUSH    AX
        MOV     AX, CX
        MUL     CS:ten               
        MOV     CX, AX
        POP     AX


        CMP     DX, 0
        JNE     too_big

 
        SUB     AL, 30h

        MOV     AH, 0
        MOV     DX, CX      
        ADD     CX, AX
        JC      too_big2    

        JMP     next_digit

set_minus:
        MOV     CS:make_minus, 1
        JMP     next_digit

too_big2:
        MOV     CX, DX      
        MOV     DX, 0       
too_big:
        MOV     AX, CX
        DIV     CS:ten  
        MOV     CX, AX
        PUTC    8       
        PUTC    ' '     
        PUTC    8               
        JMP     next_digit 
        
        
stop_input:

        CMP     CS:make_minus, 0
        JE      not_minus
        NEG     CX
not_minus:

        POP     SI
        POP     AX
        POP     DX
        RET
make_minus      DB      ?       
SCAN_NUM        ENDP






PRINT_NUM       PROC    NEAR
        PUSH    DX
        PUSH    AX

        CMP     AX, 0
        JNZ     not_zero

        PUTC    '0'
        JMP     printed

not_zero:

        CMP     AX, 0
        JNS     positive
        NEG     AX

        PUTC    '-'

positive:
        CALL    PRINT_NUM_UNS
printed:
        POP     AX
        POP     DX
        RET
PRINT_NUM       ENDP



PRINT_NUM_UNS   PROC    NEAR
        PUSH    AX
        PUSH    BX
        PUSH    CX
        PUSH    DX

        
        MOV     CX, 1

     
        MOV     BX, 10000 

        CMP     AX, 0
        JZ      print_zero

begin_print:

        CMP     BX,0
        JZ      end_print

        
        CMP     CX, 0
        JE      calc
       
        CMP     AX, BX
        JB      skip
calc:
        MOV     CX, 0   

        MOV     DX, 0
        DIV     BX      

      
        ADD     AL, 30h   
        PUTC    AL


        MOV     AX, DX  

skip:

        PUSH    AX
        MOV     DX, 0
        MOV     AX, BX
        DIV     CS:ten 
        MOV     BX, AX
        POP     AX

        JMP     begin_print
        
print_zero:
        PUTC    '0'
        
end_print:

        POP     DX
        POP     CX
        POP     BX
        POP     AX
        RET
PRINT_NUM_UNS   ENDP



ten             DW      10      







GET_STRING PROC NEAR
PUSH    AX
PUSH    CX
PUSH    DI
PUSH    DX

MOV     CX, 0                  

CMP     DX, 1                   
JBE     empty_buffer            
DEC     DX                     


wait_for_key:

MOV     AH, 0                   
INT     16h

CMP     AL, 0Dh                  
JZ      exit_GET_STRING


CMP     AL, 8                  
JNE     add_to_buffer
JCXZ    wait_for_key            
DEC     CX
DEC     DI
PUTC    8                       
PUTC    ' '                     
PUTC    8                       
JMP     wait_for_key

add_to_buffer:

        CMP     CX, DX         
        JAE     wait_for_key    

        MOV     [DI], AL
        INC     DI
        INC     CX

        MOV     AH, 0Eh
        INT     10h

JMP     wait_for_key


exit_GET_STRING:


MOV     [DI], 0

empty_buffer:

POP     DX
POP     DI
POP     CX
POP     AX
RET
GET_STRING      ENDP