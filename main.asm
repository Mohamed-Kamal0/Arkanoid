.model small           ; Define the memory model
.stack 286h            ; Set the stack size
.data                                                                                                                                                                                 ; Section for initialized data
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
    ball_x                   dw 161                                                                                                                                                   ; X coordinate for the ball
    ball_y                   dw 186                                                                                                                                                   ; Y coordinate for the ball
    ball_collor              db 10                                                                                                                                                    ; Color of the ball
    ball_side                dw 3                                                                                                                                                     ; Side length of the ball(square)
    ball_vx                  dw 3                                                                                                                                                     ; direction of the ball in x
    ball_vy                  dw 3                                                                                                                                                     ; direction of the ball in y
    Start_Time               db 0                                                                                                                                                     ; Variable to store the start time
    hours                    db 0                                                                                                                                                     ; Variable to store hours
    minutes                  db 0                                                                                                                                                     ; Variable to store minutes
    seconds                  db 0                                                                                                                                                     ; Variable to store seconds
    TenMilleseconds          db 0                                                                                                                                                     ; Variable to store milliseconds
    WindowWidth              dw 317                                                                                                                                                   ; Width of the window
    WindowHeight             dw 197                                                                                                                                                   ; Height of the window
    column                   dw 2 dup(?)
    row                      dw 2 dup(?)
    color                    db ?
    height                   db ?
    colorsR1                 db 2, 4, 6, 1, 3, 5, 7
    colorsR2                 db 1, 3, 5, 7, 2, 4, 6
    colorsR3                 db 7, 5, 3, 1, 6, 4, 2
    colorsR4                 db 1, 4, 2, 3, 5, 7, 6
    ; colorsR1                 db 0, 0, 0, 0, 0, 0, 0
    ; colorsR2                 db 1, 1, 1, 1, 1, 1, 1
    ; colorsR3                 db 0, 0, 0, 0, 0, 0, 0
    ; colorsR4                 db 0, 0, 0, 0, 0, 0, 0
    ;colors of each row
    ;arrays of start and end of each blocks number equal number of rows
    E                        dw 2 dup(?)                                                                                                                                              ; E is the end of the row
    ; Paddle dimensions
    paddle_width             db 40                                                                                                                                                    ; Width of the rectangle
    paddle_height            db 5                                                                                                                                                     ; Height of the rectangle

    ; Paddle 1 coordinates
    p1_x1                    dw 145                                                                                                                                                   ; X-coordinate of the bottom-left corner
    p1_y1                    dw 197                                                                                                                                                   ; Y-coordinate of the bottom-left corner

    ; Paddle 2 coordinates
    p2_x1                    dw 145                                                                                                                                                   ; X-coordinate of the bottom-left corner (player 2)
    p2_y1                    dw 197                                                                                                                                                   ; Y-coordinate of the bottom-left corner (player 2)

    ; Paddle colors
    paddle_p1_color          db 10                                                                                                                                                    ; Color for player 1 paddle
    paddle_p2_color          db 11                                                                                                                                                    ; Color for player 2 paddle


    ; To store key inputs for players
    input_p1_key             db ?                                                                                                                                                     ; Key input for player 1
    input_p2_key             db ?                                                                                                                                                     ; Key input for player 2

    drawing_x1               dw 10
    drawing_y1               dw 0
    drawing_x2               dw 20
    drawing_y2               dw 50
    drawing_words_color      db 12
    postionRx                dw 0020, 0060, 0100, 0140, 0180, 0220, 0260
    postionR1y               dw 17
    postionR2y               dw 29
    postionR3y               dw 41
    postionR4y               dw 53
    remainingBricks          db 28
    num_of_tries             db 6

    ; Screen dimensions

    ;----- chat data ----------
    in_char                  db ?,"$"
    out_char                 db ?,"$"
    last_out_x_pos           db 0
    last_out_y_pos           db 0
    last_in_x_pos            db 0
    last_in_y_pos            db 13
    chat_color               db 15
    out_start_char           db ?
    in_start_char           db ?
    ;-----------------------

    ;-------- merge modes --------
    selector                 db ?
    selecting_prombt_message db 'enter a number to choose a mode', 10, 13 , '0 -> One Player Mode' , 10 , 13 , '1 -> Two players Mode' , 10 , 13 , '2 -> Chat Mode' , 10 , 13, '$'
    ;-----------------------

.code                                                                                    ; Section for code

    ;drawing words and tries
draw_rectangle proc far
                                      mov           CX, drawing_x1                       ; Set the initial X-coordinate
                                      mov           DX, drawing_y1                       ; Set the initial Y-coordinate (bottom)
                                      mov           si, drawing_x1                       ; Initialize column counter
                                      mov           di, drawing_y1                       ; Initialize row counter
    draw_loop1:                       
    ; Draw a single pixel
                                      mov           al, drawing_words_color              ; Set the color for the pixel
                                      mov           ah, 0ch                              ; Function to draw a pixel
                                      int           10h                                  ; Call BIOS interrupt to draw

    ; Move to the next pixel in the row
                                      inc           si                                   ; Increment column counter
                                      mov           CX,si                                ; Increment X-coordinate
                                      cmp           si,drawing_x2                        ; Check if the current row is complete
                                      jbe           draw_loop1                           ; Continue drawing the row if not finished

    ; Move to the next row
                                      mov           si, drawing_x1                       ; Reset column counter
                                      mov           CX, drawing_x1                       ; Reset X-coordinate to the start of the row
                                      inc           DI                                   ; Move up (decrease Y-coordinate)
                                      mov           DX,DI                                ; Increment row counter
                                      cmp           DI,drawing_y2                        ; Check if all rows are drawn
                                      jbe           draw_loop1                           ; Continue drawing rows if not finished
                                      ret
draw_rectangle endp

draw_L proc far
                                      mov           drawing_x1,10
                                      mov           drawing_y1,50
                                      mov           drawing_x2,30
                                      mov           drawing_y2,150
                                      call          draw_rectangle
                                      mov           drawing_x1,30
                                      mov           drawing_y1,130
                                      mov           drawing_x2,64
                                      mov           drawing_y2,150
                                      call          draw_rectangle
                                      ret
draw_L endp


draw_O proc far
                                      mov           drawing_x1,74
                                      mov           drawing_y1,50
                                      mov           drawing_x2,128
                                      mov           drawing_y2,70
                                      call          draw_rectangle
                                      mov           drawing_x1,74
                                      mov           drawing_y1,130
                                      mov           drawing_x2,128
                                      mov           drawing_y2,150
                                      call          draw_rectangle
                                      mov           drawing_x1,74
                                      mov           drawing_y1,70
                                      mov           drawing_x2,94
                                      mov           drawing_y2,130
                                      call          draw_rectangle
                                      mov           drawing_x1,108
                                      mov           drawing_y1,70
                                      mov           drawing_x2,128
                                      mov           drawing_y2,130
                                      call          draw_rectangle
                                      ret
draw_O endp


draw_S proc far
                                      mov           drawing_x1,138
                                      mov           drawing_y1,130
                                      mov           drawing_x2,172
                                      mov           drawing_y2,150
                                      call          draw_rectangle
                                      mov           drawing_x1,158
                                      mov           drawing_y1,50
                                      mov           drawing_x2,192
                                      mov           drawing_y2,70
                                      call          draw_rectangle
                                      mov           drawing_x1,158
                                      mov           drawing_y1,70
                                      mov           drawing_x2,172
                                      mov           drawing_y2,130
                                      call          draw_rectangle

                                      ret
draw_S endp

draw_E proc far
                                      mov           drawing_x1,202
                                      mov           drawing_y1,50
                                      mov           drawing_x2,226
                                      mov           drawing_y2,150
                                      call          draw_rectangle

                                      mov           drawing_x1,226
                                      mov           drawing_y1,50
                                      mov           drawing_x2,256
                                      mov           drawing_y2,70
                                      call          draw_rectangle
                                      mov           drawing_x1,226
                                      mov           drawing_y1,90
                                      mov           drawing_x2,256
                                      mov           drawing_y2,110
                                      call          draw_rectangle
                                      mov           drawing_x1,226
                                      mov           drawing_y1,130
                                      mov           drawing_x2,256
                                      mov           drawing_y2,150
                                      call          draw_rectangle

                                      ret
draw_E endp

