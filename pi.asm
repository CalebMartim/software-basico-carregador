section .data
    endl db 0ah, 0 ; '\n\0'
    aux db '0' 
    szaux equ $ - aux

section .bss
    num resb 12 ; String que vai ser mostrada na tela

section .text
    global print_int

print_int:
    enter 0,0 
    push edi
    push ecx
    push ebx

    ; Começa conversão de int para string:
    mov edi, num + 11           ; Endereço do fim da string
    mov byte [edi], 0           ; Coloca o caractére '\0' no final  
    dec edi                     ; Decrementa por 1 o endereço
     
    mov eax, [ebp + 8]          ; Coloca o valor empilhado na pilha em eax
    mov ecx, 10                 ; Divisor
    mov ebx, 0                  ; Armazenará a quantidade de dígitos
.loop:
    mov edx, 0                  ; Limpa edx
    div ecx                     ; divide eax por 10 e edx terá o resto da divisão
    add dl, '0'                 ; Converte para ascii
    mov [edi], dl               ; Coloca no endereço atual de 'num' esse dígito
    dec edi                     ; Decrementa por 1 o endereço
    inc ebx                     ; Aumenta a quantidade de dígitos
    test eax, eax               ; Veja se o valor armazenado é 0
    jnz .loop                   ; Repete o processo se não for

    mov [aux], bl               ; Guarda em aux a quantidade de dígitos

    ; Coloca o número na saída padrão:
    mov ecx, num                ; Endereço inicial do número
    sub ecx, [aux]              ; Quantas vezes andou para trás 
    add ecx, 11                 ; Complemento (ecx agora estará no dígito inicial do número)
    mov edx, num + 11           ; Fim do número
    sub edx, ecx                ; Tamanho da string
    mov eax, 4                  
    mov ebx, 1                  
    int 0x80                    

    ; Quebra de linha:
    mov eax, 4
    mov ebx, 1
    mov ecx, endl
    mov edx, 1
    int 0x80  

    pop ebx 
    pop ecx
    pop edi
    leave

    ret