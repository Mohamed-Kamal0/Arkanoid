.model small
.stack 100h

.data
paddle db 50          ; starting position of the paddle
ballX db 40           ; starting X position of the ball
ballY db 30           ; starting Y position of the ball
directionX db 1       ; ball moving right (1) or left (-1)
directionY db 1       ; ball moving down (1) or up (-1)

.code
main:
    ; Set video mode 13h (320x200 256 colors)
    mov ax, 13h
    int 10h
    
    ; Initialize the game loop
    gameLoop:
        ; Clear screen (by filling with black color)
        call ClearScreen
        
        ; Draw paddle
        call DrawPaddle
        
        ; Draw ball
        call DrawBall
        
        ; Move the ball
        call MoveBall
        
        ; Check for paddle-ball collision
        call CheckCollision
        
        ; Wait for a small delay (simulate game speed)
        call Delay
        
        ; Check for key press (left or right arrow)
        call CheckInput
        
        ; Repeat the loop
        jmp gameLoop
        
; Subroutine to clear screen
ClearScreen:
    mov ax, 0A000h     ; Segment for video memory
    mov es, ax
    xor di, di
    mov cx, 320*200    ; Number of pixels
    xor ax, ax         ; Fill with black color
    rep stosb
    ret

; Subroutine to draw the paddle
DrawPaddle:
    mov ax, 0A000h     ; Segment for video memory
    mov es, ax
    mov di, 200*160    ; Calculate paddle position (near bottom)
    mov cx, 40         ; Paddle width (in pixels)
    mov al, 15         ; White color
    rep stosb
    ret

; Subroutine to draw the ball
DrawBall:
    mov ax, 0A000h     ; Segment for video memory
    mov es, ax
    mov di, ballX
    add di, ballY*320
    mov al, 4          ; Red color
    mov [es:di], al    ; Draw the ball
    ret

; Subroutine to move the ball
MoveBall:
    ; Move ball horizontally
    mov al, [ballX]
    add al, [directionX]
    mov [ballX], al
    
    ; Move ball vertically
    mov al, [ballY]
    add al, [directionY]
    mov [ballY], al
    ret

; Subroutine to check for collisions with the paddle
CheckCollision:
    ; If the ball hits the paddle area, reverse direction
    mov al, [ballY]
    cmp al, 160        ; Paddle Y position
    jne NoCollision
    mov al, [ballX]
    cmp al, 50         ; Paddle X position (assuming 40 pixels width)
    jl NoCollision
    cmp al, 90
    jg NoCollision
    ; Ball hits paddle, reverse Y direction
    mov byte ptr [directionY], -1
NoCollision:
    ret

; Subroutine to check key press for moving the paddle
CheckInput:
    mov ah, 01h        ; Check if a key is pressed
    int 16h
    jz NoKeyPress
    mov ah, 00h
    int 16h            ; Get key pressed
    cmp al, 4Ch        ; Left arrow key
    je MoveLeft
    cmp al, 52h        ; Right arrow key
    je MoveRight
NoKeyPress:
    ret
    
MoveLeft:
    dec byte ptr [paddle]
    ret

MoveRight:
    inc byte ptr [paddle]
    ret

; Simple delay
Delay:
    mov cx, 0FFFFh
DelayLoop:
    loop DelayLoop
    ret

end main
