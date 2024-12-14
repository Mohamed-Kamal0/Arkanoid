.model small           ; Define the memory model
.stack 100h            ; Set the stack size
.data                                           ; Section for initialized data
    ; Black:            0
    ; Blue:             1
    ; Green:            2
    ; Cyan:             3
    ; Red:              4
    ; Magenta:          5
    ; Brown:            6
    ; Light Gray:       7
    ; Dark Gray:        8
    ; Light Blue:       9
    ; Light Green:      10
    ; Light Cyan:       11
    ; Light Red:        12
    ; Light Magenta:    13
    ; Yellow:           14
    ; White:            15
    ball_x            dw 10                     ; X coordinate for the ball
    ball_y            dw 10                     ; Y coordinate for the ball
    ball_collor       db 10                     ; Color of the ball
    ball_side         dw 4                      ; Side length of the ball(square)
    ball_vx           dw 3                      ; direction of the ball in x
    ball_vy           dw 3                      ; direction of the ball in y
    Start_Time        db 0                      ; Variable to store the start time
    hours             db 0                      ; Variable to store hours
    minutes           db 0                      ; Variable to store minutes
    seconds           db 0                      ; Variable to store seconds
    TenMilleseconds   db 0                      ; Variable to store milliseconds
    WindowWidth       dw 319                    ; Width of the window
    WindowHeight      dw 197                    ; Height of the window
    column            dw 2 dup(?)
    row               dw 2 dup(?)
    color             db ?
    height            db ?
    colorsR1          db 7, 2, 3, 4, 1, 6, 5
    colorsR2          db 5, 1, 4, 2, 6, 7, 3
    colorsR3          db 2, 4, 6, 1, 3, 5, 7
    colorsR4          db 1, 3, 5, 7, 2, 4, 6
    ;colors of each row
    ;arrays of start and end of each blocks number equal number of rows
    E                 dw 2 dup(?)               ; E is the end of the row
    ; Paddle dimensions
    paddle_width      db 40                     ; Width of the rectangle
    paddle_height     db 5                      ; Height of the rectangle

    ; Paddle 1 coordinates
    p1_x1             dw 145                    ; X-coordinate of the bottom-left corner
    p1_y1             dw 197                    ; Y-coordinate of the bottom-left corner

    ; Paddle 2 coordinates
    p2_x1             dw 100                    ; X-coordinate of the bottom-left corner (player 2)
    p2_y1             dw 197                    ; Y-coordinate of the bottom-left corner (player 2)

    ; Paddle colors
    paddle_p1_color   db 10                     ; Color for player 1 paddle
    paddle_p2_color   db 11                     ; Color for player 2 paddle

    ; Arrow key ASCII values for movement
    left_arrow_ascii  db 37                     ; ASCII for left arrow (not used directly)
    right_arrow_ascii db 39                     ; ASCII for right arrow (not used directly)

    ; To store key inputs for players
    input_p1_key      db ?                      ; Key input for player 1
    input_p2_key      db ?                      ; Key input for player 2

    ; Screen dimensions

.code                                                  ; Section for code

    ; Draw player 1 paddle
draw_p1_paddle proc far
                         push  ax
                         push  bx
                         push  cx
                         push  dx

    ; Initialize X and Y coordinates
                         mov   CX, p1_x1
                         mov   DX, p1_y1
                         mov   bl, 0h                  ; Column counter
                         mov   bh, 0h                  ; Row counter

    draw_p1_loop:        
    ; Draw a pixel for the paddle
                         mov   al, paddle_p1_color     ; Set paddle color
                         mov   ah, 0ch                 ; Function to draw a pixel
                         int   10h                     ; Call interrupt to draw

    ; Move to the next pixel in the row
                         inc   CX                      ; Increment X-coordinate
                         inc   bl                      ; Increment column counter
                         cmp   bl, paddle_width        ; Check if the row is complete
                         jbe   draw_p1_loop            ; Continue drawing row if not finished

    ; Move to the next row
                         mov   bl, 0h                  ; Reset column counter
                         mov   CX, p1_x1               ; Reset X-coordinate
                         dec   DX                      ; Move up to the next row
                         inc   bh                      ; Increment row counter
                         cmp   bh, paddle_height       ; Check if all rows are drawn
                         jbe   draw_p1_loop            ; Continue if more rows need drawing

    ; Restore registers and return
                         pop   dx
                         pop   cx
                         pop   bx
                         pop   ax
                         ret