draw_exclamation_mark_lose proc far
                                      mov           drawing_x1,290
                                      mov           drawing_y1,50
                                      mov           drawing_x2,310
                                      mov           drawing_y2,120
                                      call          draw_rectangle

                                      mov           drawing_x1,290
                                      mov           drawing_y1,130
                                      mov           drawing_x2,310
                                      mov           drawing_y2,150
                                      call          draw_rectangle


                                      ret
draw_exclamation_mark_lose endp




draw_W proc far

                                      mov           drawing_x1,10
                                      mov           drawing_y1,50
                                      mov           drawing_x2,32
                                      mov           drawing_y2,150
                                      call          draw_rectangle

                                      mov           drawing_x1,100
                                      mov           drawing_y1,50
                                      mov           drawing_x2,122
                                      mov           drawing_y2,150
                                      call          draw_rectangle
                                      mov           drawing_x1,32
                                      mov           drawing_y1,130
                                      mov           drawing_x2,100
                                      mov           drawing_y2,150
                                      call          draw_rectangle
    
                                      mov           drawing_x1,55
                                      mov           drawing_y1,50
                                      mov           drawing_x2,77
                                      mov           drawing_y2,130
                                      call          draw_rectangle
    
                                      ret
draw_W endp


draw_i proc far

                                      mov           drawing_x1,132
                                      mov           drawing_y1,50
                                      mov           drawing_x2,169
                                      mov           drawing_y2,70
                                      call          draw_rectangle

                                      mov           drawing_x1,132
                                      mov           drawing_y1,80
                                      mov           drawing_x2,169
                                      mov           drawing_y2,150
                                      call          draw_rectangle
 
                                      ret
draw_i endp

draw_N proc far

                                      mov           drawing_x1,179
                                      mov           drawing_y1,50
                                      mov           drawing_x2,253
                                      mov           drawing_y2,75
                                      call          draw_rectangle

                                      mov           drawing_x1,179
                                      mov           drawing_y1,70
                                      mov           drawing_x2,204
                                      mov           drawing_y2,150
                                      call          draw_rectangle

                                      mov           drawing_x1,228
                                      mov           drawing_y1,70
                                      mov           drawing_x2,253
                                      mov           drawing_y2,150
                                      call          draw_rectangle

                                      ret
draw_N endp

draw_exclamation_mark_win proc far

                                      mov           drawing_x1,280
                                      mov           drawing_y1,50
                                      mov           drawing_x2,310
                                      mov           drawing_y2,120
                                      call          draw_rectangle

                                      mov           drawing_x1,280
                                      mov           drawing_y1,130
                                      mov           drawing_x2,310
                                      mov           drawing_y2,150
                                      call          draw_rectangle


                                      ret
draw_exclamation_mark_win endp

clear_screen_proc proc far
                                      mov           drawing_words_color,0                ;balck
                                      mov           drawing_x1,0
                                      mov           drawing_y1,0
                                      mov           drawing_x2,320
                                      mov           drawing_y2,200
                                      call          draw_rectangle
                                      ret
clear_screen_proc endp


draw_word_win proc far

                                      call          clear_screen_proc
                                      mov           drawing_words_color,10               ;light green
                                      call          draw_W
                                      call          draw_i
                                      call          draw_N
                                      call          draw_exclamation_mark_win

                                      ret
draw_word_win endp

draw_word_lose proc far

                                      call          clear_screen_proc
                                      mov           drawing_words_color,12               ;light red
                                      call          draw_L
                                      call          draw_O
                                      call          draw_S
                                      call          draw_E
                                      call          draw_exclamation_mark_lose
                                      ret
draw_word_lose endp

draw_tries proc far

                                      mov           drawing_words_color,15
                                      mov           drawing_x1,0
                                      mov           drawing_y1,15
                                      mov           drawing_x2,320
                                      mov           drawing_y2,15
                                      call          draw_rectangle
                                      mov           drawing_x1,62
                                      mov           drawing_y1,0
                                      mov           drawing_x2,62
                                      mov           drawing_y2,15
                                      call          draw_rectangle

                                      mov           drawing_words_color,0
                                      mov           drawing_x1,0
                                      mov           drawing_y1,2
                                      mov           drawing_x2,61
                                      mov           drawing_y2,14
                                      call          draw_rectangle
    

    green_color:                      
                                      mov           drawing_words_color,10

                                      cmp           num_of_tries,3

                                      jae           start_drawing
    red_color:                        
                                      mov           drawing_words_color,12

    start_drawing:                    
                                      cmp           num_of_tries,5
                                      jz            fifth_try
                                      cmp           num_of_tries,4
                                      jz            fourth_try
                                      cmp           num_of_tries,3
                                      jz            third_try
                                      cmp           num_of_tries,2
                                      jz            second_try
                                      cmp           num_of_tries,1
                                      jz            first_try
    ;return if tries = 0
                                      ret

    fifth_try:                        
                                      mov           drawing_x1,50
                                      mov           drawing_y1,2
                                      mov           drawing_x2,60
                                      mov           drawing_y2,12
                                      call          draw_rectangle
    fourth_try:                       
                                      mov           drawing_x1,38
                                      mov           drawing_y1,2
                                      mov           drawing_x2,48
                                      mov           drawing_y2,12
                                      call          draw_rectangle
    third_try:                        
                                      mov           drawing_x1,26
                                      mov           drawing_y1,2
                                      mov           drawing_x2,36
                                      mov           drawing_y2,12
                                      call          draw_rectangle
    second_try:                       
                                      mov           drawing_x1,14
                                      mov           drawing_y1,2
                                      mov           drawing_x2,24
                                      mov           drawing_y2,12
                                      call          draw_rectangle
    first_try:                        
                                      mov           drawing_x1,2
                                      mov           drawing_y1,2
                                      mov           drawing_x2,12
                                      mov           drawing_y2,12
                                      call          draw_rectangle

    end_draw_tries_proc:              
                                      ret
draw_tries endp

decrease_num_of_tries proc far

                                      cmp           num_of_tries,0
                                      jz            end_decrease_num_of_tries_proc

                                      dec           num_of_tries
                                      call          draw_tries

    end_decrease_num_of_tries_proc:   
                                      ret
decrease_num_of_tries endp

    ;----------------------

initialization proc far
    ; initinalize COM
    ;Set Divisor Latch Access Bit
                                      mov           dx,3fbh                              ; Line Control Register
                                      mov           al,10000000b                         ;Set Divisor Latch Access Bit
                                      out           dx,al                                ;Out it
    ;Set LSB byte of the Baud Rate Divisor Latch register.
                                      mov           dx,3f8h
                                      mov           al,0ch
                                      out           dx,al

    ;Set MSB byte of the Baud Rate Divisor Latch register.
                                      mov           dx,3f9h
                                      mov           al,00h
                                      out           dx,al

    ;Set port configuration
                                      mov           dx,3fbh
                                      mov           al,00011011b
                                      out           dx,al

                                      ret
initialization endp

    ;------------------------------------------------------------------
    ; Draw player 1 paddle
draw_p1_paddle proc far
                                      push          ax
                                      push          bx
                                      push          cx
                                      push          dx

    ; Initialize X and Y coordinates
                                      mov           CX, p1_x1
                                      mov           DX, p1_y1
                                      mov           bl, 0h                               ; Column counter
                                      mov           bh, 0h                               ; Row counter

    draw_p1_loop:                     
    ; Draw a pixel for the paddle
                                      mov           al, paddle_p1_color                  ; Set paddle color
                                      mov           ah, 0ch                              ; Function to draw a pixel
                                      int           10h                                  ; Call interrupt to draw

    ; Move to the next pixel in the row
                                      inc           CX                                   ; Increment X-coordinate
                                      inc           bl                                   ; Increment column counter
                                      cmp           bl, paddle_width                     ; Check if the row is complete
                                      jbe           draw_p1_loop                         ; Continue drawing row if not finished

    ; Move to the next row
                                      mov           bl, 0h                               ; Reset column counter
                                      mov           CX, p1_x1                            ; Reset X-coordinate
                                      dec           DX                                   ; Move up to the next row
                                      inc           bh                                   ; Increment row counter
                                      cmp           bh, paddle_height                    ; Check if all rows are drawn
                                      jbe           draw_p1_loop                         ; Continue if more rows need drawing

    ; Restore registers and return
                                      pop           dx
                                      pop           cx
                                      pop           bx
                                      pop           ax
                                      ret
