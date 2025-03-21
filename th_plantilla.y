%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#define PALOS 3
#define DIM 27 //DIMENSION DE LA MATRIZ DE ADYACENCIA --> 27 nodos ==> matriz 27x27 para representar nodo y transiciones que llegan a este.
#define BUFF 4000

//declarar la variable listaTr de tipo ListaTransiciones
//Almacena las transiciones de un solo nodo (nodoOrig) 
//a varios nodos (nodosFin y sus correspondientes etiquetas)

//tabla de adyacencia
char* tablaTr[DIM][DIM];
int fila; //variable para guardar la fila por iteración
//inicializa una tabla cuadrada DIM x DIM con la cadena vacia
void iniTabla(char* tabla[DIM][DIM]) {
	for (int i = 0; i < DIM; i++) {
		for (int j = 0; j < DIM; j++) {
			tabla[i][j] = "";
		}
	}
}

/*
 * Calcula la multiplicacion simbolica de matrices 
 * cuadradas DIM x DIM: res = t1*t2
 *
 * CUIDADO: res DEBE SER UNA TABLA DISTINTA A t1 y t2
 * Por ejemplo, NO SE DEBE USAR en la forma:
 *           multiplicar(pot, t, pot); //mal
 */
void multiplicar(char* t1[DIM][DIM], char* t2[DIM][DIM], char* res[DIM][DIM]) {
	for (int i = 0; i < DIM; i++) {
		for (int j = 0; j < DIM; j++) {
			res[i][j] = (char*) calloc(BUFF, sizeof(char));
			for (int k = 0; k < DIM; k++) {
				if (strcmp(t1[i][k],"")!=0 && strcmp(t2[k][j],"") != 0) {
					strcat(strcat(res[i][j],t1[i][k]),"-");
					strcat(res[i][j],t2[k][j]);
				}
			}
		}
	}
}


/* 
 *Copia la tabla orig en la tabla copia
*/
void copiar(char* orig[DIM][DIM], char* copia[DIM][DIM]) {
	for (int i = 0; i < DIM; i++) {
		for (int j = 0; j < DIM; j++) {
			copia[i][j] = strdup(orig[i][j]);
		}
	}
}

//Pre: n >= 0
//Post: pasoDecimal(n) devuelve el número n en base 10
int pasoDecimal(int n){
    int res = 0;
    int i = 0;
    while (n > 0){
        res += (n % 10) * pow(3, i); //cogemos ultima cifra y calculamos su pot de 3 (tiene que ser < 3)
        n = n / 10;
        i++;
    }
    return res;
}
int yylex();
int yyerror(char* s) {
   printf("\n%s\n", s);
   return 0;
}

//Pre: las matrices camino y pot vienen inicializadas con loas valores recogidos del archivo thP3D3.txt
//Post: calcula movimientos de estadoIni a estadoFin usando las potencias sucesivas de tablaTr
int caminoMasCorto(int nodoI, int nodoF, char* copia[DIM][DIM], char* pot[DIM][DIM]){
	int movs = 0;
	while(strcmp(pot[nodoI][nodoF], "") == 0){ //mientras que no haya un caracter en la posición que nos interesa
            	multiplicar(tablaTr, copia, pot); //hacemos potencia enésima de la tabla (se guarda en 'pot')
            	copiar(pot, copia); //copiamos pot en copia para volver a multiplicar en la siguiente iteración (si hiciera falta)
		movs++; //incrementamos el número de moviimientos
        }
	return movs;
}
%}

  //nuevo tipo de dato para yylval
%union{
	char* nombre;
}

%token ID OP CP FLECHA COMA PC EOL //tokens gramática
%start	automata		//variable inicial 

%type<nombre> ID 	 //lista de tokens y variables que su valor semantico,
                     //recogido mediante yylval, es 'nombre' (ver union anterior).
					 //Para estos tokens, yylval será de tipo char* en lugar de int.

%%
automata: 	//nada 
		| automata ID FLECHA transiciones PC EOL {	fila = pasoDecimal(atoi($2));}
		;

transiciones: 	nodotrans COMA transiciones	
	    	| nodotrans					
		;
nodotrans: 	ID OP ID CP {	int col = pasoDecimal(atoi($1));
                        	tablaTr[fila][col] = $3;
				printf("fila %d, col %d, trans %s\n",fila, col, tablaTr[fila][col]);
                	    } 

%%

int main() {
	char* estadoIni = "000";//nodo inicial
	char* estadoFin = "222"; //nodo final

    	iniTabla(tablaTr); //inicializar tabla de adyacencia

    	int error = yyparse(); //paso el analizador por toda la entrada

    if (error == 0) { //una vez tengo la matriz cargada correctamente (error == 0), procedo a encontrar el camino más corto
        char* copia[DIM][DIM]; //matriz en la que guardamos una copia de la original
        char* pot[DIM][DIM]; //matriz para guardar la potencia
        int nodoI = pasoDecimal(atoi(estadoIni));    //guardamos el nodo inicial
        int nodoF = pasoDecimal(atoi(estadoFin));    //guardamos el nodo final
	copiar(tablaTr,copia);   //hacemos una copia del tablero en copia
        copiar(tablaTr,pot);     //hacemos una copia del tablero en pot
	int movimientos = caminoMasCorto(nodoI, nodoF, copia, pot);
		/*for(int t=0;t<27;t++){   //mostrar tabla (comprobación)
			for(int s=0;s<27;s++){
				printf("%s \n",tablaTr[t][s]);
			}
			printf("\n");
		}*/
        
 	printf("Nodo Inicial: %s\n", estadoIni);
        printf("Movimientos   : %s\n", pot[nodoI][nodoF]);
        printf("Nodo final    : %s\n", estadoFin);
    }

    return error;
}
