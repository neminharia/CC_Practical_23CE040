%{
#include <stdio.h>
%}

%%
[Cc][Hh][Aa][Rr][Uu][Ss][Aa][Tt]   { printf("university"); }
\n                                { return 0; }
.                                 { printf("%s", yytext); }
%%

int main() {
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}
