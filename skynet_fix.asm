; "Virus.DOS.SkyNet-512". Patch: PC-Beeper improper use.
; Either author or license are unknown, so I'll use UNLICENSE.
; Patch (c) Larry "Diicorp95" Holst, 2021.

; Flat Assembler syntax

    use16
    org 0x0100; COM file format generation
;---
new_line equ 0x0D; For SkyNet terminal simulator session
cr_lf equ 0x0D,0x0A; Microsoft uses the combination to set a new line, you know
color_attr equ 0x4E;< Color attribute $4E (yellow FG on dark red BG)
empty_char equ 0x20; ' '  |
video_data equ 0x4E20;<---|
beep_cycles equ 0x0100
;---
start:; "Start"
    push cs
    pop ds
    mov dx,copyright ; Print out copyright
    mov ah,0x09
    int 0x21
    mov al,0x10;< ???
    call v01E9; Get random data in AL,DL (the purpose is unknown)
    call v0118; All the visual things
v0011:; "Exit"
    mov ax,0x03
    int 0x10
    mov ah,0x4C
    int 0x21
;--- "String data"
    copyright db '*** Terminator I *** Created by Sky Net in Chung-Li.',cr_lf,'$'
    db 0x1F; string offset
    db 'Terminator Message:',new_line
    db 0x1F; string offset
    db new_line
    db 0x20; string offset
    db 'Don',0x27,'t be afraid.',new_line
    db 0x1D; string offset
    db 'I am a very kind virus.',new_line
    db 0x1A; string offset
    db 'You have do many works today.',new_line
    db 0x27; string offset
    db 'So,',0x0D
    db 0x17; string offset
    db 'I will let your computer slow down.',0x0D
    db 0x20; string offset
    db 'Have a nice day,',new_line
    db 24h; string offset
    db 'Goodbye.',new_line
    db 24h; string offset
    db new_line
    db 0x1A; string offset
    db 'Press a key to continue. . .'
    db 0x00; string offset
;---
v0118:; "Check video memory for color support, else use MDA"
    mov dx,0xB800; Video memory address we'll use (if EGA/VGA/PGA)
    int 0x11; Gets equipment list (result in AX)
    test ah,0x08; ZF is set, if computer has a EGA/VGA/PGA card
    jz v0125; do not use MDA, use CGA/EGA/VGA
    mov dx,0xB000; use MDA
v0125:; "Flash effect and animation"
    mov es,dx
    mov ax,0x00DB;< 0;full block character ($DB)
    mov cx,0x07D0;< ???;???
    xor di,di; Set X=Y = 0
    rep stosw; Loads in video memory
    mov al,0x0F;< Color attribute $0F (white FG on black BG)
    mov bx,0x07D1;< ???;???
    mov bp,bx; BX -> BP, to use with internal CPU engine calculations
    mov si,bp; Copy that value in SI.
    mov di,si; Copy that value in DI.
    mov cx,0x0002; ???
    mov dx,0x0002; ???
v0142:; "Flash effect parameters"
    push cx
    mov cx,0x0006;< How far flash effect with spread
;v0146:
@@:; "SkyNet terminal simulator session starts here..."
    call v01E9
    mov [es:bx],al
    mov [es:bp],al
    mov [es:si],al
    mov [es:di],al
    add bx,dx
    sub bp,dx
    add si,0x00A0
    sub di,0x00A0
    ;loop v0146
    loop @b; Operations with video memory
    xor al,al
    neg dx
    xchg si,di
    pop cx
    loop v0142
    call v01E9; Get random data in AL,DL (the purpose is unknown)
    mov ax,video_data
    mov cx,0x07D0
    xor di,di; Set X=Y = 0
    rep stosw; Operations with video memory
    xor bx,bx
    mov si,0x0151
    mov dh,0x07;Y = $07. It's an initial value simply.
v0181:; "Minor process #1 of printing out"
    mov ah,0x02;Set position with INT $10
    mov dl,[si];X = used string offset
    inc si
    int 0x10
    inc dh; Y++
v018A:; "Minor process #2 of printing out"
    push ax
    mov ah,0x01
    int 0x16; Wait for some key in background
    pop ax
    jz v019F
    push ax
    mov ah,0x00
    int 0x16; Wait for some key in foreground; at end of message
    cmp al,0x1B; '] }' key
    pop ax
    jnz v019F; Jump if ZF is clear
    jmp v0011; If ZF is set, jump to "Exit"
v019F:; "Rules of printing text out"
    mov al,[si]; Get character
    inc si; We'll use next character later, if we'll at all
    or al,al; If value is zero...
    jz v01C8
    cmp al,empty_char; If it's that empty character (in our case a space),
    je v01AE; slow down <SkyNet terminal simulator> typing speed.
    cmp al,new_line; If it's new line character for us,
    jne v01BC; then act like we should
v01AE:
    mov cx,0x0A;< For LOOP command
;v01B1:
@@:
    call v01E9; ???
    loop @b
    cmp al,0x0D; If it's also new line after another new line,
    jne v01BC; then ignore string offset because it's necessary
    jmp short v0181
v01BC:
    call v01D3
    call v01E9
    mov ah,0x0E
    int 0x10; "Teletype output"
    jmp short v018A
v01C8:
    xor ah,ah; AL = 0
    int 0x16; Wait for keypress in foreground
    cmp al,0x1B
    jne v01C8
    jmp v0011
v01D3:; "PC Speaker - <SkyNet terminal simulator> typing sound"
    push ax
    mov ah,0x00
    in al,0x61
    sub al,0xFC
;v01DA:
@@:
    xor al,0x02
    out 0x61,al
    mov cx,beep_cycles
v01E1:
    loop v01E1
    dec ah
    ;jnz v01DA
    jnz @b
    pop ax
    retn
v01E9:; "Get system time..."
    push ax
    push cx
    push dx
    mov ah,0x2C
    int 0x21
v01F0:; "...Finally getting random data from DL"
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