draw_p1_paddle endp

    ; Similar function for player 2 paddle
draw_p2_paddle proc far
                         push  ax
                         push  bx
                         push  cx
                         push  dx

    ; Initialize X and Y coordinates
                         mov   CX, p2_x1
                         mov   DX, p2_y1
                         mov   bl, 0h
                         mov   bh, 0h

    draw_p2_loop:        
    ; Draw a pixel for the paddle
                         mov   al, paddle_p2_color
                         mov   ah, 0ch
                         int   10h

    ; Move to the next pixel in the row
                         inc   CX
                         inc   bl
                         cmp   bl, paddle_width
                         jbe   draw_p2_loop

    ; Move to the next row
                         mov   bl, 0h
                         mov   CX, p2_x1
                         dec   DX
                         inc   bh
                         cmp   bh, paddle_height
                         jbe   draw_p2_loop

    ; Restore registers and return
                         pop   dx
                         pop   cx
                         pop   bx
                         pop   ax
                         ret
draw_p2_paddle endp

    ; Erase player 1 paddle by drawing black pixels
erase_p1_paddle proc far
                         push  ax
                         push  bx
                         push  cx
                         push  dx

    ; Initialize X and Y coordinates
                         mov   CX, p1_x1
                         mov   DX, p1_y1
                         mov   bl, 0h
                         mov   bh, 0h

    erase_p1_loop:       
    ; Draw black pixel to erase
                         mov   al, 0                   ; Black color
                         mov   ah, 0ch                 ; Function to draw pixel
                         int   10h

    ; Move to the next pixel in the row
                         inc   CX
                         inc   bl
                         cmp   bl, paddle_width
                         jbe   erase_p1_loop

    ; Move to the next row
                         mov   bl, 0h
                         mov   CX, p1_x1
                         dec   DX
                         inc   bh
                         cmp   bh, paddle_height
                         jbe   erase_p1_loop

    ; Restore registers and return
                         pop   dx
                         pop   cx
                         pop   bx
                         pop   ax
                         ret
erase_p1_paddle endp

    ; Similar function for erasing player 2 paddle
erase_p2_paddle proc far
                         push  ax
                         push  bx
                         push  cx
                         push  dx

                         mov   CX, p2_x1
                         mov   DX, p2_y1
                         mov   bl, 0h
                         mov   bh, 0h

    erase_p2_loop:       
                         mov   al, 0
                         mov   ah, 0ch
                         int   10h

                         inc   CX
                         inc   bl
                         cmp   bl, paddle_width
                         jbe   erase_p2_loop

                         mov   bl, 0h
                         mov   CX, p2_x1
                         dec   DX
                         inc   bh
                         cmp   bh, paddle_height
                         jbe   erase_p2_loop

                         pop   dx
                         pop   cx
                         pop   bx
                         pop   ax
                         ret
erase_p2_paddle endp

    ; Move player 1 paddle based on keyboard input
move_p1_paddle proc far
                         push  ax
                         push  bx
                         push  cx
                         push  dx

    ; Check if a key is pressed
                         mov   ah, 1
                         int   16h
                         jz    endp_procedure          ; No key pressed, exit

    ; Read key input
                         mov   ah, 0
                         int   16h
                         mov   input_p1_key, al        ; Store key input

    ; Check for 'd' key to move right
                         cmp   al, 100
                         jz    go_right

    ; Check for 'a' key to move left
                         cmp   al, 97
                         jz    go_left

                         jmp   endp_procedure          ; If no relevant key, exit

    go_right:            
                         cmp   p1_x1, 275              ; Prevent moving past screen edge
                         jae   endp_procedure
                         call  erase_p1_paddle         ; Erase current paddle
                         add   p1_x1, 5                ; Move paddle to the right
                         jmp   draw_paddles

    go_left:             
                         cmp   p1_x1, 1                ; Prevent moving past screen edge
                         jbe   endp_procedure
                         call  erase_p1_paddle         ; Erase current paddle
                         sub   p1_x1, 5                ; Move paddle to the left

    draw_paddles:        
                         call  draw_p2_paddle          ; Redraw both paddles
                         call  draw_p1_paddle

    endp_procedure:      
                         pop   dx
                         pop   cx
                         pop   bx
                         pop   ax
                         ret