draw_p1_paddle endp

    ; Similar function for player 2 paddle
draw_p2_paddle proc far
                                      push          ax
                                      push          bx
                                      push          cx
                                      push          dx

    ; Initialize X and Y coordinates
                                      mov           CX, p2_x1
                                      mov           DX, p2_y1
                                      mov           bl, 0h
                                      mov           bh, 0h

    draw_p2_loop:                     
    ; Draw a pixel for the paddle
                                      mov           al, paddle_p2_color
                                      mov           ah, 0ch
                                      int           10h

    ; Move to the next pixel in the row
                                      inc           CX
                                      inc           bl
                                      cmp           bl, paddle_width
                                      jbe           draw_p2_loop

    ; Move to the next row
                                      mov           bl, 0h
                                      mov           CX, p2_x1
                                      dec           DX
                                      inc           bh
                                      cmp           bh, paddle_height
                                      jbe           draw_p2_loop

    ; Restore registers and return
                                      pop           dx
                                      pop           cx
                                      pop           bx
                                      pop           ax
                                      ret
draw_p2_paddle endp

    ; Erase player 1 paddle by drawing black pixels
erase_p1_paddle proc far
                                      push          ax
                                      push          bx
                                      push          cx
                                      push          dx

    ; Initialize X and Y coordinates
                                      mov           CX, p1_x1
                                      mov           DX, p1_y1
                                      mov           bl, 0h
                                      mov           bh, 0h

    erase_p1_loop:                    
    ; Draw black pixel to erase
                                      mov           al, 0                                ; Black color
                                      mov           ah, 0ch                              ; Function to draw pixel
                                      int           10h

    ; Move to the next pixel in the row
                                      inc           CX
                                      inc           bl
                                      cmp           bl, paddle_width
                                      jbe           erase_p1_loop

    ; Move to the next row
                                      mov           bl, 0h
                                      mov           CX, p1_x1
                                      dec           DX
                                      inc           bh
                                      cmp           bh, paddle_height
                                      jbe           erase_p1_loop

    ; Restore registers and return
                                      pop           dx
                                      pop           cx
                                      pop           bx
                                      pop           ax
                                      ret
erase_p1_paddle endp

    ; Similar function for erasing player 2 paddle
erase_p2_paddle proc far
                                      push          ax
                                      push          bx
                                      push          cx
                                      push          dx

                                      mov           CX, p2_x1
                                      mov           DX, p2_y1
                                      mov           bl, 0h
                                      mov           bh, 0h

    erase_p2_loop:                    
                                      mov           al, 0
                                      mov           ah, 0ch
                                      int           10h

                                      inc           CX
                                      inc           bl
                                      cmp           bl, paddle_width
                                      jbe           erase_p2_loop

                                      mov           bl, 0h
                                      mov           CX, p2_x1
                                      dec           DX
                                      inc           bh
                                      cmp           bh, paddle_height
                                      jbe           erase_p2_loop

                                      pop           dx
                                      pop           cx
                                      pop           bx
                                      pop           ax
                                      ret
erase_p2_paddle endp

    ; Move player 1 paddle based on keyboard input
move_p1_paddle proc far
                                      push          ax
                                      push          bx
                                      push          cx
                                      push          dx
                                      pushf
                                      
    ; Check if a key is pressed
                                      mov           ah, 1
                                      int           16h
                                      jz            endp_procedure                       ; No key pressed, exit

    ; Read key input
                                      mov           ah, 0
                                      int           16h
                                      mov           input_p1_key, al                     ; Store key input

    ;check if ready to receive
                                      mov           dx , 3FDH                            ; Line Status Register
                                      In            al , dx                              ;Read Line Status
                                      AND           al , 00100000b
                                      JZ            continue_moving

    ;send data
                                      mov           dx , 3F8H                            ; Transmit data register
                                      mov           al,input_p1_key
                                      out           dx , al
    
                                      cmp           input_p1_key,1bh
                                      jnz           continue_moving

    ; go to main minue
                                      call return_to_main_mineu

    continue_moving:                  
    ; Check for 'd' key to move right
                                      cmp           al, 100
                                      jz            go_right

    ; Check for 'a' key to move left
                                      cmp           al, 97
                                      jz            go_left

                                      jmp           endp_procedure                       ; If no relevant key, exit

    go_right:                         
                                      cmp           p1_x1, 275                           ; Prevent moving past screen edge
                                      jae           endp_procedure
                                      call          erase_p1_paddle                      ; Erase current paddle
                                      add           p1_x1, 5                             ; Move paddle to the right
                                      jmp           draw_paddles

    go_left:                          
                                      cmp           p1_x1, 1                             ; Prevent moving past screen edge
                                      jbe           endp_procedure
                                      call          erase_p1_paddle                      ; Erase current paddle
                                      sub           p1_x1, 5                             ; Move paddle to the left

    draw_paddles:                     
                                      call          draw_p1_paddle
                                      cmp           selector,'0'
                                      je            endp_procedure
                                      call          draw_p2_paddle                       ; Redraw both paddles

    endp_procedure:                   
                                      popf
                                      pop           dx
                                      pop           cx
                                      pop           bx
                                      pop           ax
                                      ret
move_p1_paddle endp

    ; Similar function for moving player 2 paddle
    ; Similar function for moving player 2 paddle
move_p2_paddle proc far
                                      push          ax
                                      push          bx
                                      push          cx
                                      push          dx
                                      pushf
    ;check if receive
                                      mov           dx , 3FDH                            ; Line Status Register
                                      in            al , dx
                                      AND           al , 1
                                      JZ            endp_procedure2

    ;receive data
                                      mov           dx , 03F8H
                                      in            al , dx
                                      mov           input_p2_key , al

                                      cmp           input_p2_key,1bh
                                      jnz           cont_mov

    ; go to main minue
                                      call return_to_main_mineu

    ; Check for 'l' key to move right
    cont_mov:                         
                                      cmp           input_p2_key, 100
                                      jz            go_right2

    ; Check for 'j' key to move left
                                      cmp           input_p2_key, 97
                                      jz            go_left2

                                      jmp           endp_procedure2                      ; If no relevant key, exit

    go_right2:                        
                                      cmp           p2_x1, 275                           ; Prevent moving past screen edge
                                      jae           endp_procedure2
                                      call          erase_p2_paddle                      ; Erase current paddle
                                      add           p2_x1, 5                             ; Move paddle to the right
                                      jmp           draw_paddles2

    go_left2:                         
                                      cmp           p2_x1, 1                             ; Prevent moving past screen edge
                                      jbe           endp_procedure2
                                      call          erase_p2_paddle                      ; Erase current paddle
                                      sub           p2_x1, 5                             ; Move paddle to the left

    draw_paddles2:                    
                                      call          draw_p1_paddle                       ; Redraw both paddles
                                      cmp           selector,'0'
                                      je            endp_procedure2
                                      call          draw_p2_paddle

    endp_procedure2:                  
                                      popf
                                      pop           dx
                                      pop           cx
                                      pop           bx
                                      pop           ax
                                      ret
move_p2_paddle endp

drawall proc
                                      push          ax
                                      push          bx
                                      push          cx
                                      push          dx
                                      pushf
                                      mov           column,0
                                      mov           row ,17
                                      mov           color,0
                                      mov           height,10

                                      mov           cx,0
                                      mov           ax,1
                                      lea           SI, colorsR1
                                      call          drawrow

                                      mov           column,0
                                      mov           row ,29
                                      mov           cx,0
                                      mov           ax,1
                                      lea           SI, colorsR2
                                      call          drawrow

                                      mov           column ,0
                                      mov           row ,41
                                      mov           cx,0
                                      mov           ax,1
                                      lea           SI, colorsR3
                                      call          drawrow

                                      mov           column ,0
                                      mov           row ,53
                                      mov           cx,0
                                      mov           ax,1
                                      lea           SI, colorsR4
                                      call          drawrow

                                      popf
                                      pop           dx
                                      pop           cx
                                      pop           bx
                                      pop           ax
                                      ret
drawall endp



