%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char str[100];
int i = 0;
int error_flag = 0;

void S();
void L();
void Ldash();

void error() {
    error_flag = 1;
}

void S() {
    if (str[i] == 'a') {
        i++;
    }
    else if (str[i] == '(') {
        i++;
        L();
        if (str[i] == ')')
            i++;
        else
            error();
    }
    else {
        error();
    }
}

void L() {
    S();
    Ldash();
}

void Ldash() {
    if (str[i] == ',') {
        i++;
        S();
        Ldash();
    }
}
%}

%%

[a(), ]+   { strcpy(str, yytext); }

\n {
        i = 0;
        error_flag = 0;

        S();

        if (str[i] == '\0' && error_flag == 0)
            printf("Valid string\n");
        else
            printf("Invalid string\n");

        printf("\nEnter string: ");
    }

%%

int yywrap() {
    return 1;
}

int main() {
    printf("Enter string: ");
    yylex();
    return 0;
}