move_p1_paddle endp

    ; Similar function for moving player 2 paddle
move_p2_paddle proc far
                         push  ax
                         push  bx
                         push  cx
                         push  dx

    ; Check if a key is pressed
                         mov   ah, 1
                         int   16h
                         jz    endp_procedure2         ; No key pressed, exit

    ; Read key input
                         mov   ah, 0
                         int   16h
                         mov   input_p2_key, al        ; Store key input

    ; Check for 'l' key to move right
                         cmp   al, 108
                         jz    go_right2

    ; Check for 'j' key to move left
                         cmp   al, 106
                         jz    go_left2

                         jmp   endp_procedure2         ; If no relevant key, exit

    go_right2:           
                         cmp   p2_x1, 275              ; Prevent moving past screen edge
                         jae   endp_procedure2
                         call  erase_p2_paddle         ; Erase current paddle
                         add   p2_x1, 5                ; Move paddle to the right
                         jmp   draw_paddles2

    go_left2:            
                         cmp   p2_x1, 1                ; Prevent moving past screen edge
                         jbe   endp_procedure2
                         call  erase_p2_paddle         ; Erase current paddle
                         sub   p2_x1, 5                ; Move paddle to the left

    draw_paddles2:       
                         call  draw_p1_paddle          ; Redraw both paddles
                         call  draw_p2_paddle

    endp_procedure2:     
                         pop   dx
                         pop   cx
                         pop   bx
                         pop   ax
                         ret
move_p2_paddle endp

drawall proc far
                         push  ax
                         push  bx
                         push  cx
                         push  dx
                         pushf
                         mov   column,0
                         mov   row ,2
                         mov   color,0
                         mov   height,10
                         mov   cx,0
                         mov   ax,1



                         lea   SI, colorsR1
                         call  drawrow
                         mov   column,0
                         mov   row ,14
                         mov   cx,0
                         mov   ax,1
                         lea   SI, colorsR2
                         call  drawrow
                         mov   column ,0
                         mov   row ,26
                         mov   cx,0
                         mov   ax,1
                         lea   SI, colorsR3
                         call  drawrow

                         mov   column ,0
                         mov   row ,38
                         mov   cx,0
                         mov   ax,1
                         lea   SI, colorsR4
                         call  drawrow

                         popf
                         pop   dx
                         pop   cx
                         pop   bx
                         pop   ax
                         ret
drawall endp



drawrow proc far
    ;pushf
    ;push ax
    ;push bx
    ;push cx
    ;push dx
                         mov   ax,1
                         mul   cx
                         push  cx
                         mov   cx,40
                         mul   cx
                         pop   cx
                         add   ax,20
                         mov   column,ax
                         mov   bl,[si]
                         mov   color,bl
                         mov   height,10
                         call  drawonebrick
                         inc   cx
                         inc   si
                         cmp   cx,7
                         jne   drawrow
    ;pop dx
    ;pop cx
    ;pop bx
    ;pop ax
    ;popf
                         mov   color,0
                         ret
drawrow endp


drawonebrick proc far
    ;pushf
                         push  ax
                         push  cx
                         push  dx
                         mov   E,ax
                         add   E,35
                         mov   cx,column
                         mov   dx,row                  ;row
                         mov   al,color
                         mov   ah,0ch
    back:                int   10h
                         inc   cx
                         cmp   cx,E
                         jnz   back
                         jz    drawbrick
    drawbrick:           

                         inc   dx
                         sub   cx,35
                         dec   height
                         cmp   height,0
                         jne   back

                         pop   dx
                         pop   cx
                         pop   ax
    ;popf
                         ret
    
    
drawonebrick endp

GetTime proc far
                         push  ax
                         push  cx
                         push  dx

                         mov   ah, 2ch                 ; Function 2ch: Get Real-Time Clock Time
                         int   21h                     ; Call BIOS interrupt

    ; Store the time in the data segment variables
                         mov   hours, ch
                         mov   minutes, cl
                         mov   seconds, dh
                         mov   TenMilleseconds, dl
                         pop   dx
                         pop   cx
                         pop   ax
                         ret
GetTime endp

SetVideoMode proc far
                         push  ax                      ; Save the AX register
                         mov   ah, 0                   ; Function 0: Set video mode
                         mov   al, 13h                 ; Mode 13h: 320x200 256-color graphics mode
                         int   10h                     ; Call BIOS interrupt
                         pop   ax                      ; Restore the AX register
                         ret
