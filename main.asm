
movcursor macro x,y
push ax
push bx
push cx
push dx
mov ah,2
mov dl,x
mov dh,y
int 10h
pop dx
pop cx
pop bx
pop ax
endm
DisplayString MACRO str
    lea dx, str
    mov ah, 9
    int 21h
ENDM
.model small           ; Define the memory model
.stack 100h            ; Set the stack size
.data                  ; Section for initialized data
    msg db "Hello, World!", '$'   ; Null-terminated string
    newline db 0Dh, 0Ah, '$'       ; Newline character
.code                  ; Code section
clearscreen proc  
push ax
push bx
push cx
push dx
mov ax,0600h
mov bh,07h
mov cx,0
mov dx,184fh
int 10h
pop dx
pop cx
pop bx
pop ax
ret
clearscreen endp

main:                  
    ; Initialize the data segment
    mov ax, @data       ; Load address of the data segment
    mov ds, ax          ; Set DS register to data segment
    call clearscreen
    movcursor 0,0
    DisplayString msg
    DisplayString newline
    ; Exit the program
    mov ah, 4Ch         ; DOS function 4Ch: Terminate program
    int 21h             ; Call DOS interrupt

end main                ; End of the program