drawrow proc
    ;pushf
    ;push ax
    ;push bx
    ;push cx
    ;push dx
                                      mov           ax,1
                                      mul           cx
                                      push          cx
                                      mov           cx,40
                                      mul           cx
                                      pop           cx
                                      add           ax,20
                                      mov           column,ax
                                      mov           bl,[si]
            
        
            
                                      mov           color,bl
                                      mov           height,10
                                      call          drawonebrick
                                      inc           cx
                                      inc           si
                                      add           DI,2
                                      cmp           cx,7
                                      jne           drawrow
    ;pop dx
    ;pop cx
    ;pop bx
    ;pop ax
    ;popf
                                      mov           color,0
                                      ret
drawrow endp


drawonebrick proc
    ;pushf
                                      push          ax
                                      push          cx
                                      push          dx
                                      mov           E,ax
                                      add           E,36
                                      mov           cx,column
                                      mov           dx,row                               ;row
                                      mov           al,color
                                      mov           ah,0ch
    back:                             int           10h
                                      inc           cx
                                      cmp           cx,E
                                      jnz           back
                                      jz            drawbrick


    drawbrick:                        
    



                                      inc           dx
                                      sub           cx,36
                                      dec           height
                                      cmp           height,0
                                      jne           back

                                      pop           dx
                                      pop           cx
                                      pop           ax
    ;popf
                                      ret
    
    
drawonebrick endp


GetTime proc far
                                      push          ax
                                      push          cx
                                      push          dx

                                      mov           ah, 2ch                              ; Function 2ch: Get Real-Time Clock Time
                                      int           21h                                  ; Call BIOS interrupt

    ; Store the time in the data segment variables
                                      mov           hours, ch
                                      mov           minutes, cl
                                      mov           seconds, dh
                                      mov           TenMilleseconds, dl
                                      pop           dx
                                      pop           cx
                                      pop           ax
                                      ret
GetTime endp

SetVideoMode proc far
                                      push          ax                                   ; Save the AX register
                                      mov           ah, 0                                ; Function 0: Set video mode
                                      mov           al, 13h                              ; Mode 13h: 320x200 256-color graphics mode
                                      int           10h                                  ; Call BIOS interrupt
                                      pop           ax                                   ; Restore the AX register
                                      ret
SetVideoMode endp

DrawPixel proc far
                                      push          ax
                                      push          bx
                                      push          cx
                                      push          dx
                                      push          ds

                                      mov           bh,0                                 ; Page 0
                                      mov           ah, 0Ch                              ; Function 0Ch: Write pixel
                                      int           10h                                  ; Call BIOS interrupt
    
                                      pop           ds
                                      pop           dx
                                      pop           cx
                                      pop           bx
                                      pop           ax
                                      ret
DrawPixel endp

DrawBall proc far
                                      push          ax
                                      push          bx
                                      push          cx
                                      push          dx
                                      push          ds

                                      mov           bx, ball_side                        ; Load side length
                                      mov           cx, ball_x                           ; Load X coordinate of the top-left corner
                                      mov           dx, ball_y                           ; Load Y coordinate of the top-left corner

    ; Draw the square
                                      mov           si, 0                                ; Start from the first column
    DrawBallLoop:                     
                                      mov           di, 0                                ; Start from the first row
    DrawBallRow:                      
                                      mov           al, ball_collor                      ; Color of the ball
    ; Calculate the pixel position

                                      mov           cx, ball_x                           ; X coordinate of the top-left corner
                                      add           cx, si                               ; Add the column offset
                                      mov           dx, ball_y                           ; Load Y coordinate of the top-left corner
                                      add           dx, di                               ; Add the row offset

                                      call          DrawPixel
    
                                      inc           di                                   ; Move to the next row
                                      cmp           di, bx                               ; Check if all rows are drawn
                                      jl            DrawBallRow

                                      inc           si                                   ; Move to the next column
                                      cmp           si, bx                               ; Check if all columns are drawn
                                      jl            DrawBallLoop

                                      pop           ds
                                      pop           dx
                                      pop           cx
                                      pop           bx
                                      pop           ax
                                      ret
DrawBall endp

EraseBall proc far
                                      push          ax
                                      push          bx
                                      push          cx
                                      push          dx
                                      push          ds

                                      mov           bx, ball_side                        ; Load side length
                                      mov           cx, ball_x                           ; Load X coordinate of the top-left corner
                                      mov           dx, ball_y                           ; Load Y coordinate of the top-left corner

    ; Draw the square
                                      mov           si, 0                                ; Start from the first column
    EraseBallLoop:                    
                                      mov           di, 0                                ; Start from the first row
    EraseBallRow:                     
                                      mov           al, 00                               ; Color of the ball
    ; Calculate the pixel position

                                      mov           cx, ball_x                           ; X coordinate of the top-left corner
                                      add           cx, si                               ; Add the column offset
                                      mov           dx, ball_y                           ; Load Y coordinate of the top-left corner
                                      add           dx, di                               ; Add the row offset

                                      call          DrawPixel
    
                                      inc           di                                   ; Move to the next row
                                      cmp           di, bx                               ; Check if all rows are drawn
                                      jl            EraseBallRow

                                      inc           si                                   ; Move to the next column
                                      cmp           si, bx                               ; Check if all columns are drawn
                                      jl            EraseBallLoop

                                      pop           ds
                                      pop           dx
                                      pop           cx
                                      pop           bx
                                      pop           ax
                                      ret
EraseBall endp

