#include "stdio.h"
#include "auxiliar.h"

extern int add_numbers(int a, int b);

typedef struct {
  int endereco, // endereço de memória que inicia um bloco livre na memóri
      quantidade; // quantidades de unidades livres nesse bloco
} declaracao;


int main(int argc, char* argv[]){

  // tamanho de um programa fíctico a ser carregado na memória:
  int tamanho_do_programa = stoi(argv[1]);

  int quantidade_de_blocos = (argc - 2) / 2;

  declaracao blocos[quantidade_de_blocos];

  //int tamanho_livre_total = 0;

  for (int i = 2; i < argc; i += 2) {
    blocos[(i / 2) - 1].endereco = stoi(argv[i]);
    blocos[(i / 2) - 1].quantidade = stoi(argv[i + 1]);
  }

  // Vamos vendo 
  //if (tamanho_livre_total < tamanho_do_programa) {
  //  printf("Impossivel\n");
  //}

  extern int verifica_disponivel(int, declaracao* []); 

  int a = 1;
  int b = 2;
  int result = 3;

  // Verifica se o programa cabe dentro de um bloco inteiro
  for (int i = 0; i < quantidade_de_blocos; ++i) {
    if (blocos[i].quantidade >= tamanho_do_programa) {
      printf("Programa alocado no bloco %d entre os endereços %d e %d",
          i + 1, blocos[i].endereco, blocos[i].endereco + tamanho_do_programa - 1); 
    }
  }

  // Vamos colocando em cada bloco disponível
  for (int i = 0; i < quantidade_de_blocos && tamanho_do_programa > 0; ++i) {
    int a_retirar = min(tamanho_do_programa, blocos[i].quantidade);
    printf("Programa alocado no bloco %d entre os endereços %d e %d",
        i + 1, blocos[i].endereco, blocos[i].endereco + a_retirar - 1); 
    tamanho_do_programa -= a_retirar;
  } 
}
