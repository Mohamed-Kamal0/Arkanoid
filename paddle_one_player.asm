.MODEL SMALL
.stack 64

.DATA

paddle_width db 40        ; Width of the paddle rectangle
paddle_height db 5        ; Height of the paddle rectangle
p1_x1 dw 139              ; X-coordinate of the bottom-left corner of paddle 1
p1_y1 dw 197              ; Y-coordinate of the bottom-left corner of paddle 1


input_p1_key db ?         ; Variable to store player 1 key input

paddle_p1_color db 10     ; Color value for player 1's paddle

WindowWidth dw 319        ; Screen width in pixels
WindowHeight dw 199       ; Screen height in pixels

.CODE

; Procedure to draw the paddle for player 1
draw_paddle proc far
    push ax
    push bx
    push cx
    push dx

    ; Initialize coordinates and counters
    mov CX, p1_x1         ; Set the initial X-coordinate
    mov DX, p1_y1         ; Set the initial Y-coordinate (bottom)
    mov bl, 0h            ; Initialize column counter
    mov bh, 0h            ; Initialize row counter

draw_loop:
    ; Draw a single pixel
    mov al, paddle_p1_color ; Set the color for the pixel
    mov ah, 0ch             ; Function to draw a pixel
    int 10h                 ; Call BIOS interrupt to draw

    ; Move to the next pixel in the row
    inc CX                  ; Increment X-coordinate
    inc bl                  ; Increment column counter
    cmp bl, paddle_width    ; Check if the current row is complete
    jbe draw_loop           ; Continue drawing the row if not finished

    ; Move to the next row
    mov bl, 0h              ; Reset column counter
    mov CX, p1_x1           ; Reset X-coordinate to the start of the row
    dec DX                  ; Move up (decrease Y-coordinate)
    inc bh                  ; Increment row counter
    cmp bh, paddle_height   ; Check if all rows are drawn
    jbe draw_loop           ; Continue drawing rows if not finished

    ; Restore registers and return
    pop dx
    pop cx
    pop bx
    pop ax
    ret
draw_paddle endp

; Procedure to erase the paddle for player 1 (draws black pixels over the paddle)
erase_paddle proc far
    push ax
    push bx
    push cx
    push dx

    ; Initialize coordinates and counters
    mov CX, p1_x1         ; Set the initial X-coordinate
    mov DX, p1_y1         ; Set the initial Y-coordinate (bottom)
    mov bl, 0h            ; Initialize column counter
    mov bh, 0h            ; Initialize row counter

erase_loop:
    ; Draw a black pixel to erase
    mov al, 0              ; Black color
    mov ah, 0ch            ; Function to draw a pixel
    int 10h                ; Call BIOS interrupt to draw

    ; Move to the next pixel in the row
    inc CX                 ; Increment X-coordinate
    inc bl                 ; Increment column counter
    cmp bl, paddle_width   ; Check if the current row is complete
    jbe erase_loop         ; Continue erasing the row if not finished

    ; Move to the next row
    mov bl, 0h             ; Reset column counter
    mov CX, p1_x1          ; Reset X-coordinate to the start of the row
    dec DX                 ; Move up (decrease Y-coordinate)
    inc bh                 ; Increment row counter
    cmp bh, paddle_height  ; Check if all rows are erased
    jbe erase_loop         ; Continue erasing rows if not finished

    ; Restore registers and return
    pop dx
    pop cx
    pop bx
    pop ax
    ret
erase_paddle endp

; Procedure to move player 1's paddle based on keyboard input
move_p1_paddle proc far
    push ax
    push bx
    push cx
    push dx

    ; Check if a key is pressed
    mov ah, 1              ; BIOS function to check keyboard input
    int 16h                ; Call BIOS interrupt
    jz end_procedure       ; If no key is pressed, exit

    ; Read the key input
    mov ah, 0              ; BIOS function to get key input
    int 16h                ; Call BIOS interrupt
    mov input_p1_key, al   ; Store the key in the input_p1_key variable

    ; Check if the 'd' key is pressed to move right
    cmp al, 100            ; ASCII value for 'd'
    jz go_right

    ; Check if the 'a' key is pressed to move left
    cmp al, 97             ; ASCII value for 'a'
    jz go_left

    jmp end_procedure      ; Exit if no relevant key is pressed

go_right:
    cmp p1_x1, 277         ; Check if paddle is near the right screen edge
    jae end_procedure      ; Prevent moving beyond the screen
    call erase_paddle      ; Erase current paddle position
    add p1_x1, 3           ; Move paddle to the right
    jmp draw_paddle_new_position


go_left:
    cmp p1_x1, 1           ; Check if paddle is near the left screen edge
    jbe end_procedure      ; Prevent moving beyond the screen
    call erase_paddle      ; Erase current paddle position
    sub p1_x1, 3           ; Move paddle to the left

draw_paddle_new_position:
    call draw_paddle        ; Redraw the paddle at the new position

end_procedure:
    ; Restore registers and return
    pop dx
    pop cx
    pop bx
    pop ax
    ret
move_p1_paddle endp

; Main program entry point
main PROC far
    ; Initialize data segment
    mov ax, @data
    mov ds, ax

    ; Set graphics mode to 13h (320x200, 256 colors)
    mov ah, 0
    mov al, 13h
    int 10h

    ; Draw the initial paddle for player 1
    call draw_paddle

infinite_loop:
    ; Continuously check for and handle paddle movement
    call move_p1_paddle
    jmp infinite_loop

endProg:
    ; Exit program
    mov ah, 4Ch
    int 21h

main ENDP
end main
