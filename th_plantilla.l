%{
#include<string.h>
#include "y.tab.h"
%}



%%
					//ejemplo de uso de yylval para tokens a los que se
					//les ha cambiado su valor semantico en th.y
"("		{return(OP);}
")"		{return(CP);}
"->"	{return(FLECHA);}
","		{return(COMA);}
";"		{return(PC);}
"\n"	{return(EOL);}
[" "\t]
[0-3]{3}		{yylval.nombre=strdup(yytext);return(ID);} //sólo aceptamos nums del 0 al 3 pq el mas alto que puede salir es 3 en transiciones
%%

