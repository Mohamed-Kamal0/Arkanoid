.MODEL SMALL
.stack 64

.DATA

; Paddle dimensions
paddle_width db 40        ; Width of the rectangle
paddle_height db 5        ; Height of the rectangle

; Paddle 1 coordinates
p1_x1 dw 145              ; X-coordinate of the bottom-left corner
p1_y1 dw 197              ; Y-coordinate of the bottom-left corner

; Paddle 2 coordinates
p2_x1 dw 100              ; X-coordinate of the bottom-left corner (player 2)
p2_y1 dw 197              ; Y-coordinate of the bottom-left corner (player 2)

; Paddle colors
paddle_p1_color db 10     ; Color for player 1 paddle
paddle_p2_color db 11     ; Color for player 2 paddle

; Arrow key ASCII values for movement
left_arrow_ascii db 37    ; ASCII for left arrow (not used directly)
right_arrow_ascii db 39   ; ASCII for right arrow (not used directly)

; To store key inputs for players
input_p1_key db ?         ; Key input for player 1
input_p2_key db ?         ; Key input for player 2

; Screen dimensions
WindowWidth dw 319        ; Screen width
WindowHeight dw 199       ; Screen height

.CODE

; Draw player 1 paddle
draw_p1_paddle proc far
    push ax
    push bx
    push cx
    push dx

    ; Initialize X and Y coordinates
    mov CX, p1_x1         
    mov DX, p1_y1         
    mov bl, 0h            ; Column counter
    mov bh, 0h            ; Row counter

draw_p1_loop:
    ; Draw a pixel for the paddle
    mov al, paddle_p1_color ; Set paddle color
    mov ah, 0ch             ; Function to draw a pixel
    int 10h                 ; Call interrupt to draw

    ; Move to the next pixel in the row
    inc CX                  ; Increment X-coordinate
    inc bl                  ; Increment column counter
    cmp bl, paddle_width    ; Check if the row is complete
    jbe draw_p1_loop        ; Continue drawing row if not finished

    ; Move to the next row
    mov bl, 0h              ; Reset column counter
    mov CX, p1_x1           ; Reset X-coordinate
    dec DX                  ; Move up to the next row
    inc bh                  ; Increment row counter
    cmp bh, paddle_height   ; Check if all rows are drawn
    jbe draw_p1_loop        ; Continue if more rows need drawing

    ; Restore registers and return
    pop dx
    pop cx
    pop bx
    pop ax
    ret
draw_p1_paddle endp

; Similar function for player 2 paddle
draw_p2_paddle proc far
    push ax
    push bx
    push cx
    push dx

    ; Initialize X and Y coordinates
    mov CX, p2_x1
    mov DX, p2_y1
    mov bl, 0h
    mov bh, 0h

draw_p2_loop:
    ; Draw a pixel for the paddle
    mov al, paddle_p2_color
    mov ah, 0ch
    int 10h

    ; Move to the next pixel in the row
    inc CX
    inc bl
    cmp bl, paddle_width
    jbe draw_p2_loop

    ; Move to the next row
    mov bl, 0h
    mov CX, p2_x1
    dec DX
    inc bh
    cmp bh, paddle_height
    jbe draw_p2_loop

    ; Restore registers and return
    pop dx
    pop cx
    pop bx
    pop ax
    ret
draw_p2_paddle endp

; Erase player 1 paddle by drawing black pixels
erase_p1_paddle proc far
    push ax
    push bx
    push cx
    push dx

    ; Initialize X and Y coordinates
    mov CX, p1_x1
    mov DX, p1_y1
    mov bl, 0h
    mov bh, 0h

erase_p1_loop:
    ; Draw black pixel to erase
    mov al, 0          ; Black color
    mov ah, 0ch        ; Function to draw pixel
    int 10h

    ; Move to the next pixel in the row
    inc CX
    inc bl
    cmp bl, paddle_width
    jbe erase_p1_loop

    ; Move to the next row
    mov bl, 0h
    mov CX, p1_x1
    dec DX
    inc bh
    cmp bh, paddle_height
    jbe erase_p1_loop

    ; Restore registers and return
    pop dx
    pop cx
    pop bx
    pop ax
    ret
