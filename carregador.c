#include "stdio.h"
#include "auxiliar.h"

typedef struct {
  int endereco, // Endereço de memória que inicia um bloco livre na memória
      quantidade; // Quantidade de unidades livres nesse bloco
} bloco;

int main(int argc, char* argv[]){

  // Tamanho do programa fíctico a ser carregado na memória:
  int tamanho_do_programa = stoi(argv[1]);

  // Quantidade de blocos utilizados:
  int quantidade_de_blocos = (argc - 2) / 2;

  bloco blocos[quantidade_de_blocos];

  for (int i = 2; i < argc; i += 2) {
    blocos[(i / 2) - 1].endereco = stoi(argv[i]);
    blocos[(i / 2) - 1].quantidade = stoi(argv[i + 1]);
  }

  // Verifica se há espaço suficiente nos blocos para guardar o programa:
  extern void verifica_total(int, int, bloco*);   
  verifica_total(tamanho_do_programa, quantidade_de_blocos, blocos);

  // Verifica se o programa cabe dentro de um bloco inteiro:
  extern void verifica_bloco_inteiro(int, int, bloco*);
  verifica_bloco_inteiro(tamanho_do_programa, quantidade_de_blocos, blocos);
  
  // Distribui o uso em cada bloco: 
  extern void distribui(int, int, bloco*);
  distribui(tamanho_do_programa, quantidade_de_blocos, blocos);
}
