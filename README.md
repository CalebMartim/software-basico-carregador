# software-basico-carregador
Trabalho final da disciplina Software Básico: Um simulador de um carregador

Compila com:

```nasm -f elf32 pi.asm -o pi.o'''

```nasm -f elf32 funcoes.asm -o funcoes.o'''

```gcc -m32 funcoes.o pi.o carregador.c -o carregador'''

