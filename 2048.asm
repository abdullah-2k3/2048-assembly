[org 0x0100]
	jmp main
	
	
clrscr:		
	push es 
	push ax 
	push di 
	mov ax, 0xb800
	mov es, ax 
	mov di, 0 


nextloc:	
	mov word [es:di], 0x0720 ; clear next char on screen 
	add di, 2 ; move to next screen location 
	cmp di, 4000 ; has the whole screen cleared 
	jne nextloc ; if no clear next position 

	pop di 
	pop ax 
	pop es 
	
	ret
	
delay:
	push cx
	mov cx, 0xffff
d:	nop
	loop d
	pop cx
	ret
	
show_char:
	mov al, '*'
	mov [es:di], ax
	ret
	
intro:
	mov ax, 0xb800
	mov es, ax
	mov di, 986
	mov ah, 0x33
	mov al, '.'
l1:	call delay
	mov [es:di], ax
	add di, 2
	cmp di, 1006
	jl l1
	sub di, 2
l2:	call delay
	add di, 160
	mov [es:di], ax
	cmp di, 1486
	jl l2	
	
l3:	call delay
	sub di, 2
	mov [es:di], ax
	cmp di, 1626
	jg l3
	
l4:	call delay
	add di, 160
	mov [es:di], ax
	cmp di, 2106
	jl l4
	add di, 160
l5:	call delay
	mov [es:di], ax
	add di, 2
	cmp di, 2286
	jl l5
	
	mov ah, 0x44
	mov di, 1016
l01:call delay
	mov [es:di], ax
	add di, 2
	cmp di, 1036
	jl l01
	sub di, 2
l02:call delay
	add di, 160
	mov [es:di], ax
	cmp di, 1996
	jl l02
	add di, 160
l03:call delay
	mov [es:di], ax
	sub di, 2  
	cmp di, 2296
	jg l03
l04:call delay
	mov [es:di], ax
	sub di, 160
	cmp di, 1016
	jg l04
	
	mov ah, 0x22
	mov di, 1046
l41:call delay
	mov [es:di], ax
	add di, 160
	cmp di, 1686
	jl l41
l42:call delay
	mov [es:di], ax
	add di, 2
	cmp di, 1706
	jl l42
	mov di, 1064
l43:call delay 
	mov [es:di], ax
	add di, 160
	cmp di, 2346
	jl l43
	
	mov ah, 0x11
	mov di, 1076 
l81:call delay
	stosw
	cmp di, 1096
	jl l81
	sub di, 2
l82:call delay
	add di, 160
	mov [es:di], ax
	cmp di, 2356
	jl l82

l83:call delay
	mov [es:di], ax
	sub di, 2  
	cmp di, 2356
	jg l83
l84:call delay
	mov [es:di], ax
	sub di, 160
	cmp di, 1086
	jg l84
	mov di, 1718
l85:call delay
	mov [es:di], ax
	add di, 2
	cmp di, 1736
	jl l85

	mov di, 3410
	mov ah, 0x0a
	mov bx, 0

ls1:	mov al, [str1+bx]
	mov [es:di], ax
	add di, 2
	inc bx
	cmp bx, 30
	jl ls1
	mov bx, 0
	add di, 310
	mov ah, 0x0e
ls2:mov al, [str2+bx]
	mov [es:di], ax
	add di, 2
	inc bx
	cmp bx, 25
	jl ls2	

	ret 


printnum: push bp 
	 mov bp, sp 
	 push es 
	 push ax 
	 push bx 
	 push cx 
	 push dx 
	 push di 
	 push si
	 mov si, 0
	 mov ax, 0xb800 
	 mov es, ax ; point es to video base 
	 mov ax, [bp+4] ; load number in ax 
	 cmp ax, 0
	 je _pexit
	 cmp ax, 2
	 je .two
	 cmp ax, 4
	 je .four
	 cmp ax, 8
	 je .eight
	 cmp ax, 16
	 je .sixteen
	 cmp ax, 32
	 je .thirtytwo
	 cmp ax, 64
	 je .sixtyfour
	 cmp ax, 128
	 je .l128
.two:
	mov si, 0
	jmp .done	
.four:
	mov si, 1
	jmp .done
.eight:
	mov si, 2
	jmp .done
.sixteen:
	mov si, 3
	jmp .done
.thirtytwo
	mov si, 4
	jmp .done
.sixtyfour:
	mov si, 5
	jmp .done
.l128:
	mov si, 6
	jmp .done


.done
	 mov cx, 0 ; initialize count of digits 
