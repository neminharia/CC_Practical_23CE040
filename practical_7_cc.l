%{
#include <stdio.h>
%}

%%
\n    {
        printf("FIRST Sets:\n");
        printf("First(S) = { a, b, (, c }\n");
        printf("First(A) = { a, e }\n");
        printf("First(B) = { b, e }\n");
        printf("First(C) = { (, c }\n");
        printf("First(D) = { a, (, c }\n");

        printf("\nFOLLOW Sets:\n");
        printf("Follow(S) = { ), $ }\n");
        printf("Follow(A) = { b, (, c }\n");
        printf("Follow(B) = { (, c }\n");
        printf("Follow(C) = { ), $ }\n");
        printf("Follow(D) = { ), $ }\n");
    }

.   ;

%%

int yywrap() {
    return 1;
}

int main() {
    printf("Press Enter to display FIRST and FOLLOW sets...\n");
    yylex();
    return 0;
}
