segment .text
    global verifica_total
    global verifica_bloco_inteiro
    global distribui
    extern print_int    

; Quando uma função é chamada temos:
; [ebp + 8] é o tamanho do programa
; [ebp + 12] é a quantidade de blocos 
; [ebp + 16] é o endereço na memória de verdade para o início da lista de descrições dos blocos 
; [[ebp + 16]] é o endereço simulado que queremos alocar para o primeiro bloco
; [[ebp + 16] + 4] é o tamanho que queremos alocar para o primeiro bloco
; [[ebp + 16] + 8] é o endereço que queremos alocar para o segundo bloco   
; [[ebp + 16] + 12] é o tamanho que queremos alocar para o segundo bloco   
; e assim por diante

; Mostrando um inteiro na tela:
; push ebx  ; número que queremos printar na tela
; call print_int ; chama a função
; add esp, 4 ; tira da stack

verifica_total:
    enter 0,0
    
    ; Salva os valores anteriores desses registradores:
    push edx
    push ebx 

    ; Vamos fazer um loop de [ebp + 12] iterações:
    mov edx, [ebp + 12] ; coloca em edx a quantidade de blocos
    mov eax, 0 ; nosso acumulador
    mov ebx, [ebp + 16] ; endereço para o início da lista de descrições 
    add ebx, 4 ; endereço que aponta para o tamanho do primeiro bloco 

.soma:
    add eax, [ebx] ; soma em eax o tamanho deste bloco   
    add ebx, 8 ; vai para o tamanho do próximo bloco
    dec edx ; abaixa o edx
    test edx, edx 
    jnz .soma

    cmp eax, [ebp + 8] ; calcula a diferença entre o espaço total disponível e o espaço que queremos utilizar 
    jns cabe; se a diferença não é negativa, cabe

    ; A diferença é negativa, então não cabe:
    
    mov eax, 4
    mov ebx, 1
    mov ecx, insuficiente
    mov edx, szinsuficiente
    int 80h

    mov eax, 1
    mov ebx, 0
    int 80h
    
cabe:
    ; Recupera os valores desses registradores:
    pop ebx
    pop edx
    leave 
    ret

verifica_bloco_inteiro:
    enter 0,0

    push edx
    push ecx
    push ebx

    ; Vamos fazer um loop de [ebp + 12] iterações:
    mov edx, [ebp + 12] ; coloca em edx a quantidade de blocos
    mov ecx, 1 ; contador de bloco
    mov ebx, [ebp + 16] ; endereço para o início da lista de descrições 
    add ebx, 4 ; endereço que aponta para o tamanho do primeiro bloco 

.verifica:

    mov eax, [ebx] ; tamanho desse bloco
    cmp eax, [ebp + 8] ; tamanho que eu quero

    jl .continua ; o programa quer mais espaço do que disponível nesse bloco

    ; O programa cabe nesse bloco:

    ; Mensagem de aloca, salvando ecx (bloco atual) e ebx (endereço que contém o tamanho):
    push ecx
    push ebx
    mov eax, 4
    mov ebx, 1
    mov ecx, aloca
    mov edx, szaloca
    int 80h
    pop ebx
    pop ecx

    ; Mostra na tela o tamanho utilizado:
    push dword [ebp + 8] ; tamanho utilizado é o tamanho inteiro desejado
    call print_int 
    add esp, 4 

    ; Mensagem de unidades e em qual bloco:
    push ecx
    push ebx
    mov eax, 4
    mov ebx, 1
    mov ecx, unidades
    mov edx, szunidades
    int 80h
    pop ebx
    pop ecx

    ; Mostra o bloco utilizado
    push ecx
    call print_int
    add esp, 4

    ; Não precisa mais salvar o ecx (mostra mensagem do endereço inicial):
    push ebx
    mov eax, 4
    mov ebx, 1
    mov ecx, do_endereco
    mov edx, szdo_endereco
    int 80h
    pop ebx;

    ; eax irá guardar endereço do endereço inicial: 
    mov eax, ebx 
    sub eax, 4 
    
    push dword [eax] ; endereço em si
    call print_int
    add esp, 4 

    ; Mensagem do endereço final:
    push eax
    mov eax, 4
    mov ebx, 1
    mov ecx, ao_endereco
    mov edx, szao_endereco
    int 80h
    pop eax

    mov eax, dword [eax] ; Guarda em eax o próprio valor do endereço inicial
    add eax, [ebp + 8] ; Soma pelo valor que eu estou utilizando
    sub eax, 1 ; Se torna o endereço final 
    
    ; Mostra este valor na tela
    push eax 
    call print_int 
    add esp, 4 
     
    ; Quebra de linha:
    mov eax, 4
    mov ebx, 1
    mov ecx, endl
    mov edx, szendl
    int 80h
    ; Como foi encontrado espaço, pode terminar o programa:
    mov eax, 1
    mov ebx, 0
    int 80h

    .continua:
    add ebx, 8
    inc ecx
    dec edx 
    test edx, edx
    jnz .verifica

    pop ebx
    pop ecx
    pop edx
    leave
    ret