nextdigit:
	 mov bx, 10
	 mov dx, 0 ; zero upper half of dividend 
	 div bx ; divide by 10 
	 add dl, 0x30 ; convert digit into ascii value 
	 push dx ; save ascii value on stack 
	 inc cx ; increment count of values 
	 cmp ax, 0 ; is the quotient zero 
	 jnz nextdigit ; if no divide it again 
	 mov di,  [bp+6]; 
nextpos:
	 pop dx ; remove a digit from the stack 
	 mov dh, [colors+si] ; use normal attribute 
	 mov [es:di], dx ; print char on screen 
	 add di, 2 ; move to next screen location 
	 ;inc si
	 loop nextpos ; repeat for all digits on stack
_pexit:
	 pop si
	 pop di 
	 pop dx 
	 pop cx 
	 pop bx 
	 pop ax 
	 pop es 
	 pop bp 
	 ret 

sound:
	push bp
	mov bp, sp
	push ax

	mov al, 182
	out 0x43, al
	mov ax, [bp + 4]   ; frequency
	out 0x42, al
	mov al, ah
	out 0x42, al
	in al, 0x61
	or al, 0x03
	out 0x61, al
call delay
call delay
call delay
call delay
call delay
call delay
	in al, 0x61

	and al, 0xFC
	out 0x61, al

	pop ax
	pop bp
    ret 2



print_grid:
	push ax
	push bx
	mov ax, 0xb800
	mov es, ax
	mov bx, 842
	mov di, bx
	mov ah, 0x77
	
	add bx, 64
horizontal:
	call show_char
	add di, 2
	cmp di, bx
	jl horizontal
	add di, 576
	add bx, 640
	cmp bx, 3560
	jl horizontal
	
	mov bx, 842
	mov di, bx	
	add bx, 80
vertical:
	call show_char
	add di, 16 
	cmp di, bx
	jl vertical
	add di, 80
	add bx, 160
	cmp bx, 3546
	jl vertical
	
	pop bx
	pop ax
	ret


print_box:
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push di
	
	mov ax, 0xb800
	mov es, ax	
	mov di, [bp+4]
	mov ah, [board_colors]
	mov al, '.'
	
	mov bx, 0
_h:	mov cx, 8
	rep stosw
	add di, 144
	inc bx
	cmp bx, 3
	jl _h
	
	pop di
	pop cx
	pop bx
	pop ax
	pop bp
	ret



print_score:
	pusha
	
	mov ax, 0xb800
	mov es, ax
	mov ah, 0x02
	mov bx, 0
	mov di, 524
	mov cx, 7
.l:
	mov al, [score_word+bx]
	stosw
	inc bx
	loop .l
	
	push di
	mov ax, [score]
	push ax
	call printnum
	add sp, 4
	
	popa
	ret
	
print_moves:
	pusha
	
	mov ax, 0xb800
	mov es, ax
	mov ah, 0x02
	mov bx, 0
	mov di, 560
	mov cx, 7
.l:
	mov al, [moves_word+bx]
	stosw
	inc bx
	loop .l
	
	push di
	mov ax, [moves]
	push ax
	call printnum
	add sp, 4
	
	popa
	ret

; Def function
print_board:
	push bx
	push cx
	push si
	
	mov bx, 1004
	
	mov si, 0
_m:	
	mov cx, 4
h_boxes:
	push bx
	call print_box
	pop bx
	add bx, 16
	loop h_boxes
	add bx, 576
	inc si
	cmp si, 4
	jl _m
	call print_grid
	pop si
	pop cx
	pop bx
	ret

play:
	push bx
    push ax
	push dx
check_input:
	mov bx, 0
	xor ax, ax
	mov ah, 0
    int 0x16
    cmp ah, 0x48                ; Up key
    je _up
    cmp ah, 0x4b                ; Left key
    je _left
    cmp ah, 0x4d                ; Right key
    je near  _right
    cmp ah, 0x50                ; Down key
    je _down

    cmp ah, 0x1                 ; Esc key
    jne check_input
    jmp exit
	

;Code for movements	
_up:
	push cx
	push ax
	
	mov ax, 0
C1:	mov cx, 12	
	push bx
c1:
	push bx
	add bx, 8
	push bx
	call move_up
	pop bx
	pop bx
	add bx, 2
	loop c1
	pop bx
	inc ax
	cmp ax, 3
	jl C1
	pop ax
	pop cx
	jmp done
_down:
	push cx
	push ax
	mov bx, 30
	mov ax, 0
	
C2:	mov cx, 12
	push bx
c2:
	push bx
	sub bx, 8
	push bx
	call move_down
	add sp, 2
	pop bx
	sub bx, 2
	loop c2
	pop bx
	inc ax
	cmp ax, 3
	jl C2
	pop ax
	pop cx
	jmp done
	
_left:
	push cx
	push ax
	mov ax, 0
	
