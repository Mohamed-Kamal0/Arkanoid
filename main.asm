.model small           ; Define the memory model
.stack 100h            ; Set the stack size

.data                  ; Section for initialized data
    msg db "Hello, World!", 0   ; Null-terminated string

.code                  ; Code section
main:                  
    ; Initialize the data segment
    mov ax, @data       ; Load address of the data segment
    mov ds, ax          ; Set DS register to data segment

    ; Display the message
    mov ah, 09h         ; DOS function 09h: Display string
    lea dx, msg         ; Load address of the message
    int 21h             ; Call DOS interrupt

    ; Exit the program
    mov ah, 4Ch         ; DOS function 4Ch: Terminate program
    int 21h             ; Call DOS interrupt

end main                ; End of the program