SetVideoMode endp

DrawPixel proc far
                         push  ax
                         push  bx
                         push  cx
                         push  dx
                         push  ds

                         mov   bh,0                    ; Page 0
                         mov   ah, 0Ch                 ; Function 0Ch: Write pixel
                         int   10h                     ; Call BIOS interrupt
    
                         pop   ds
                         pop   dx
                         pop   cx
                         pop   bx
                         pop   ax
                         ret
DrawPixel endp

DrawBall proc far
                         push  ax
                         push  bx
                         push  cx
                         push  dx
                         push  ds

                         mov   bx, ball_side           ; Load side length
                         mov   cx, ball_x              ; Load X coordinate of the top-left corner
                         mov   dx, ball_y              ; Load Y coordinate of the top-left corner

    ; Draw the square
                         mov   si, 0                   ; Start from the first column
    DrawBallLoop:        
                         mov   di, 0                   ; Start from the first row
    DrawBallRow:         
                         mov   al, ball_collor         ; Color of the ball
    ; Calculate the pixel position

                         mov   cx, ball_x              ; X coordinate of the top-left corner
                         add   cx, si                  ; Add the column offset
                         mov   dx, ball_y              ; Load Y coordinate of the top-left corner
                         add   dx, di                  ; Add the row offset

                         call  DrawPixel
    
                         inc   di                      ; Move to the next row
                         cmp   di, bx                  ; Check if all rows are drawn
                         jl    DrawBallRow

                         inc   si                      ; Move to the next column
                         cmp   si, bx                  ; Check if all columns are drawn
                         jl    DrawBallLoop

                         pop   ds
                         pop   dx
                         pop   cx
                         pop   bx
                         pop   ax
                         ret
DrawBall endp

EraseBall proc far
                         push  ax
                         push  bx
                         push  cx
                         push  dx
                         push  ds

                         mov   bx, ball_side           ; Load side length
                         mov   cx, ball_x              ; Load X coordinate of the top-left corner
                         mov   dx, ball_y              ; Load Y coordinate of the top-left corner

    ; Draw the square
                         mov   si, 0                   ; Start from the first column
    EraseBallLoop:       
                         mov   di, 0                   ; Start from the first row
    EraseBallRow:        
                         mov   al, 00                  ; Color of the ball
    ; Calculate the pixel position

                         mov   cx, ball_x              ; X coordinate of the top-left corner
                         add   cx, si                  ; Add the column offset
                         mov   dx, ball_y              ; Load Y coordinate of the top-left corner
                         add   dx, di                  ; Add the row offset

                         call  DrawPixel
    
                         inc   di                      ; Move to the next row
                         cmp   di, bx                  ; Check if all rows are drawn
                         jl    EraseBallRow

                         inc   si                      ; Move to the next column
                         cmp   si, bx                  ; Check if all columns are drawn
                         jl    EraseBallLoop

                         pop   ds
                         pop   dx
                         pop   cx
                         pop   bx
                         pop   ax
                         ret
EraseBall endp

