segment .text
    global add_numbers
    global verifica_disponivel
    
verifica_disponivel:
    enter 0,0
    
    

    leave 
    ret
add_numbers:
    enter 0,0

    mov eax, [ebp + 8]
    add eax, [ebp + 12]

    leave
    ret