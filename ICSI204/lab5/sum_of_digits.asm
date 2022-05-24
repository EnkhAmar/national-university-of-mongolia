ORG 100h

mov ah, 1
int 21h
mov ah, 0

cmp ah, 30     ; 0
jmp LESS       ; BL < BH

cmp ah, 39     ; 9
jg GREATER     ; BL > BH



LESS:
GREATER:
mov dx, offset msg
mov ah, 9
int 21h

msg db "Please enter number"

RET