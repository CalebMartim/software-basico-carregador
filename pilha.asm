section .text
    global add_numbers

add_numbers:
    push rdi
    push rsi
  
    mov eax, [rsp]  ; Get first argument (a)
    add eax, [rsp+8]  ; Get second argument (b)

    pop rdi
    pop rsi

    ret