C3:	mov cx, 4
	push bx
c3:
	push bx
	add bx, 2
	push bx
	call move_left
	pop bx
	pop bx
	add bx, 8
	loop c3	
	pop bx
	inc ax
	cmp ax, 3
	jl C3
	pop ax
	pop cx
	jmp done

_right: 
	push cx
	push ax
	mov ax, 0
	mov bx, 30
	
C4:	mov cx, 4
	push bx
c4:
	push bx
	sub bx, 2
	push bx
	call move_right
	add sp, 2
	pop bx
	sub bx, 8
	loop c4
	pop bx
	inc ax
	cmp ax, 3
	jl C4
	pop ax
	pop cx
done:
	add word [moves], 1
	call generate_new_num
	call print_score
	call print_moves
	call print_board
	call print_board_values
	push 2000
	call sound
	pop dx
	pop ax
	pop bx
	ret


GenRandNum:
	push bp
	mov bp,sp;
	push cx
	push ax
	push dx;

	MOV AH, 00h ; interrupts to get system time
	INT 1AH ; CX:DX now hold number of clock ticks since midnight
	mov ax, dx
	xor dx, dx
	mov cx, 28;
	div cx ; here dx contains the remainder of the division - from 0 to 9

	mov word bx,dx;

	pop dx;
	pop ax;
	pop cx;
	pop bp;
	ret


generate_new_num:
	push bp
	mov bp,sp
	push bx
	push cx
	push ax
	push dx
	
	call GenRandNum
	mov ax, bx
	shr ax, 1
	jnc find_0
	inc bx
find_0:	
	mov ax, [board+bx]
	cmp ax, 0
	je new_num
	add bx, 2
	cmp bx, 32
	jl find_0
new_num:
	mov word [board+bx], 2
	
	pop dx
	pop ax
	pop cx
	pop bx
	pop bp
	ret

move_left:
	push bp
	mov bp, sp
	push ax
	push cx
	push bx

	mov bx, [bp+6]
	mov si, [bp+4]
	mov cx, 3
l_left:
	mov ax,[board+bx]
	cmp ax, 0
	je fill_right
	cmp ax, [board+si]
	jne skip_left_add
	shl ax, 1
	mov [board+si], ax
	add word [score], ax
	mov ax, 0
	mov [board+bx], ax 
fill_right:
	mov ax, [board+si]
	mov [board+bx], ax
	mov ax, 0
	mov [board+si], ax
skip_left_add:
	add bx, 2
	add si, 2
	loop l_left
	
	pop bx
	pop cx
	pop ax
	pop bp
	ret
	
move_right:
	push bp
	mov bp, sp
	push ax
	push cx
	push bx
	push dx

	mov bx, [bp+6]
	mov si, [bp+4]
	mov cx, 3
.l_left:
	mov ax,[board+bx]
	cmp ax, 0
	je .fill_right
	cmp ax, [board+si]
	jne .skip_add
	shl ax, 1
	mov [board+si], ax
	add word [score], ax
	mov ax, 0
	mov [board+bx], ax 
.fill_right:
	mov ax, [board+si]
	mov [board+bx], ax
	mov ax, 0
	mov [board+si], ax
.skip_add:
	sub bx, 2
	sub si, 2
	loop .l_left
	
	pop dx
	pop bx
	pop cx
	pop ax
	pop bp
	ret


move_up:
	push bp
	mov bp, sp
	push bx
	push ax

	mov bx, [bp+6]
	mov si, [bp+4]
l_up:
	mov ax, [board+bx]
	cmp ax, 0
	je fill_down
	cmp ax, [board+si]
	jne  skip_add
	shl ax, 1
	mov [board+bx], ax
	add word [score], ax
	mov ax, 0
	mov [board+si], ax	
	jmp skip_add
fill_down:
	mov ax, [board+si]
	mov [board+bx], ax
	mov ax, 0
	mov [board+si], ax	
	add bx, 8
	add si, 8
	cmp bx, 24
	jl l_up
skip_add:

	pop ax
	pop bx
	pop bp
	ret
	
	
move_down:
	push bp
	mov bp, sp
	push bx
	push ax

	mov bx, [bp+6]
	mov si, [bp+4]
.l_up:
	mov ax, [board+bx]
	cmp ax, 0
	je .fill_down
	cmp ax, [board+si]
	jne  .skip_add
	shl ax, 1
	mov [board+bx], ax
	add word [score], ax
	mov ax, 0
	mov [board+si], ax	
	jmp .skip_add
.fill_down:
	mov ax, [board+si]
	mov [board+bx], ax
	mov ax, 0
	mov [board+si], ax	
	sub bx, 8
	sub si, 8
	cmp bx, 8
	jg .l_up