erase_p1_paddle endp

; Similar function for erasing player 2 paddle
erase_p2_paddle proc far
    push ax
    push bx
    push cx
    push dx

    mov CX, p2_x1
    mov DX, p2_y1
    mov bl, 0h
    mov bh, 0h

erase_p2_loop:
    mov al, 0
    mov ah, 0ch
    int 10h

    inc CX
    inc bl
    cmp bl, paddle_width
    jbe erase_p2_loop

    mov bl, 0h
    mov CX, p2_x1
    dec DX
    inc bh
    cmp bh, paddle_height
    jbe erase_p2_loop

    pop dx
    pop cx
    pop bx
    pop ax
    ret
erase_p2_paddle endp

; Move player 1 paddle based on keyboard input
move_p1_paddle proc far
    push ax
    push bx
    push cx
    push dx

    ; Check if a key is pressed
    mov ah, 1
    int 16h
    jz endp_procedure      ; No key pressed, exit

    ; Read key input
    mov ah, 0
    int 16h
    mov input_p1_key, al   ; Store key input

    ; Check for 'd' key to move right
    cmp al, 100
    jz go_right

    ; Check for 'a' key to move left
    cmp al, 97
    jz go_left

    jmp endp_procedure     ; If no relevant key, exit

go_right:
    cmp p1_x1, 275         ; Prevent moving past screen edge
    jae endp_procedure
    call erase_p1_paddle   ; Erase current paddle
    add p1_x1, 5           ; Move paddle to the right
    jmp draw_paddles

go_left:
    cmp p1_x1, 1           ; Prevent moving past screen edge
    jbe endp_procedure
    call erase_p1_paddle   ; Erase current paddle
    sub p1_x1, 5           ; Move paddle to the left

draw_paddles:
    call draw_p2_paddle    ; Redraw both paddles
    call draw_p1_paddle

endp_procedure:
    pop dx
    pop cx
    pop bx
    pop ax
    ret
move_p1_paddle endp

; Similar function for moving player 2 paddle
move_p2_paddle proc far
    push ax
    push bx
    push cx
    push dx

    ; Check if a key is pressed
    mov ah, 1
    int 16h
    jz endp_procedure2     ; No key pressed, exit

    ; Read key input
    mov ah, 0
    int 16h
    mov input_p2_key, al   ; Store key input

    ; Check for 'l' key to move right
    cmp al, 108
    jz go_right2

    ; Check for 'j' key to move left
    cmp al, 106
    jz go_left2

    jmp endp_procedure2    ; If no relevant key, exit

go_right2:
    cmp p2_x1, 275         ; Prevent moving past screen edge
    jae endp_procedure2
    call erase_p2_paddle   ; Erase current paddle
    add p2_x1, 5           ; Move paddle to the right
    jmp draw_paddles2

go_left2:
    cmp p2_x1, 1           ; Prevent moving past screen edge
    jbe endp_procedure2
    call erase_p2_paddle   ; Erase current paddle
    sub p2_x1, 5           ; Move paddle to the left

draw_paddles2:
    call draw_p1_paddle    ; Redraw both paddles
    call draw_p2_paddle

endp_procedure2:
    pop dx
    pop cx
    pop bx
    pop ax
    ret
move_p2_paddle endp

; Main program entry point
main PROC far
    ; Initialize data segment
    mov ax, @data
    mov ds, ax

    ; Set graphics mode to 13h (320x200, 256 colors)
    mov ah, 0
    mov al, 13h
    int 10h

    ; Draw both paddles initially
    call draw_p2_paddle
    call draw_p1_paddle

infinite_loop:
    ; Continuously check and move paddles
    call move_p1_paddle
    call move_p2_paddle
    jmp infinite_loop

endProg:
    ; Exit program
    mov ah, 4Ch
    int 21h

main ENDP
end main
