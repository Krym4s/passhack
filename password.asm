.model tiny

.data
    GreetingPhrase db "Stop! Enter the password first! You can use a-z and 0-9$"
    EntryPhrase    db "Welcome to the club, buddy. *slap*$"
    FailurePhrase  db "Intruder detected! Your punisment$"

    ;jmpTable    dw WrongJmp1 
    ;            dw WrongJmp6
    ;            dw WrongJmp5
    ;            dw WrongJmp3
    ;RightJump   dw offset StrangeJmp2
    ;            dw WrongJmp2
    ;            dw WrongJmp4 

    passwordbuffer db 20 dup(0) 





.code

org 100h

enterASCII = 0dh
maxBufferLen = 20

start: 
    mov di, 1fh ; useless
    mov dx, offset GreetingPhrase
    call PrintLine
    mov dx, offset EntryPhrase

    call EnterHandler
    call StrangeJmp1
    call PrintLine
    jmp Exit

    
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
    xor di, di
    mov di, 'J'
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
        je funcExit

        mov [bx], al
		inc bx
        ;inc dx

        inc cx

        jmp HandleCycle

        funcExit:
        ret

EnterHandler endp        

PasswordCompare:
    xor ax, ax 
    mov al, [bx] 
    inc bx
    cmp ax, di
    ret

Failure proc
    mov dx, offset FailurePhrase
    ;call PrintLine
    ret
    ;jmp Exit
Failure endp





;very strange jumps

StrangeJmp2:
    mov di, '2'
    jmp next1
    next1:
    mov di, 'o'
    call PasswordCompare
    je StrangeJmp3
    jmp Failure

StrangeJmp1:
    xor di,di
    mov bx, offset passwordbuffer
    mov di, '3'
    jmp next10
    next10:
    mov di, 'J'
    
    call PasswordCompare
    je StrangeJmp2
    jmp Failure


StrangeJmp4:
    mov di, 'b'
    jmp next2
    next2:
    mov di, 'a'
    call PasswordCompare
    je StrangeJmp5
    jmp Failure

StrangeJmp3:
    mov di, 'z'
    jmp next3
    next3:
    mov di, 'y'
    jmp next4
    next4:
    mov di, 't'
    call PasswordCompare
    je StrangeJmp4
    jmp Failure

StrangeJmp5:
    mov di, 'r'
    call PasswordCompare
    je StrangeJmp6
    call Failure

StrangeJmp6:
    push di    ; rubbish
    pop di
    mov di, 'o'
    call PasswordCompare
    je FinalJmp
    jmp Failure

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

    