.skip_add:

	pop ax
	pop bx
	pop bp
	ret
	


;end of movements

print_board_values:
	push bx
	push dx
	push di
    push cx
	push ax
	mov bx, 0
	
	mov ax, 0
	mov di, 1168
_matrix:
	mov cx, 4
_row:
	push di
	mov dx, [board+bx]
	add bx, 2
	cmp dx, 0
	je skip_0
	
non_zero:
	push dx	
	call printnum
	pop dx
skip_0:
	pop di
	add di, 16
	loop _row
	add di, 576
	inc ax
	cmp ax, 4
	jl _matrix
	
	pop ax
	pop cx
	pop di
	pop dx
	pop bx
	ret


endscreen:
	pusha	
	mov ax, 0xb800
	mov es, ax
	mov al, ' '
	mov ah, 0x22

	mov di, 1142
	
	mov cx, 7	
.l1:	
	mov [es:di], ax
	add di, 160
	call delay
	loop .l1
	
	mov di, 1134
	mov cx, 9
.l2:	
	mov [es:di], ax
	add di, 2
	call delay
	loop .l2
	
	mov di, 1156
	mov cx, 7
	mov ah, 0x33
.l3: 
	mov [es:di], ax
	add di, 160
	call delay
	loop .l3
	
	mov di, 1170
	mov cx, 7
.l4:
	mov [es:di], ax
	add di, 160
	call delay
	loop .l4
	
	
	mov di, 1636
	mov cx, 7
.l5:
	mov [es:di], ax
	add di, 2
	call delay
	loop .l5
	
	mov di, 1190
	mov cx, 7
	mov ah, 0x44
.l6:
	mov [es:di], ax
	sub di, 2
	call delay
	loop .l6
	
	mov cx, 6
.l7:
	mov [es:di], ax
	add di, 160
	call delay
	loop .l7
	
	mov cx, 8	
.l8:
	mov [es:di], ax
	add di, 2
	call delay
	loop .l8
	
	mov di, 1656
	mov cx, 8
.l9:
	mov [es:di], ax
	add di, 2
	call delay
	loop .l9
	
	
mov di, 1218
	mov cx, 7
	mov ah, 0x66
.l10:
	mov [es:di], ax
	sub di, 2
	call delay
	loop .l10
	
	mov cx, 6
.l11:
	mov [es:di], ax
	add di, 160
	call delay
	loop .l11
	
	mov cx, 8	
.l12:
	mov [es:di], ax
	add di, 2
	call delay
	loop .l12
	
	mov di, 1684
	mov cx, 8
.l13:
	mov [es:di], ax
	add di, 2
	call delay
	loop .l13
	
	
	mov di, 2184
	mov ah, 0x22
	mov cx, 7	
.l14:	
	mov [es:di], ax
	sub di, 160
	call delay
	loop .l14
	
	mov cx, 7
.l15:	
	add di, 162
	mov [es:di], ax
	call delay
	loop .l15
	
	add di, 2
	mov cx, 7	
.l16:	
	mov [es:di], ax
	sub di, 160
	call delay
	loop .l16
	
	add di, 166
	mov ah, 0x11
	mov cx, 7	
.l17:	
	mov [es:di], ax
	add di, 160
	call delay
	loop .l17
	
	mov di, 1248
	mov cx, 7
.l18:
	mov [es:di], ax
	add di, 2
	call delay
	loop .l18
	
	mov cx, 7	
.l19:	
	mov [es:di], ax
	add di, 160
	call delay
	loop .l19
	
	sub di, 160
	mov cx, 8	
.l20:	
	mov [es:di], ax
	sub di, 2
	call delay
	loop .l20
	
	
	mov di, 2570
	mov cx, 70
	mov ah, 0x77
.l21:	
	mov [es:di], ax
	add di, 2
	call delay
	loop .l21	
	
	popa
	ret



main:
	call clrscr
	call intro
	mov ah, 0
	int 0x16
	call clrscr	
	call print_score
	call print_moves
	call print_board
	call print_board_values

main_loop:
	call play
	mov ax, [board]
	cmp word ax, 2048
	jne main_loop
	
	
exit:
	call clrscr
	call endscreen
	mov ax, 0x4c00
	int 0x21

score: dw 0

moves: dw 0

str1: db 'Developed By: Abdullah Maqsood'
str2: db 'Press any key to continue'

score_word: db 'Score: '

moves_word: db 'Moves: '

board_colors:  db 0x11

colors: db 0x17, 0x12, 0x14, 0x1a, 0x1d, 0x1c, 0x1e


board:	   
	dw 0, 0, 0, 0,
	dw 2, 0, 0, 0,
	dw 0, 0, 0, 0,
	dw 0, 0, 0, 0