MoveBall proc far
                                      push          ax                                   ; Save the AX register
                                      push          bx                                   ; Save the BX register
                                      push          cx                                   ; Save the CX register
                                      push          dx                                   ; Save the DX register
    ; Check for collision with screen boundaries and reverse direction if needed
                                      cmp           ball_x, 3                            ; Check if the ball is within the left boundary
                                      jge           NoCollisionX                         ; If the ball is within the left boundary, continue
                                      neg           ball_vx                              ; Reverse the direction of the ball
    NoCollisionX:                                                                        ; Check if the ball is within the right boundary
                                      mov           ax, WindowWidth                      ; Load the width of the window
                                      sub           ax, ball_side                        ; Subtract the side length of the ball
                                      cmp           ball_x, ax                           ; Check if the ball is within the right boundary
                                      jle           NoCollisionX2                        ; If the ball is within the right boundary, continue
                                      neg           ball_vx                              ; Reverse the direction of the ball
    NoCollisionX2:                                                                       ; Check if the ball is within the top boundary
                                      cmp           ball_y, 19                           ; Check if the ball is within the top boundary
                                      jge           NoCollisionY                         ; If the ball is within the top boundary, continue
                                      neg           ball_vy                              ; Reverse the direction of the ball
    NoCollisionY:                     
                                      mov           ax, WindowHeight                     ; Load the height of the window
                                      sub           ax, ball_side                        ; Subtract the side length of the ball
                                      sub           ax, 5                                ; Subtract the height of the paddle
                                      cmp           ax ,ball_y                           ; Check if the ball is within the top boundary
                                      jne           NoCollisiononPaddle1                 ; If the ball is within the top boundary, continue
                                      mov           ax, ball_x
                                      add           ax, ball_side
                                      cmp           ax, p1_x1                            ; Check if the ball is within the left boundary
                                      jl            NoCollisiononPaddle1
                                      mov           ax, ball_x
                                      mov           bx, p1_x1
                                      add           bx, 40
                                      cmp           ax, bx
                                      jg            NoCollisiononPaddle1
                                      neg           ball_vy
                                      jmp           NoCollisionY2
                         
    NoCollisiononPaddle1:             
    ;                                mov   ax, ball_x                        ; Load the height of the window
    ;                                add   ax, ball_side                     ; Subtract the side length of the ball
    ;                                cmp   ax ,p1_x1                         ; Check if the ball is within the top boundary
    ;                                jl    NoCollisiononPaddle1_side         ; If the ball is within the top boundary, continue
    ;                                mov   ax, p1_x1
    ;                                add   ax, 40
    ;                                cmp   ax, ball_x                        ; Check if the ball is within the left boundary
    ;                                jl    NoCollisiononPaddle1_side
    ;                                mov   ax, ball_y
    ;                                add   ax, ball_side
    ;                                mov   bx, p1_y1
    ;                                sub   bx, 5
    ;                                cmp   ax, bx
    ;                                jl    NoCollisiononPaddle1_side
    ;                                neg   ball_vx
    ;                                jmp   NoCollisionY2
    ; NoCollisiononPaddle1_side:
                                      cmp           selector,'0'
                                      je            NoCollisiononPaddle2
                                      mov           ax, WindowHeight                     ; Load the height of the window
                                      sub           ax, ball_side                        ; Subtract the side length of the ball
                                      sub           ax, 5                                ; Subtract the height of the paddle
                                      cmp           ax ,ball_y                           ; Check if the ball is within the top boundary
                                      jne           NoCollisiononPaddle2                 ; If the ball is within the top boundary, continue
                                      mov           ax, ball_x
                                      add           ax, ball_side
                                      cmp           ax, p2_x1                            ; Check if the ball is within the left boundary
                                      jl            NoCollisiononPaddle2
                                      mov           ax, ball_x
                                      mov           bx, p2_x1
                                      add           bx, 40
                                      cmp           ax, bx
                                      jg            NoCollisiononPaddle2
                                      neg           ball_vy
                                      jmp           NoCollisionY2

    NoCollisiononPaddle2:             
    ;                                mov   ax, ball_x                        ; Load the height of the window
    ;                                add   ax, ball_side                     ; Subtract the side length of the ball
    ;                                cmp   ax ,p2_x1                         ; Check if the ball is within the top boundary
    ;                                jl    NoCollisiononPaddle2_side         ; If the ball is within the top boundary, continue
    ;                                mov   ax, p2_x1
    ;                                add   ax, 40
    ;                                cmp   ax, ball_x                        ; Check if the ball is within the left boundary
    ;                                jl    NoCollisiononPaddle2_side
    ;                                mov   ax, ball_y
    ;                                add   ax, ball_side
    ;                                mov   bx, p2_y1
    ;                                sub   bx, 5
    ;                                cmp   ax, bx
    ;                                jl    NoCollisiononPaddle2_side
    ;                                neg   ball_vx
    ;                                jmp   NoCollisionY2
    ; NoCollisiononPaddle2_side:
                                      cmp           ball_y, 27
                                      jg            NoCollisiononBrickrow1
                                      push          ax
                                      push          bx
                                      push          cx
                                      push          dx
                                      push          si
                                      push          di
                                      mov           si,0
    check_brick1:                     
                                      mov           ax,ball_x
                                      add           ax,ball_side
                                      mov           dx,postionRx[si]
                                      cmp           ax,dx
                                      jl            skip_brick1
                                      sub           ax,ball_side
                                      add           dx,36
                                      cmp           ax,dx
                                      jg            skip_brick1
                                      mov           ax,si
                                      mov           bl,2
                                      div           bl
                                      mov           di,ax
                                      cmp           colorsR1[di],0
                                      je            skip_brick1
                                      neg           ball_vy
                                      dec           colorsR1[di]
                                      call          drawall
                                      cmp           colorsR1[di],0
                                      jne           nobricksdeletedr1
                                      dec           remainingBricks
                                      
    nobricksdeletedr1:                
                                      pop           di
                                      pop           si
                                      pop           DX
                                      pop           CX
                                      pop           BX
                                      pop           AX
                                      jmp           NoCollisionY2

    skip_brick1:                      
                                      add           si,2
                                      cmp           si,14
                                      jnz           check_brick1
                                      pop           di
                                      pop           SI
                                      pop           DX
                                      pop           CX
                                      pop           BX
                                      pop           AX

    NoCollisiononBrickrow1:           
                                      cmp           ball_y, 42
                                      jg            NoCollisiononBrickrow2
                                      cmp           ball_y, 23
                                      jl            NoCollisiononBrickrow2
                                      push          ax
                                      push          bx
                                      push          cx
                                      push          dx
                                      push          si
                                      push          di
                                      mov           si,0
                                      lea           bx,postionRx
    check_brick2:                     
                                      mov           ax,ball_x
                                      add           ax,ball_side
                                      mov           dx,postionRx[si]
                                      cmp           ax,dx
                                      jl            skip_brick2
                                      sub           ax,ball_side
                                      add           dx,36
                                      cmp           ax,dx
                                      jg            skip_brick2
                                      mov           ax,si
                                      mov           bl,2
                                      div           bl
                                      mov           di,ax
                                      cmp           colorsR2[di],0
                                      je            skip_brick2
                                      neg           ball_vy
                                      dec           colorsR2[di]
                                      call          drawall
                                      cmp           colorsR2[di],0
                                      jne           nobricksdeletedr2
                                      dec           remainingBricks
                                      
    nobricksdeletedr2:                
                                      pop           di
                                      pop           si
                                      pop           DX
                                      pop           CX
                                      pop           BX
                                      pop           AX
                                      jmp           NoCollisionY2

    skip_brick2:                      
                                      add           si,2
                                      cmp           si,14
                                      jnz           check_brick2
                                      pop           di
                                      pop           SI
                                      pop           DX
                                      pop           CX
                                      pop           BX
                                      pop           AX

    NoCollisiononBrickrow2:           
                                      cmp           ball_y, 51
                                      jg            NoCollisiononBrickrow3
                                      cmp           ball_y, 36
                                      jl            NoCollisiononBrickrow3
                                      push          ax
                                      push          bx
                                      push          cx
                                      push          dx
                                      push          si
                                      push          di

                                      mov           si,0
                                      lea           bx,postionRx
    check_brick3:                     
                                      mov           ax,ball_x
                                      add           ax,ball_side
                                      mov           dx,postionRx[si]
                                      cmp           ax,dx
                                      jl            skip_brick3
                                      sub           ax,ball_side
                                      add           dx,36
                                      cmp           ax,dx
                                      jg            skip_brick3
                                      mov           ax,si
                                      mov           bl,2
                                      div           bl
                                      mov           di,ax
                                      cmp           colorsR3[di],0
                                      je            skip_brick3
                                      neg           ball_vy
                                      dec           colorsR3[di]
                                      call          drawall
                                      cmp           colorsR3[di],0
                                      jne           nobricksdeletedr3
                                      dec           remainingBricks
                                      call          drawall
    nobricksdeletedr3:                
                                      pop           di
                                      pop           si
                                      pop           DX
                                      pop           CX
                                      pop           BX
                                      pop           AX
                                      jmp           NoCollisionY2

    skip_brick3:                      
                                      add           si,2
                                      cmp           si,14
                                      jnz           check_brick3
                                      pop           di
                                      pop           si
                                      pop           DX
                                      pop           CX
                                      pop           BX
                                      pop           AX
    NoCollisiononBrickrow3:           
                                      cmp           ball_y, 63
                                      jg            NoCollisiononBrickrow4
                                      cmp           ball_y,  47
                                      jl            NoCollisiononBrickrow4
                                      push          ax
                                      push          bx
                                      push          cx
                                      push          dx
                                      push          si
                                      push          di
                                      mov           si,0
    check_brick4:                     
                                      mov           ax,ball_x
                                      add           ax,ball_side
                                      mov           dx,postionRx[si]
                                      cmp           ax,dx
                                      jl            skip_brick4
                                      sub           ax,ball_side
                                      add           dx,36
                                      cmp           ax,dx
                                      jg            skip_brick4
                                      mov           ax,si
                                      mov           bl,2
                                      div           bl
                                      mov           di,ax
                                      cmp           colorsR4[di],0
                                      je            skip_brick4
                                      neg           ball_vy
                                      dec           colorsR4[di]
                                      call          drawall
                                      cmp           colorsR4[di],0
                                      jne           nobricksdeletedr4
                                      dec           remainingBricks
                                      
    nobricksdeletedr4:                
                                      pop           di
                                      pop           si
                                      pop           DX
                                      pop           CX
                                      pop           BX
                                      pop           AX
                                      jmp           NoCollisionY2
    skip_brick4:                      
                                      add           si,2
                                      cmp           si,14
                                      jnz           check_brick4
                                      pop           di
                                      pop           si
                                      pop           DX
                                      pop           CX
                                      pop           BX
                                      pop           AX
    NoCollisiononBrickrow4:           
                                      cmp           ball_x,14
                                      jl            NoCollisiononBrickcomn1
                                      cmp           ball_x,58
                                      jg            NoCollisiononBrickcomn1
                                      push          ax
                                      push          bx
                                      push          cx
                                      push          dx
                                      push          si
                                      push          di
                                      mov           si,0
    check_brick_column1:              
                                      mov           ax,ball_y
                                      add           ax,ball_side
                                      mov           dx,postionR1y[si]
                                      cmp           ax,dx
                                      jl            skip_brick_colmumn1
                                      sub           ax,ball_side
                                      add           dx,10
                                      cmp           ax,dx
                                      jg            skip_brick_colmumn1
                                      mov           ax,SI
                                      mov           bl,2
                                      xor           dx,dx
                                      div           bl
                                      mov           bl, 7
                                      mul           bl
                                      mov           di,ax
                                      cmp           colorsR1[di],0
                                      je            skip_brick_colmumn1
                                      neg           ball_vx
                                      dec           colorsR1[di]
                                      call          drawall
                                      cmp           colorsR1[di],0
                                      jne           nobricksdeleted1
                                      dec           remainingBricks
                                      
    nobricksdeleted1:                 
                                      pop           di
                                      pop           si
                                      pop           DX
                                      pop           CX
                                      pop           BX
                                      pop           AX
                                      jmp           NoCollisionY2
    skip_brick_colmumn1:              
                                      add           si,2
                                      cmp           si,8
                                      jnz           check_brick_column1
                                      pop           di
                                      pop           si
                                      pop           DX
                                      pop           CX
                                      pop           BX
                                      pop           AX
    NoCollisiononBrickcomn1:          
                                      cmp           ball_x,54
                                      jl            NoCollisiononBrickcomn2
                                      cmp           ball_x,99
                                      jg            NoCollisiononBrickcomn2
                                      push          ax
                                      push          bx
                                      push          cx
                                      push          dx
                                      push          si
                                      push          di
                                      mov           si,0
    check_brick_column2:              
                                      mov           ax,ball_y
                                      add           ax,ball_side
                                      mov           dx,postionR1y[si]
                                      cmp           ax,dx
                                      jl            skip_brick_colmumn2
                                      sub           ax,ball_side
                                      add           dx,10
                                      cmp           ax,dx
                                      jg            skip_brick_colmumn2
                                      mov           ax,SI
                                      mov           bl,2
                                      xor           dx,dx
                                      div           bl
                                      mov           bl, 7
                                      mul           bl
                                      add           ax,1
                                      mov           di,ax
                                      cmp           colorsR1[di],0
                                      je            skip_brick_colmumn2
                                      neg           ball_vx
                                      dec           colorsR1[di]
                                      call          drawall
                                      cmp           colorsR1[di],0
                                      jne           nobricksdeleted2
                                      dec           remainingBricks
                                      
    nobricksdeleted2:                 
                                      pop           di
                                      pop           si
                                      pop           DX
                                      pop           CX
                                      pop           BX
                                      pop           AX
                                      jmp           NoCollisionY2
    skip_brick_colmumn2:              
                                      add           si,2
                                      cmp           si,8
                                      jnz           check_brick_column2
                                      pop           di
                                      pop           si
                                      pop           DX
                                      pop           CX
                                      pop           BX
                                      pop           AX
    NoCollisiononBrickcomn2:          
                                      cmp           ball_x,95
                                      jl            NoCollisiononBrickcomn3
                                      cmp           ball_x,139
                                      jg            NoCollisiononBrickcomn3
                                      push          ax
                                      push          bx
                                      push          cx
                                      push          dx
                                      push          si
                                      push          di
                                      mov           si,0
    check_brick_column3:              
                                      mov           ax,ball_y
                                      add           ax,ball_side
                                      mov           dx,postionR1y[si]
                                      cmp           ax,dx
                                      jl            skip_brick_colmumn3
                                      sub           ax,ball_side
                                      add           dx,10
                                      cmp           ax,dx
                                      jg            skip_brick_colmumn3
                                      mov           ax,SI
                                      mov           bl,2
                                      xor           dx,dx
                                      div           bl
                                      mov           bl, 7
                                      mul           bl
                                      add           ax,2
                                      mov           di,ax
                                      cmp           colorsR1[di],0
                                      je            skip_brick_colmumn3
                                      neg           ball_vx
                                      dec           colorsR1[di]
                                      call          drawall
                                      cmp           colorsR1[di],0
                                      jne           nobricksdeleted3
                                      dec           remainingBricks
                                      
    nobricksdeleted3:                 
                                      pop           di
                                      pop           si
                                      pop           DX
                                      pop           CX
                                      pop           BX
                                      pop           AX
                                      jmp           NoCollisionY2
    skip_brick_colmumn3:              
                                      add           si,2
                                      cmp           si,8
                                      jnz           check_brick_column3
                                      pop           di
                                      pop           si
                                      pop           DX
                                      pop           CX
                                      pop           BX
                                      pop           AX
    NoCollisiononBrickcomn3:          
                                      cmp           ball_x,134
                                      jl            NoCollisiononBrickcomn4
                                      cmp           ball_x,178
                                      jg            NoCollisiononBrickcomn4
                                      push          ax
                                      push          bx
                                      push          cx
                                      push          dx
                                      push          si
                                      push          di
                                      mov           si,0
    check_brick_column4:              
                                      mov           ax,ball_y
                                      add           ax,ball_side
                                      mov           dx,postionR1y[si]
                                      cmp           ax,dx
                                      jl            skip_brick_colmumn4
                                      sub           ax,ball_side
                                      add           dx,10
                                      cmp           ax,dx
                                      jg            skip_brick_colmumn4
                                      mov           ax,SI
                                      mov           bl,2
                                      xor           dx,dx
                                      div           bl
                                      mov           bl, 7
                                      mul           bl
                                      add           ax,3
                                      mov           di,ax
                                      cmp           colorsR1[di],0
                                      je            skip_brick_colmumn4
                                      neg           ball_vx
                                      dec           colorsR1[di]
                                      call          drawall
                                      cmp           colorsR1[di],0
                                      jne           nobricksdeleted4
                                      dec           remainingBricks
                                      
    nobricksdeleted4:                 
                                      pop           di
                                      pop           si
                                      pop           DX
                                      pop           CX
                                      pop           BX
                                      pop           AX
                                      jmp           NoCollisionY2
    skip_brick_colmumn4:              
                                      add           si,2
                                      cmp           si,8
                                      jnz           check_brick_column4
                                      pop           di
                                      pop           si
                                      pop           DX
                                      pop           CX
                                      pop           BX
                                      pop           AX
    NoCollisiononBrickcomn4:          
                                      cmp           ball_x,174
                                      jl            NoCollisiononBrickcomn5
                                      cmp           ball_x,219
                                      jg            NoCollisiononBrickcomn5
                                      push          ax
                                      push          bx
                                      push          cx
                                      push          dx
                                      push          si
                                      push          di
                                      mov           si,0
    check_brick_column5:              
                                      mov           ax,ball_y
                                      add           ax,ball_side
                                      mov           dx,postionR1y[si]
                                      cmp           ax,dx
                                      jl            skip_brick_colmumn5
                                      sub           ax,ball_side
                                      add           dx,10
                                      cmp           ax,dx
                                      jg            skip_brick_colmumn5
                                      mov           ax,SI
                                      mov           bl,2
                                      xor           dx,dx
                                      div           bl
                                      mov           bl, 7
                                      mul           bl
                                      add           ax,4
                                      mov           di,ax
                                      cmp           colorsR1[di],0
                                      je            skip_brick_colmumn5
                                      neg           ball_vx
                                      dec           colorsR1[di]
                                      call          drawall
                                      cmp           colorsR1[di],0
                                      jne           nobricksdeleted5
                                      dec           remainingBricks
                                      
    nobricksdeleted5:                 
                                      pop           di
                                      pop           si
                                      pop           DX
                                      pop           CX
                                      pop           BX
                                      pop           AX
                                      jmp           NoCollisionY2
    skip_brick_colmumn5:              
                                      add           si,2
                                      cmp           si,8
                                      jnz           check_brick_column5
                                      pop           di
                                      pop           si
                                      pop           DX
                                      pop           CX
                                      pop           BX
                                      pop           AX
    NoCollisiononBrickcomn5:          
                                      cmp           ball_x,215
                                      jl            NoCollisiononBrickcomn6
                                      cmp           ball_x,258
                                      jg            NoCollisiononBrickcomn6
                                      push          ax
                                      push          bx
                                      push          cx
                                      push          dx
                                      push          si
                                      push          di
                                      mov           si,0
    check_brick_column6:              
                                      mov           ax,ball_y
                                      add           ax,ball_side
                                      mov           dx,postionR1y[si]
                                      cmp           ax,dx
                                      jl            skip_brick_colmumn6
                                      sub           ax,ball_side
                                      add           dx,10
                                      cmp           ax,dx
                                      jg            skip_brick_colmumn6
                                      mov           ax,SI
                                      mov           bl,2
                                      xor           dx,dx
                                      div           bl
                                      mov           bl, 7
                                      mul           bl
                                      add           ax,5
                                      mov           di,ax
                                      cmp           colorsR1[di],0
                                      je            skip_brick_colmumn6
                                      neg           ball_vx
                                      dec           colorsR1[di]
                                      call          drawall
                                      cmp           colorsR1[di],0
                                      jne           nobricksdeleted6
                                      dec           remainingBricks
                                      
    nobricksdeleted6:                 
                                      pop           di
                                      pop           si
                                      pop           DX
                                      pop           CX
                                      pop           BX
                                      pop           AX
                                      jmp           NoCollisionY2
    skip_brick_colmumn6:              
                                      add           si,2
                                      cmp           si,8
                                      jnz           check_brick_column6
                                      pop           di
                                      pop           si
                                      pop           DX
                                      pop           CX
                                      pop           BX
                                      pop           AX
    NoCollisiononBrickcomn6:          
                                      cmp           ball_x,257
                                      jl            NoCollisiononBrickcomn7
                                      cmp           ball_x,300
                                      jg            NoCollisiononBrickcomn7
                                      push          ax
                                      push          bx
                                      push          cx
                                      push          dx
                                      push          si
                                      push          di
                                      mov           si,0
    check_brick_column7:              
                                      mov           ax,ball_y
                                      add           ax,ball_side
                                      mov           dx,postionR1y[si]
                                      cmp           ax,dx
                                      jl            skip_brick_colmumn7
                                      sub           ax,ball_side
                                      add           dx,10
                                      cmp           ax,dx
                                      jg            skip_brick_colmumn7
                                      mov           ax,SI
                                      mov           bl,2
                                      xor           dx,dx
                                      div           bl
                                      mov           bl, 7
                                      mul           bl
                                      add           ax,6
                                      mov           di,ax
                                      cmp           colorsR1[di],0
                                      je            skip_brick_colmumn7
                                      neg           ball_vx
                                      dec           colorsR1[di]
                                      
                                      cmp           colorsR1[di],0
                                      jne           nobricksdeleted7
                                      dec           remainingBricks
                                      
    nobricksdeleted7:                 
                                      pop           di
                                      pop           si
                                      pop           DX
                                      pop           CX
                                      pop           BX
                                      pop           AX
                                      jmp           NoCollisionY2
    skip_brick_colmumn7:              
                                      add           si,2
                                      cmp           si,8
                                      jnz           check_brick_column7
                                      pop           di
                                      pop           si
                                      pop           DX
                                      pop           CX
                                      pop           BX
                                      pop           AX
    NoCollisiononBrickcomn7:          
                                      mov           ax, 192                              ; Load the height of the window
                                      sub           ax, ball_side                        ; Subtract the side length of the ball
                                      cmp           ball_y, ax                           ; Check if the ball is within the bottom boundary
                                      jle           NoCollisionY2                        ; If the ball is within the bottom boundary, continue
    ;neg   ball_vy                 ; Reverse the direction of the ball
                                      call          EraseBall
                                      mov           ball_x,165
                                      mov           ball_y,189
                                      call          DrawBall
                                      call          erase_p1_paddle
                                      mov           p1_x1,145
                                      call          draw_p1_paddle
                                      cmp           selector,'0'
                                      je            no_reset_p2
                                      call          erase_p2_paddle
                                      mov           p2_x1,145
                                      call          draw_p2_paddle
    no_reset_p2:                      
                                      call          decrease_num_of_tries
                                      jmp           wait_for_key_press
                         
    NoCollisionY2:                                                                       ; Draw the ball at the new position
                                      cmp           remainingBricks,0
                                      jne           continueGame
                                      call          draw_word_win
    infintel:                         jmp           infintel
    continueGame:                     
                                      call          EraseBall
                                      call          draw_p1_paddle
                                      cmp           selector,'0'
                                      je            skip_paddle2_cg
                                      call          draw_p2_paddle
    skip_paddle2_cg:                  
                                      mov           ax, ball_x                           ; Load the X coordinate of the ball
                                      add           ax, ball_vx                          ; Add the direction of the ball in X
                                      mov           ball_x, ax                           ; Store the new X coordinate of the ball
                                      mov           ax, ball_y                           ; Load the Y coordinate of the ball
                                      add           ax, ball_vy                          ; Add the direction of the ball in Y
                                      mov           ball_y, ax                           ; Store the new Y coordinate of the ball
                                      call          DrawBall                             ; Draw the ball
                                      pop           dx                                   ; Restore the DX register
                                      pop           cx                                   ; Restore the CX register
                                      pop           bx                                   ; Restore the BX register
                                      pop           ax                                   ; Restore the AX register
                                      ret
