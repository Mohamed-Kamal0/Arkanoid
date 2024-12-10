

.model small           ; Define the memory model
.stack 100h            ; Set the stack size
.data                    ; Section for initialized data
    ball_x           dw 20    ; X coordinate for the ball
    ball_y           dw 10    ; Y coordinate for the ball
    ball_collor db 11    ; Color of the ball
    ball_side        dw 5     ; Side length of the ball(square)
.code                                    ; Section for code
    ; Code section
SetVideoMode proc far
                 push ax                 ; Save the AX register
                 mov  ah, 0              ; Function 0: Set video mode
                 mov  al, 13h            ; Mode 13h: 320x200 256-color graphics mode
                 int  10h                ; Call BIOS interrupt
                 pop  ax                 ; Restore the AX register
                 ret
SetVideoMode endp
DrawPixel proc far
                 push ax
                 push bx
                 push cx
                 push dx
                 push ds

                 mov  bh,0               ; Page 0
                 mov  ah, 0Ch            ; Function 0Ch: Write pixel
                 int  10h                ; Call BIOS interrupt
    
                 pop  ds
                 pop  dx
                 pop  cx
                 pop  bx
                 pop  ax
                 ret
DrawPixel endp
DrawBall proc far
                 push ax
                 push bx
                 push cx
                 push dx
                 push ds

                 mov  bx, ball_side           ; Load side length
                 mov  cx, ball_x              ; Load X coordinate of the top-left corner
                 mov  dx, ball_y              ; Load Y coordinate of the top-left corner

    ; Draw the square
                 mov  si, 0              ; Start from the first column
    DrawBallLoop:
                 mov  di, 0              ; Start from the first row
    DrawBallRow: 
                 mov  al, ball_collor    ; Color of the ball
    ; Calculate the pixel position

                 mov  cx, ball_x              ; X coordinate of the top-left corner
                 add  cx, si             ; Add the column offset
                 mov  dx, ball_y              ; Load Y coordinate of the top-left corner
                 add  dx, di             ; Add the row offset

                 call DrawPixel
    
                 inc  di
                 cmp  di, bx
                 jl   DrawBallRow

                 inc  si
                 cmp  si, bx
                 jl   DrawBallLoop

                 pop  ds
                 pop  dx
                 pop  cx
                 pop  bx
                 pop  ax
                 ret
DrawBall endp
main proc far
                 mov  ax, @data
    ; Initialize the data segment
                 mov  ax, @data          ; Load address of the data segment
                 mov  ds, ax             ; Set DS register to data segment
                 call SetVideoMode
                 call DrawBall
    ; Exit the program
                 mov  ah, 4Ch            ; DOS function 4Ch: Terminate program
                 int  21h                ; Call DOS interrupt
main endp
end main                ; End of the program