MoveBall proc far
                         push  ax                      ; Save the AX register
                         push  bx                      ; Save the BX register
                         push  cx                      ; Save the CX register
                         push  dx                      ; Save the DX register
    ; Check for collision with screen boundaries and reverse direction if needed
                         cmp   ball_x, 2               ; Check if the ball is within the left boundary
                         jge   NoCollisionX            ; If the ball is within the left boundary, continue
                         neg   ball_vx                 ; Reverse the direction of the ball
    NoCollisionX:                                      ; Check if the ball is within the right boundary
                         mov   ax, WindowWidth         ; Load the width of the window
                         sub   ax, ball_side           ; Subtract the side length of the ball
                         cmp   ball_x, ax              ; Check if the ball is within the right boundary
                         jle   NoCollisionX2           ; If the ball is within the right boundary, continue
                         neg   ball_vx                 ; Reverse the direction of the ball
    NoCollisionX2:                                     ; Check if the ball is within the top boundary
                         cmp   ball_y, 1               ; Check if the ball is within the top boundary
                         jge   NoCollisionY            ; If the ball is within the top boundary, continue
                         neg   ball_vy                 ; Reverse the direction of the ball
    NoCollisionY:        
                         mov   ax, WindowHeight        ; Load the height of the window
                         sub   ax, ball_side           ; Subtract the side length of the ball
                         sub   ax, 5                   ; Subtract the height of the paddle
                         cmp   ax ,ball_y              ; Check if the ball is within the top boundary
                         jg    NoCollisiononPaddle1    ; If the ball is within the top boundary, continue
                         mov   ax, ball_x
                         add   ax, ball_side
                         cmp   ax, p1_x1               ; Check if the ball is within the left boundary
                         jl    NoCollisiononPaddle1
                         mov   ax, ball_x
                         mov   bx, p1_x1
                         add   bx, 40
                         cmp   ax, bx
                         jg    NoCollisiononPaddle1
                         neg   ball_vy
                         jmp   NoCollisionY2
                         
    NoCollisiononPaddle1:
                         mov   ax, WindowHeight        ; Load the height of the window
                         sub   ax, ball_side           ; Subtract the side length of the ball
                         sub   ax, 5                   ; Subtract the height of the paddle
                         cmp   ax ,ball_y              ; Check if the ball is within the top boundary
                         jg    NoCollisiononPaddle2    ; If the ball is within the top boundary, continue
                         mov   ax, ball_x
                         add   ax, ball_side
                         cmp   ax, p2_x1               ; Check if the ball is within the left boundary
                         jl    NoCollisiononPaddle2
                         mov   ax, ball_x
                         mov   bx, p2_x1
                         add   bx, 40
                         cmp   ax, bx
                         jg    NoCollisiononPaddle2
                         neg   ball_vy
                         jmp   NoCollisionY2

    NoCollisiononPaddle2:
                         mov   ax, WindowHeight        ; Load the height of the window
                         sub   ax, ball_side           ; Subtract the side length of the ball
                         cmp   ball_y, ax              ; Check if the ball is within the bottom boundary
                         jle   NoCollisionY2           ; If the ball is within the bottom boundary, continue
                         neg   ball_vy                 ; Reverse the direction of the ball
                         
    NoCollisionY2:                                     ; Draw the ball at the new position

                         call  EraseBall               ; Erase the ball at the current position
                         call  draw_p1_paddle
                         call  draw_p2_paddle
                         mov   ax, ball_x              ; Load the X coordinate of the ball
                         add   ax, ball_vx             ; Add the direction of the ball in X
                         mov   ball_x, ax              ; Store the new X coordinate of the ball
                         mov   ax, ball_y              ; Load the Y coordinate of the ball
                         add   ax, ball_vy             ; Add the direction of the ball in Y
                         mov   ball_y, ax              ; Store the new Y coordinate of the ball
                         call  DrawBall                ; Draw the ball
                         pop   dx                      ; Restore the DX register
                         pop   cx                      ; Restore the CX register
                         pop   bx                      ; Restore the BX register
                         pop   ax                      ; Restore the AX register
                         ret
MoveBall endp

MakeBallIsMoving proc far
                         push  ax                      ;   Save the AX register
                         push  bx                      ;   Save the BX register
                         call  drawall
                         call  move_p1_paddle
                         call  move_p2_paddle
                         call  MoveBall                ; Move the ball
                         call  GetTime                 ; Get the current time
                         mov   al, TenMilleseconds     ; Load the current time
    check_time:                                        ; Check if 1/100 of a second has passed
                         call  GetTime                 ; Get the current time
                         cmp   al, TenMilleseconds     ; Compare the start time with the current time
                         je    check_time              ; wait until 1/100 of a second has passed
                         call  MakeBallIsMoving        ; Repeat the process
                         pop   bx                      ;   Restore the BX register
                         pop   ax
                         ret
MakeBallIsMoving endp

main proc far
                         mov   ax, @data
    ; Initialize the data segment
                         mov   ax,@data
                         mov   dx,ax
                         mov   ds,ax                   ; if you forget this color array will not work
                         mov   es,ax                   ; if you forget this color array will not work
                         call  SetVideoMode
                         call  DrawBall
                         call  MoveBall
                         call  draw_p1_paddle
                         call  draw_p2_paddle
                         call  MakeBallIsMoving

    ; only change coloumn postion and row postion and colour all this prameter changes with calculations
    ; Exit the program
                         mov   ah, 4Ch                 ; DOS function 4Ch: Terminate program
                         int   21h                     ; Call DOS interrupt
main endp
end main                ; End of the program
