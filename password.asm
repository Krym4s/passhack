.model tiny

.data
    GreetingPhrase db "Stop! Enter the password first! You can use a-z and 0-9$"
    EntryPhrase    db "Welcome to the club, buddy. *slap*$"
    FailurePhrase  db "Intruder detected! Your punisment$"

    passwordbuffer db 20 dup(0) 

    ;jmpTable    dw WrongJmp1 
    ;            dw WrongJmp6
    ;            dw WrongJmp5
    ;            dw WrongJmp3
    ;RightJump   dw offset StrangeJmp2
    ;            dw WrongJmp2
    ;            dw WrongJmp4 




.code

org 100h

enterASCII = 0dh
maxBufferLen = 20

start: 
    mov di, 1fh
    mov dx, offset GreetingPhrase
    call PrintLine
    call EnterHandler

    jmp Exit
    
;--------------------------------------
;Print phrase which is at dx address
;
;Entry: dx
;
;Destr: ah
;-------------------------------------

PrintLine proc
    mov ah, 09h
    int 21h

    ret
PrintLine endp

EnterHandler proc

    lea bx, passwordbuffer

    xor cx, cx
    xor dx, dx
    mov dx, 'J'
    ;mov dx, offset passwordbuffer

    HandleCycle:
        ;mov cx, 1
        ;mov bx, 0
        mov ah, 1h      ;keyboard input
        ;mov bx, 0h
        
        int 21h

        ;xor bx, bx
        ;mov al, [dx]
        cmp al, enterASCII
        je StrangeJmp1

        mov [bx], al
		inc bx
        ;inc dx

        inc cx

        jmp HandleCycle

    PasswordCompare:
        xor ax, ax 
        mov al, [bx] 
        inc bx
        cmp ax, dx
        ret

Failure proc
    mov dx, offset FailurePhrase
    call PrintLine
    jmp Exit
Failure endp



EnterHandler endp

;very strange jumps

StrangeJmp2:
    mov dx, '2'
    jmp next1
    next1:
    mov dx, 'o'
    call PasswordCompare
    je StrangeJmp3
    call Failure

StrangeJmp1:
    xor dx,dx
    mov bx, offset passwordbuffer
    mov dx, '3'
    jmp next10
    next10:
    mov dx, 'J'
    
    call PasswordCompare
    je StrangeJmp2
    call Failure


StrangeJmp4:
    mov dx, 'b'
    jmp next2
    next2:
    mov dx, 'a'
    call PasswordCompare
    je StrangeJmp5
    call Failure

StrangeJmp3:
    mov dx, 'z'
    jmp next3
    next3:
    mov dx, 'y'
    jmp next4
    next4:
    mov dx, 't'
    call PasswordCompare
    je StrangeJmp4
    call Failure

StrangeJmp5:
    mov dx, 'r'
    call PasswordCompare
    je StrangeJmp6
    call Failure

StrangeJmp6:
    push dx    ; rubbish
    pop dx
    mov dx, 'o'
    call PasswordCompare
    je FinalJmp
    call Failure

FinalJmp:
    mov dx, offset EntryPhrase
    call PrintLine
    jmp Exit


PrintBadPhrase proc
    mov dx, offset FailurePhrase
    call PrintLine
    jmp  Exit
PrintBadPhrase endp


Exit:
    mov ax, 4c00h
	int 21h	


end start

    