MoveBall endp
delay proc far
                                      push          cx
                                      pushf
                                      MOV           CX, 08FFFh                           ; Load CX with a large value (near 65,535)
    DELAY_LOOP:                       
                                      NOP                                                ; No Operation (optional, adds extra delay)
                                      DEC           CX                                   ; Decrement CX
                                      JNZ           DELAY_LOOP                           ; Jump to DELAY_LOOP if CX is not zero
                                      popf
                                      pop           cx
                                      RET                                                ; Return when the delay is over
delay endp
MakeBallIsMoving proc far
                                      push          ax                                   ;   Save the AX register
                                      push          bx                                   ;   Save the BX register
    ;call delay
                                      call          move_p1_paddle
                                      cmp           selector,'0'
                                      je            no_move_p2_paddle
                                      call          move_p2_paddle
    no_move_p2_paddle:                
                                      call          MoveBall                             ; Move the ball
                                      call          GetTime                              ; Get the current time
                                      mov           al, TenMilleseconds                  ; Load the current time
    check_time:                                                                          ; Check if 1/200 of a second has passed
                                      call          GetTime                              ; Get the current time
                                      cmp           al, TenMilleseconds                  ; Compare the start time with the current time
                                      je            check_time                           ; wait until 1/200 of a second has passed
                                      call          MakeBallIsMoving                     ; Repeat the process
                                      pop           bx                                   ;   Restore the BX register
                                      pop           ax
                                      ret
