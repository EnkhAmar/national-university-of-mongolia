ORG 100h

mov ah, 1
int 21h

mov bl, al

mov ah, 0
mov cx, 0

mov dl, ' '
mov ah, 2
int 21h

cmp bl, 30h    ; 0
jl LESS        ; BL < BH

cmp bl, 39h    ; 9
jg GREATER     ; BL > BH

sub bl, 30h
mov dx, 0

LOOP1:
cmp bx, si
jl PRINT_RESULT
add dl, array[si]
inc si
loop LOOP1

jmp EXIT

LESS:
GREATER:

mov dx, offset msg
mov ah, 9
int 21h

jmp EXIT

PRINT_RESULT:
mov ax, dx
aam
add dl, 30h
mov ah, 2
int 21h

EXIT:

RET

msg db "Please enter number$"
array db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9