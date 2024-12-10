.model small           ; Define the memory model
.stack 100h            ; Set the stack size
.data                         ; Section for initialized data
    ball_x          dw 10     ; X coordinate for the ball
    ball_y          dw 10     ; Y coordinate for the ball
    ball_collor     db 11     ; Color of the ball
    ball_side       dw 4      ; Side length of the ball(square)
    ball_dx         dw 3      ; direction of the ball in x
    ball_dy         dw 3      ; direction of the ball in y
    Start_Time      db 0      ; Variable to store the start time
    hours           db 0      ; Variable to store hours
    minutes         db 0      ; Variable to store minutes
    seconds         db 0      ; Variable to store seconds
    TenMilleseconds db 0      ; Variable to store milliseconds
    WindowWidth     dw 319    ; Width of the window
    WindowHeight    dw 199    ; Height of the window
.code                                            ; Section for code

GetTime proc far
                     push ax
                     push cx
                     push dx

                     mov  ah, 2ch                ; Function 2ch: Get Real-Time Clock Time
                     int  21h                    ; Call BIOS interrupt

    ; Store the time in the data segment variables
                     mov  hours, ch
                     mov  minutes, cl
                     mov  seconds, dh
                     mov  TenMilleseconds, dl
                     pop  dx
                     pop  cx
                     pop  ax
                     ret
GetTime endp

SetVideoMode proc far
                     push ax                     ; Save the AX register
                     mov  ah, 0                  ; Function 0: Set video mode
                     mov  al, 13h                ; Mode 13h: 320x200 256-color graphics mode
                     int  10h                    ; Call BIOS interrupt
                     pop  ax                     ; Restore the AX register
                     ret
SetVideoMode endp

DrawPixel proc far
                     push ax
                     push bx
                     push cx
                     push dx
                     push ds

                     mov  bh,0                   ; Page 0
                     mov  ah, 0Ch                ; Function 0Ch: Write pixel
                     int  10h                    ; Call BIOS interrupt
    
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

                     mov  bx, ball_side          ; Load side length
                     mov  cx, ball_x             ; Load X coordinate of the top-left corner
                     mov  dx, ball_y             ; Load Y coordinate of the top-left corner

    ; Draw the square
                     mov  si, 0                  ; Start from the first column
    DrawBallLoop:    
                     mov  di, 0                  ; Start from the first row
    DrawBallRow:     
                     mov  al, ball_collor        ; Color of the ball
    ; Calculate the pixel position

                     mov  cx, ball_x             ; X coordinate of the top-left corner
                     add  cx, si                 ; Add the column offset
                     mov  dx, ball_y             ; Load Y coordinate of the top-left corner
                     add  dx, di                 ; Add the row offset

                     call DrawPixel
    
                     inc  di                     ; Move to the next row
                     cmp  di, bx                 ; Check if all rows are drawn
                     jl   DrawBallRow

                     inc  si                     ; Move to the next column
                     cmp  si, bx                 ; Check if all columns are drawn
                     jl   DrawBallLoop

                     pop  ds
                     pop  dx
                     pop  cx
                     pop  bx
                     pop  ax
                     ret
DrawBall endp

EraseBall proc far
                     push ax
                     push bx
                     push cx
                     push dx
                     push ds

                     mov  bx, ball_side          ; Load side length
                     mov  cx, ball_x             ; Load X coordinate of the top-left corner
                     mov  dx, ball_y             ; Load Y coordinate of the top-left corner

    ; Draw the square
                     mov  si, 0                  ; Start from the first column
    EraseBallLoop:   
                     mov  di, 0                  ; Start from the first row
    EraseBallRow:    
                     mov  al, 00                 ; Color of the ball
    ; Calculate the pixel position

                     mov  cx, ball_x             ; X coordinate of the top-left corner
                     add  cx, si                 ; Add the column offset
                     mov  dx, ball_y             ; Load Y coordinate of the top-left corner
                     add  dx, di                 ; Add the row offset

                     call DrawPixel
    
                     inc  di                     ; Move to the next row
                     cmp  di, bx                 ; Check if all rows are drawn
                     jl   EraseBallRow

                     inc  si                     ; Move to the next column
                     cmp  si, bx                 ; Check if all columns are drawn
                     jl   EraseBallLoop

                     pop  ds
                     pop  dx
                     pop  cx
                     pop  bx
                     pop  ax
                     ret
EraseBall endp

MoveBall proc far
                     call EraseBall              ; Erase the ball at the current position
                     push ax                     ; Save the AX register
                     mov  ax, ball_x             ; Load the X coordinate of the ball
                     add  ax, ball_dx            ; Add the direction of the ball in X
                     mov  ball_x, ax             ; Store the new X coordinate of the ball
                     mov  ax, ball_y             ; Load the Y coordinate of the ball
                     add  ax, ball_dy            ; Add the direction of the ball in Y
                     mov  ball_y, ax             ; Store the new Y coordinate of the ball
    ; Check for collision with screen boundaries and reverse direction if needed
                     cmp  ball_x, 1              ;check if the ball is within the left boundary
                     jge  NoCollisionX           ; If the ball is within the left boundary, continue
                     neg  ball_dx                ; Reverse the direction of the ball
    NoCollisionX:                                ; Check if the ball is within the right boundary
                     mov  ax, WindowWidth        ; Load the width of the window
                     sub  ax, ball_side          ; Subtract the side length of the ball
                     cmp  ball_x, ax             ; Check if the ball is within the right boundary
                     jle  NoCollisionX2          ; If the ball is within the right boundary, continue
                     neg  ball_dx                ; Reverse the direction of the ball
    NoCollisionX2:                               ; Check if the ball is within the top boundary
                     cmp  ball_y, 1              ; Check if the ball is within the top boundary
                     jge  NoCollisionY           ; If the ball is within the top boundary, continue
                     neg  ball_dy                ; Reverse the direction of the ball
    NoCollisionY:    
                     mov  ax, WindowHeight       ; Load the height of the window
                     sub  ax, ball_side          ; Subtract the side length of the ball
                     cmp  ball_y, ax             ; Check if the ball is within the bottom boundary
                     jle  NoCollisionY2          ; If the ball is within the bottom boundary, continue
                     neg  ball_dy                ; Reverse the direction of the ball
    NoCollisionY2:                               ; Draw the ball at the new position

                     call DrawBall               ; Draw the ball
                     pop  ax                     ; Restore the AX register
                     ret
MoveBall endp

MakeBallIsMoving proc far
                     push ax                     ;   Save the AX register
                     
                     call MoveBall               ; Move the ball
                     call GetTime                ; Get the current time
                     mov  al, TenMilleseconds    ; Load the current time
    check_time:                                  ; Check if 1/100 of a second has passed
                     call GetTime                ; Get the current time
                     cmp  al, TenMilleseconds    ; Compare the start time with the current time
                     je   check_time             ; wait until 1/100 of a second has passed
                     call MakeBallIsMoving       ; Repeat the process
                     pop  ax
                     ret
MakeBallIsMoving endp

main proc far
                     mov  ax, @data
    ; Initialize the data segment
                     mov  ax, @data              ; Load address of the data segment
                     mov  ds, ax                 ; Set DS register to data segment
                     call SetVideoMode
                     call DrawBall
                     call MoveBall
                     call MakeBallIsMoving
    ; Exit the program
                     mov  ah, 4Ch                ; DOS function 4Ch: Terminate program
                     int  21h                    ; Call DOS interrupt
main endp
end main                ; End of the program