MakeBallIsMoving endp

ClearScreen proc far
                                      mov           ax, 0B800h                           ; Video memory segment for color text mode
                                      mov           es, ax                               ; Set ES to video memory segment
                                      xor           di, di                               ; Start at the beginning of video memory
                                      mov           cx, 2000h                            ; 80 columns * 25 rows = 2000 characters
                                      mov           ax, 0720h                            ; Space character (0x20) with attribute (0x07)
                                      rep           stosw                                ; Fill video memory with spaces
                                      ret
ClearScreen endp

call_two_or_one_players_mode proc far

                                      call          SetVideoMode
                                      call          DrawBall
                                      call          MoveBall
                                      call          drawall
                                      call          decrease_num_of_tries
                                      call          initialization
                                      call          draw_p1_paddle
                                      cmp           selector,'0'
                                      je            wait_for_key_press
                                      call          draw_p2_paddle
     wait_for_key_press:               
                                      cmp           num_of_tries,0
                                      jz            Exit
                                      mov           ah, 1                                ; DOS function 1: Check for key press
                                      int           16h                                  ; Call BIOS interrupt
                                      jz            wait_for_key_press                   ; If no key pressed, loop

                                      mov           ah, 0                                ; DOS function 0: Read key press
                                      int           16h                                  ; Call BIOS interrupt
                                      cmp           al, 'd'                              ; Check if 'd' is pressed
                                      je            start_game
                                      cmp           al, 'a'                              ; Check if 'a' is pressed
                                      je            start_game
                         
                                      jmp           wait_for_key_press                   ; If neither 'd' nor 'a' is pressed, loop

    start_game:                       
                                      call          MakeBallIsMoving

    ; only change coloumn postion and row postion and colour all this prameter changes with calculations
    Exit:                             
                                      call          draw_word_lose

                                      ret
call_two_or_one_players_mode endp


    ;------------------------ chat mode ---------------------------------------
