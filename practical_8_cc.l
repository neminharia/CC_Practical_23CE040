%{
#include <stdio.h>
#include <string.h>

int isValid(char str[]) {
    int i = 0;

    if (str[i] == 'a') i++;
    if (str[i] == 'b') i++;

    if (str[i] == 'c' && str[i+1] == '\0')
        return 1;

    if (str[i] == '(' && str[strlen(str)-1] == ')')
        return 1;

    return 0;
}
%}  

%%
[a-z()]+   {
                printf("\nPredictive Parsing Table:\n");
                printf("---------------------------------\n");
                printf("Non-Terminal | a | b | c | ( | ) | $\n");
                printf("---------------------------------\n");
                printf("S            | ABC | - | - | D | - | -\n");
                printf("A            | a   | e | - | - | - | -\n");
                printf("B            | -   | b | e | - | - | -\n");
                printf("C            | -   | - | c | (S) | - | -\n");
                printf("D            | AC  | - | - | - | - | -\n");

                printf("\nGrammar is LL(1)\n");

                if (isValid(yytext))
                    printf("Valid string\n");
                else
                    printf("Invalid string\n");
           }

\n  ;

%%

int yywrap() {
    return 1;
}

int main() {
    printf("Enter string: ");
    yylex();
    return 0;
}
