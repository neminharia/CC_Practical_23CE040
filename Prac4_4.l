%{
#include <stdio.h>

int lc = 0, uc = 0, d = 0, s = 0;
int len = 0;
%}

%%
[a-z]      { lc++; len++; }
[A-Z]      { uc++; len++; }
[0-9]      { d++;  len++; }
[*;#$@]    { s++;  len++; }
\n         {
              if (len >= 9 && len <= 15 && lc && uc && d && s)
                  printf("Valid password\n");
              else
                  printf("Invalid password\n");
              return 0;
           }
.          { len++; }
%%

int main() {
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}
