%{
#include "y.tab.h"
#include <stdlib.h>
%}

%%
[0-9]+(\.[0-9]+)?    { yylval.val = atof(yytext); return NUMBER; }
[ \t]                ;
\n                   return '\n';
.                    return yytext[0];
%%

int yywrap() {
    return 1;
}