distribui:
    enter 0,0
    push edx
    push ebx
    push eax
    push esi
    mov eax, [ebp + 8] ; Tamanho do programa
    mov edx, [ebp + 12] ; coloca em edx a quantidade de blocos
    mov ebx, [ebp + 16] ; endereço para o início da lista de descrições 
    mov esi, 1 ; bloco atual 
    add ebx, 4 ; endereço que aponta para o tamanho do primeiro bloco 

.insere:
    mov ecx, eax ; ecx terá o o tamanho que vamos tirar deste bloco 
    cmp [ebx], ecx ; Vê se o tamanho disponível nesse bloco é menor
    jns .pula; [ebx] >= ecx   
    ; Tem menos tamanho disponível neste bloco do que o desejado:
    mov ecx, [ebx] 
    .pula:
    ; eax tem o tamanho do programa
    ; ebx tem o endereço que aponta para o tamanho
    ; ecx tem o valor que eu quero retirar
    ; edx tem o valor que número restante de blocos

    push edx
    push ecx
    push ebx
    push eax
    mov eax, 4
    mov ebx, 1
    mov ecx, aloca
    mov edx, szaloca
    int 80h
    pop eax 
    pop ebx
    pop ecx
    pop edx

    push ecx ; quanto de memória vai colocar nesse bloco
    call print_int 
    add esp, 4

    ; mensagem de unidades e bloco:;
    push edx
    push ecx
    push ebx
    push eax
    mov eax, 4
    mov ebx, 1
    mov ecx, unidades
    mov edx, szunidades
    int 80h
    pop eax 
    pop ebx
    pop ecx
    pop edx

    ; Qual bloco ele está retirando:
    push esi
    call print_int
    add esp, 4

    ; Mensagem de endereço: 
    push edx
    push ecx
    push ebx
    push eax
    mov eax, 4
    mov ebx, 1
    mov ecx, do_endereco
    mov edx, szdo_endereco
    int 80h
    pop eax 
    pop ebx
    pop ecx
    pop edx

    mov edi, ebx; edi terá o endereço inicial
    sub edi, 4; endereço inicial

    push dword [edi] ; valor em si do endereço fictício
    call print_int
    add esp, 4

    push edx
    push ecx
    push ebx
    push eax
    mov eax, 4
    mov ebx, 1
    mov ecx, ao_endereco
    mov edx, szao_endereco
    int 80h
    pop eax 
    pop ebx
    pop ecx
    pop edx

    mov edi, dword [edi]
    add edi, ecx ; tamanho utilizado
    sub edi, 1 ; endereço final

    ; Coloca o valor do endereço final na tela:
    push edi 
    call print_int
    add esp, 4

    ; quebra de linha
    push edx
    push ecx
    push ebx
    push eax
    mov eax, 4
    mov ebx, 1
    mov ecx, endl
    mov edx, szendl
    int 80h
    pop eax 
    pop ebx
    pop ecx
    pop edx

    sub eax, ecx; tira de eax o valor utilizado
    
    ; Vê se já não deu zero
    test eax, eax 
    jz .quebra

    add ebx, 8
    inc esi
    dec edx
    test edx, edx
    jnz .insere

.quebra:
    pop esi
    pop eax
    pop ebx
    pop edx
    leave
    ret

section .data
    insuficiente db "Não há espaço suficiente nos blocos!", 0dh, 0ah, 0
    szinsuficiente equ $ - insuficiente
    aloca db "Alocado ", 0
    szaloca equ $ - aloca
    unidades db "unidades de memoria no bloco "
    szunidades equ $ - unidades
    do_endereco db "do endereco "
    szdo_endereco equ $ - do_endereco
    ao_endereco db "ao endereco "
    szao_endereco equ $ - ao_endereco
    endl db 0dh, 0ah, 0
    szendl equ $ - endl
    debug db "debug", 0dh, 0ah, 0
    szdebug equ $ - debug
