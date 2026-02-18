%{
#include <stdio.h>

int chars = 0;
int words = 0;
int lines = 0;
%}

%%
\n          { lines++; chars++; }
[ \t]+     { chars += yyleng; }
[^ \t\n]+  { words++; chars += yyleng; }
%%

int main() {
    FILE *fp = fopen("input.txt", "r");

    if (!fp) {
        printf("Unable to open input file\n");
        return 1;
    }

    yyin = fp;
    yylex();

    printf("Characters : %d\n", chars);
    printf("Words : %d\n", words);
    printf("Line : %d\n", lines);

    fclose(fp);
    return 0;
}

int yywrap() {
    return 1;
}
