%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int tempCount = 1;

char* newTemp() {
    char *temp = (char*)malloc(10);
    sprintf(temp, "t%d", tempCount++);
    return temp;
}

void printQuad(char *op, char *arg1, char *arg2, char *res) {
    printf("%-10s %-10s %-10s %-10s\n", op, arg1, arg2, res);
}

void yyerror(const char *s);
int yylex();
%}

%union {
    char* str;
}

%token <str> NUMBER
%type <str> E T F

%%

L : L E '\n'   { tempCount = 1; }
  | /* empty */
  ;

E : E '+' T {
        char *temp = newTemp();
        printQuad("+", $1, $3, temp);
        $$ = temp;
    }
  | E '-' T {
        char *temp = newTemp();
        printQuad("-", $1, $3, temp);
        $$ = temp;
    }
  | T { $$ = $1; }
  ;

T : T '*' F {
        char *temp = newTemp();
        printQuad("*", $1, $3, temp);
        $$ = temp;
    }
  | T '/' F {
        char *temp = newTemp();
        printQuad("/", $1, $3, temp);
        $$ = temp;
    }
  | F { $$ = $1; }
  ;

F : '(' E ')' { $$ = $2; }
  | NUMBER    { $$ = $1; }
  ;

%%

void yyerror(const char *s) {
    printf("Invalid expression\n");
}

int main() {
    printf("%-10s %-10s %-10s %-10s\n", "Operator", "Operand1", "Operand2", "Result");
    yyparse();
    return 0;
}