DisChar macro char
                                      push          cx
                                      mov           ah,9                                 ;Display
                                      mov           bh,0                                 ;Page 0
                                      mov           al,char                              ;Letter D
                                      mov           cx,1                                 ;5 times
                                      mov           bl,chat_color                        ;Green (A) on white(F) background
                                      int           10h
                                      pop           cx

                                      endm          DisChar
moveCursor macro x,y
                                      mov           ah,02h
                                      mov           dl,x
                                      mov           dh,y
                                      mov           bh,0
                                      int           10h
                                      endm          moveCursor


draw_chat_line proc
                                      moveCursor    0,12
                                      mov           cx,0
    r:                                
                                      DisChar       '-'
                                      inc           cx
                                      moveCursor    cl,12
                                      cmp           cx,80
                                      jnz           r
                                      moveCursor    0,0
                                      ret
draw_chat_line endp

display_sent_char proc
                                      moveCursor    last_out_x_pos,last_out_y_pos

                                      mov           chat_color,10
                                      cmp           out_char,13
                                      jz            new_line122
                                      DisChar       out_char
                                      inc           last_out_x_pos
                                      cmp           last_out_x_pos,79
                                      jbe           cont1222
                                      mov           last_out_x_pos,0
                                      inc           last_out_y_pos

    cont1222:                         
                                      mov           out_char,al

    new_line122:                      
                                      cmp           out_char,13
                                      jnz           cont
                                      mov           last_out_x_pos,0
                                      inc           last_out_y_pos
                                      moveCursor    last_out_x_pos,last_out_y_pos
    cont:                             

    ;scroll up

                                      cmp           last_out_y_pos,11
                                      jbe           en
                                      mov           ax,0601h
                                      mov           bh,07
                                      mov           cx,0
                                      mov           dx,0B4FH
                                      int           10h
                                      mov           last_out_y_pos ,11
                                      mov           last_out_x_pos ,0
                                      moveCursor    last_out_x_pos,last_out_y_pos

    en:                               
                                      ret
display_sent_char endp

display_received_char proc
                                      moveCursor    last_in_x_pos,last_in_y_pos

                                      mov           chat_color,12
                                      cmp           in_char,13
                                      jz            new_line12233
                                      DisChar       in_char
                                      inc           last_in_x_pos
                                      cmp           last_in_x_pos,79
                                      jbe           cont111
                                      mov           last_in_x_pos,0
                                      inc           last_in_y_pos

    cont111:                          
                                      mov           in_char,al

    new_line12233:                    
                                      cmp           in_char,13
                                      jnz           cont3
                                      mov           last_in_x_pos,0
                                      inc           last_in_y_pos
                                      moveCursor    last_in_x_pos,last_in_y_pos
    cont3:                            

    ;scroll up

                                      cmp           last_in_y_pos,23
                                      jbe           en12

                                      mov           ax,0601h
                                      mov           bh,07
                                      mov           cx,0D00H
                                      mov           dx,174FH
                                      int           10h
                                      mov           last_in_y_pos ,23
                                      mov           last_in_x_pos ,0
                                      moveCursor    last_in_x_pos,last_in_y_pos

    en12:                             
                                      call          Send_Proc
                                      ret
display_received_char endp

check_if_ready_to_send proc
                                      mov           dx , 3FDH                            ; Line Status Register
                                      In            al , dx                              ;Read Line Status
                                      AND           al , 00100000b
                                      JNZ           send_char
                                      call          Receive_Proc

    send_char:                        
                                      mov           dx , 3F8H                            ; Transmit data register
                                      mov           al,out_char
                                      out           dx , al
            
                                      cmp           out_char,1bh
                                      jnz           end_check_if_ready_to_send
                                      call          return_to_main_mineu
        
    end_check_if_ready_to_send:       
                                      call          Receive_Proc
                                      ret
check_if_ready_to_send endp

check_if_ready_to_receive proc
                                      mov           dx , 3FDH                            ; Line Status Register
                                      in            al , dx
                                      AND           al , 1
                                      JNZ           receive_data
                                      call          Send_Proc

    receive_data:                     
    ; receive data
                                      mov           dx , 03F8H
                                      in            al , dx
                                      mov           in_char , al

                                      cmp           in_char,1bh
                                      jnz           end_check_if_ready_to_receive
                                      call          return_to_main_mineu

    end_check_if_ready_to_receive:    
                                      ret
check_if_ready_to_receive endp
    ;---------------

get_char_from_keyboard proc

                                      mov           ah,1
                                      int           16h
                                      jnz           get_the_char
                                      call          Receive_Proc

    get_the_char:                     
    ; if keyboard buffer has a char the mov it to in_char
                                      mov           ah,0
                                      int           16h
                                      mov           out_char,al

                                      ret
get_char_from_keyboard endp

exit_program proc
                                      call          clear_text_mode_screen
                                      mov           ah, 4ch
                                      int           21h
                                      ret
exit_program endp


return_to_main_mineu proc
    mov last_out_x_pos,0          
    mov last_out_y_pos,0           
    mov last_in_x_pos,0          
    mov last_in_y_pos,13           
    call select_game_mode
    ret
return_to_main_mineu endp

Receive_Proc proc

                                      call          check_if_ready_to_receive
                                      call          display_received_char

                                      ret
Receive_Proc endp

Send_Proc proc

                                      call          get_char_from_keyboard
                                      call          display_sent_char
                                      call          check_if_ready_to_send

                                      ret
Send_Proc endp

All_Chat_Proc proc

                                      push          AX
                                      push          BX
                                      push          CX
                                      push          DX

                                      call          clear_text_mode_screen
                                      call          draw_chat_line
                                      call          initialization

                                      call          Send_Proc



                                      pop           DX
                                      pop           CX
                                      pop           BX
                                      pop           AX

                                      ret
All_Chat_Proc endp

clear_text_mode_screen proc

                                      mov           ax,0600h
                                      mov           bh,07
                                      mov           cx,0
                                      mov           dx,184FH
                                      int           10h

                                      ret
clear_text_mode_screen endp


    ;--------------------------------------------------------------------------


    ;--------------- merge modes -----------------------

DisPlayString macro message
                                      mov           dx,offset message
                                      mov           ah,9
                                      int           21h
                                      endm          DisPlayString

set_text_mode proc far
    MOV AH, 00h     ; Function to set video mode
    MOV AL, 03h     ; Mode 3: 80x25 text mode, color
    INT 10h         ; Call BIOS video interrupt
    ret
set_text_mode endp
select_game_mode proc
                                      call set_text_mode
                                      call          clear_text_mode_screen
                                      moveCursor    0,0
                                      DisPlayString selecting_prombt_message
    wait_for_key_press_to_select_mode:
                                      mov           ah, 1                                ; DOS function 1: Check for key press
                                      int           16h                                  ; Call BIOS interrupt
                                      jz            wait_for_key_press_to_select_mode    ; If no key pressed, loop

                                      mov           ah, 0                                ; DOS function 0: Read key press
                                      int           16h                                  ; Call BIOS interrupt
                                      mov           selector,al
                                      cmp           al, '0'                              ; Check if 'd' is pressed
                                      je            call_two_or_one_players
                                      cmp           al, '1'                              ; Check if 'a' is pressed
                                      je            call_two_or_one_players
                                      cmp           al, '2'                              ; Check if 'a' is pressed
                                      je            All_Chat_Proc
                                      jmp           wait_for_key_press_to_select_mode


    call_two_or_one_players:          
                                    
                                      call          call_two_or_one_players_mode
    call_chat:                        
                                      call          All_Chat_Proc

    jmp_wait_again:                   
                                      jmp           wait_for_key_press                   ; If neither 'd' nor 'a' is pressed, loop

                                      ret
select_game_mode endp
    ;--------------------------------------------------

main proc far
                                      mov           ax, @data
    ; Initialize the data segment
                                      mov           ax,@data
                                      mov           dx,ax
                                      mov           ds,ax                                ; if you forget this color array will not work
                                      mov           es,ax                                ; if you forget this color array will not work
    ; call two_players_mode
    ; call All_Chat_Proc
                                      call          select_game_mode

    loop1:                            jmp           loop1
                                      mov           ah, 4Ch                              ; DOS function 4Ch: Terminate program
                                      int           21h                                  ; Call DOS interrupt
main endp
end main                ; End of the program